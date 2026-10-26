import 'package:drift/drift.dart';
import '../../core/logging/app_logger.dart';
import '../../core/platform/platform_bridge.dart';
import '../../core/time/time_provider.dart';
import '../../core/utils/formatters.dart';
import '../database/app_database.dart';

class AppUsageWithCatalog {
  final UsageDailyData usage;
  final String appName;

  const AppUsageWithCatalog({
    required this.usage,
    required this.appName,
  });
}

class DailyUsageTotal {
  final DateTime date;
  final String dateStr;
  final int totalMinutes;
  final String dayOfWeekLabel;

  const DailyUsageTotal({
    required this.date,
    required this.dateStr,
    required this.totalMinutes,
    required this.dayOfWeekLabel,
  });
}

class UsageRepository {
  final AppDatabase _db;
  final PlatformBridge _bridge;
  final TimeProvider _timeProvider;

  UsageRepository(this._db, this._bridge, this._timeProvider);

  /// Synchronizes usage data from Android UsageStatsManager into local Drift database
  /// Automatically cleans today's records and backfills recent days if requested
  Future<bool> syncUsageData({int backfillDays = 7}) async {
    try {
      final now = _timeProvider.now();
      final todayStart = _timeProvider.todayMidnight();
      final todayStr = Formatters.formatFullDate(todayStart);

      final startTimeMs = todayStart.millisecondsSinceEpoch;
      final endTimeMs = now.millisecondsSinceEpoch;

      final result = await _bridge.queryUsage(
        startTimeMs: startTimeMs,
        endTimeMs: endTimeMs,
      );

      if (!result.success) {
        AppLogger.warning('Usage query returned failure: ${result.error}');
        await _db
            .into(_db.usageSyncState)
            .insert(
              UsageSyncStateCompanion.insert(
                lastSyncUtcMs: _timeProvider.currentUtcTimestampMs(),
                syncStatus: 'failed',
                errorMessage: Value(result.error),
              ),
            );
        return false;
      }

      // Batch insert or update daily usage for today
      await _db.transaction(() async {
        // Clear today's previous records to eliminate stale/dirty calculations
        await (_db.delete(_db.usageDaily)
              ..where((tbl) => tbl.date.equals(todayStr)))
            .go();

        for (final app in result.apps) {
          await _db
              .into(_db.usageDaily)
              .insertOnConflictUpdate(
                UsageDailyCompanion.insert(
                  date: todayStr,
                  packageName: app.packageName,
                  foregroundTimeMs: Value(app.foregroundTimeMs),
                  launchCount: Value(app.launchCount),
                  lastUsedUtcMs: Value(app.lastTimeUsedMs),
                ),
              );

          if (app.appName.isNotEmpty) {
            await _db
                .into(_db.appCatalog)
                .insert(
                  AppCatalogCompanion.insert(
                    packageName: app.packageName,
                    appName: app.appName,
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
          }
        }

        // Record real 24-hour distribution for today
        await (_db.delete(_db.usageHourly)
              ..where((tbl) => tbl.date.equals(todayStr)))
            .go();

        for (var hour = 0; hour < 24; hour++) {
          final ms = (hour < result.hourlyForegroundTimeMs.length)
              ? result.hourlyForegroundTimeMs[hour]
              : 0;
          final unlocks = (hour < result.hourlyUnlocks.length)
              ? result.hourlyUnlocks[hour]
              : 0;

          await _db
              .into(_db.usageHourly)
              .insert(
                UsageHourlyCompanion.insert(
                  date: todayStr,
                  hourOfDay: hour,
                  foregroundTimeMs: Value(ms),
                  deviceUnlocks: Value(unlocks),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }

        // Record notifications count
        await _db.into(_db.userSettings).insert(
              UserSettingsCompanion.insert(
                key: 'today_notifications_$todayStr',
                value: result.notificationCount.toString(),
              ),
              mode: InsertMode.insertOrReplace,
            );

        // Record success in sync state
        await _db
            .into(_db.usageSyncState)
            .insert(
              UsageSyncStateCompanion.insert(
                lastSyncUtcMs: _timeProvider.currentUtcTimestampMs(),
                syncStatus: 'success',
              ),
            );
      });

      // Backfill previous days so weekly analytics have full real telemetry
      if (backfillDays > 1) {
        for (var i = 1; i < backfillDays; i++) {
          final day = now.subtract(Duration(days: i));
          final dayStart = DateTime(day.year, day.month, day.day);
          final dayEnd = DateTime(
            day.year,
            day.month,
            day.day,
            23,
            59,
            59,
            999,
          );
          final dateStr = Formatters.formatFullDate(dayStart);

          final pastResult = await _bridge.queryUsage(
            startTimeMs: dayStart.millisecondsSinceEpoch,
            endTimeMs: dayEnd.millisecondsSinceEpoch,
          );

          if (pastResult.success && pastResult.apps.isNotEmpty) {
            await _db.transaction(() async {
              await (_db.delete(_db.usageDaily)
                    ..where((tbl) => tbl.date.equals(dateStr)))
                  .go();

              for (final app in pastResult.apps) {
                await _db
                    .into(_db.usageDaily)
                    .insertOnConflictUpdate(
                      UsageDailyCompanion.insert(
                        date: dateStr,
                        packageName: app.packageName,
                        foregroundTimeMs: Value(app.foregroundTimeMs),
                        launchCount: Value(app.launchCount),
                        lastUsedUtcMs: Value(app.lastTimeUsedMs),
                      ),
                    );

                if (app.appName.isNotEmpty) {
                  await _db
                      .into(_db.appCatalog)
                      .insert(
                        AppCatalogCompanion.insert(
                          packageName: app.packageName,
                          appName: app.appName,
                        ),
                        mode: InsertMode.insertOrIgnore,
                      );
                }
              }

              await (_db.delete(_db.usageHourly)
                    ..where((tbl) => tbl.date.equals(dateStr)))
                  .go();

              for (var hour = 0; hour < 24; hour++) {
                final ms = (hour < pastResult.hourlyForegroundTimeMs.length)
                    ? pastResult.hourlyForegroundTimeMs[hour]
                    : 0;
                final unlocks = (hour < pastResult.hourlyUnlocks.length)
                    ? pastResult.hourlyUnlocks[hour]
                    : 0;

                await _db
                    .into(_db.usageHourly)
                    .insert(
                      UsageHourlyCompanion.insert(
                        date: dateStr,
                        hourOfDay: hour,
                        foregroundTimeMs: Value(ms),
                        deviceUnlocks: Value(unlocks),
                      ),
                      mode: InsertMode.insertOrReplace,
                    );
              }
            });
          }
        }
      }

      return true;
    } catch (e, st) {
      AppLogger.error('Failed to sync usage data', e, st);
      return false;
    }
  }

  Stream<List<UsageDailyData>> watchTodayUsage() {
    final todayStr = Formatters.formatFullDate(_timeProvider.todayMidnight());
    return (_db.select(_db.usageDaily)
          ..where((tbl) => tbl.date.equals(todayStr))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.foregroundTimeMs)]))
        .watch();
  }

  Stream<List<AppUsageWithCatalog>> watchTodayUsageWithCatalog() {
    final todayStr = Formatters.formatFullDate(_timeProvider.todayMidnight());
    final query =
        _db.select(_db.usageDaily).join([
            leftOuterJoin(
              _db.appCatalog,
              _db.appCatalog.packageName.equalsExp(_db.usageDaily.packageName),
            ),
          ])
          ..where(_db.usageDaily.date.equals(todayStr))
          ..orderBy([OrderingTerm.desc(_db.usageDaily.foregroundTimeMs)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final usage = row.readTable(_db.usageDaily);
        final catalog = row.readTableOrNull(_db.appCatalog);
        final displayName =
            (catalog?.appName != null && catalog!.appName.isNotEmpty)
            ? catalog.appName
            : usage.packageName.split('.').last;
        return AppUsageWithCatalog(usage: usage, appName: displayName);
      }).toList();
    });
  }

  Stream<List<AppUsageWithCatalog>> watchDateUsageWithCatalog(String date) {
    final query =
        _db.select(_db.usageDaily).join([
            leftOuterJoin(
              _db.appCatalog,
              _db.appCatalog.packageName.equalsExp(_db.usageDaily.packageName),
            ),
          ])
          ..where(_db.usageDaily.date.equals(date))
          ..orderBy([OrderingTerm.desc(_db.usageDaily.foregroundTimeMs)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final usage = row.readTable(_db.usageDaily);
        final catalog = row.readTableOrNull(_db.appCatalog);
        final displayName =
            (catalog?.appName != null && catalog!.appName.isNotEmpty)
            ? catalog.appName
            : usage.packageName.split('.').last;
        return AppUsageWithCatalog(usage: usage, appName: displayName);
      }).toList();
    });
  }

  Stream<List<AppUsageWithCatalog>> watchRangeUsageWithCatalog(
    String startDate,
    String endDate,
  ) {
    final query = _db.select(_db.usageDaily).join([
      leftOuterJoin(
        _db.appCatalog,
        _db.appCatalog.packageName.equalsExp(_db.usageDaily.packageName),
      ),
    ])..where(
      _db.usageDaily.date.isBiggerOrEqualValue(startDate) &
          _db.usageDaily.date.isSmallerOrEqualValue(endDate),
    );

    return query.watch().map((rows) {
      final appMap = <String, AppUsageWithCatalog>{};
      for (final row in rows) {
        final usage = row.readTable(_db.usageDaily);
        final catalog = row.readTableOrNull(_db.appCatalog);
        final displayName =
            (catalog?.appName != null && catalog!.appName.isNotEmpty)
            ? catalog.appName
            : usage.packageName.split('.').last;

        if (!appMap.containsKey(usage.packageName)) {
          appMap[usage.packageName] = AppUsageWithCatalog(
            usage: usage,
            appName: displayName,
          );
        } else {
          final existing = appMap[usage.packageName]!;
          final aggregatedUsage = UsageDailyData(
            date: startDate,
            packageName: usage.packageName,
            foregroundTimeMs:
                existing.usage.foregroundTimeMs + usage.foregroundTimeMs,
            launchCount: existing.usage.launchCount + usage.launchCount,
            lastUsedUtcMs: (usage.lastUsedUtcMs > existing.usage.lastUsedUtcMs)
                ? usage.lastUsedUtcMs
                : existing.usage.lastUsedUtcMs,
          );
          appMap[usage.packageName] = AppUsageWithCatalog(
            usage: aggregatedUsage,
            appName: displayName,
          );
        }
      }

      final list = appMap.values.toList();
      list.sort(
        (a, b) => b.usage.foregroundTimeMs.compareTo(a.usage.foregroundTimeMs),
      );
      return list;
    });
  }

  Stream<List<DailyUsageTotal>> watchRecentDailyTotals({int days = 7}) {
    final now = _timeProvider.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final startStr = Formatters.formatFullDate(startDate);
    final endStr = Formatters.formatFullDate(now);

    final query = _db.select(_db.usageDaily)
      ..where(
        (tbl) =>
            tbl.date.isBiggerOrEqualValue(startStr) &
            tbl.date.isSmallerOrEqualValue(endStr),
      );

    return query.watch().map((rows) {
      final totalsByDate = <String, int>{};
      for (final row in rows) {
        totalsByDate[row.date] =
            (totalsByDate[row.date] ?? 0) + row.foregroundTimeMs;
      }

      final result = <DailyUsageTotal>[];
      for (var i = days - 1; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final dateStr = Formatters.formatFullDate(day);
        final ms = totalsByDate[dateStr] ?? 0;
        final totalMins = (ms / (1000 * 60)).round();

        const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final dayLabel = dayNames[(day.weekday - 1) % 7];

        result.add(
          DailyUsageTotal(
            date: day,
            dateStr: dateStr,
            totalMinutes: totalMins,
            dayOfWeekLabel: dayLabel,
          ),
        );
      }
      return result;
    });
  }

  Stream<List<UsageDailyData>> watchDateUsage(String date) {
    return (_db.select(_db.usageDaily)
          ..where((tbl) => tbl.date.equals(date))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.foregroundTimeMs)]))
        .watch();
  }

  Future<List<UsageDailyData>> getTodayTopApps({int limit = 5}) async {
    final todayStr = Formatters.formatFullDate(_timeProvider.todayMidnight());
    return (_db.select(_db.usageDaily)
          ..where((tbl) => tbl.date.equals(todayStr))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.foregroundTimeMs)])
          ..limit(limit))
        .get();
  }

  Future<int> getTodayTotalMinutes() async {
    final todayStr = Formatters.formatFullDate(_timeProvider.todayMidnight());
    final records = await (_db.select(
      _db.usageDaily,
    )..where((tbl) => tbl.date.equals(todayStr))).get();

    var totalMs = 0;
    for (final r in records) {
      totalMs += r.foregroundTimeMs;
    }
    return (totalMs / (1000 * 60)).round();
  }

  Future<int> getYesterdayTotalMinutes() async {
    final yesterday = _timeProvider.todayMidnight().subtract(
      const Duration(days: 1),
    );
    final yesterdayStr = Formatters.formatFullDate(yesterday);
    final records = await (_db.select(
      _db.usageDaily,
    )..where((tbl) => tbl.date.equals(yesterdayStr))).get();

    var totalMs = 0;
    for (final r in records) {
      totalMs += r.foregroundTimeMs;
    }
    return (totalMs / (1000 * 60)).round();
  }

  Stream<List<UsageHourlyData>> watchHourlyUsage(String date) {
    return (_db.select(_db.usageHourly)
          ..where((tbl) => tbl.date.equals(date))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.hourOfDay)]))
        .watch();
  }

  Future<UsageSyncStateData?> getLastSyncState() async {
    return (_db.select(_db.usageSyncState)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<int> watchTodayNotificationCount() {
    final todayStr = Formatters.formatFullDate(_timeProvider.todayMidnight());
    return (_db.select(_db.userSettings)
          ..where((tbl) => tbl.key.equals('today_notifications_$todayStr')))
        .watchSingleOrNull()
        .map((entry) => int.tryParse(entry?.value ?? '0') ?? 0);
  }

  Stream<List<DailyUsageTotal>> watchAppLast7DaysUsage(String packageName) {
    final now = _timeProvider.now();
    final startDate = now.subtract(const Duration(days: 6));
    final startStr = Formatters.formatFullDate(startDate);
    final endStr = Formatters.formatFullDate(now);

    final query = _db.select(_db.usageDaily)
      ..where(
        (tbl) =>
            tbl.packageName.equals(packageName) &
            tbl.date.isBiggerOrEqualValue(startStr) &
            tbl.date.isSmallerOrEqualValue(endStr),
      );

    return query.watch().map((rows) {
      final totalsByDate = <String, int>{};
      for (final row in rows) {
        totalsByDate[row.date] =
            (totalsByDate[row.date] ?? 0) + row.foregroundTimeMs;
      }

      final result = <DailyUsageTotal>[];
      for (var i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final dateStr = Formatters.formatFullDate(day);
        final ms = totalsByDate[dateStr] ?? 0;
        final totalMins = (ms / (1000 * 60)).round();

        const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final dayLabel = dayNames[(day.weekday - 1) % 7];

        result.add(
          DailyUsageTotal(
            date: day,
            dateStr: dateStr,
            totalMinutes: totalMins,
            dayOfWeekLabel: dayLabel,
          ),
        );
      }
      return result;
    });
  }

  Future<int> getAppUsageForDate(String packageName, String date) async {
    final row = await (_db.select(_db.usageDaily)
          ..where(
            (tbl) =>
                tbl.packageName.equals(packageName) & tbl.date.equals(date),
          ))
        .getSingleOrNull();
    return ((row?.foregroundTimeMs ?? 0) / (1000 * 60)).round();
  }
}
