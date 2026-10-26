import 'package:digital_balance/core/platform/platform_bridge.dart';
import 'package:digital_balance/core/time/time_provider.dart';
import 'package:digital_balance/data/database/app_database.dart';
import 'package:digital_balance/data/repositories/usage_repository_impl.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPlatformBridge extends PlatformBridge {
  UsageResultDto mockResult = const UsageResultDto(
    success: true,
    apps: [
      AppUsageDto(
        packageName: 'com.facebook.katana',
        appName: 'Facebook',
        foregroundTimeMs: 12540000, // 3h 29m
        lastTimeUsedMs: 1690000000000,
        launchCount: 14,
      ),
      AppUsageDto(
        packageName: 'jp.konami.pesam',
        appName: 'eFootball™',
        foregroundTimeMs: 4920000, // 1h 22m
        lastTimeUsedMs: 1690000000000,
        launchCount: 5,
      ),
    ],
    deviceUnlocks: 42,
    hourlyForegroundTimeMs: [
      0, 0, 0, 0, 0, 0,
      120000, 300000, 600000, 900000, 1200000, 1500000,
      1800000, 2400000, 3000000, 2100000, 1800000, 1200000,
      900000, 600000, 300000, 100000, 0, 0,
    ],
    hourlyUnlocks: [
      0, 0, 0, 0, 0, 0,
      2, 3, 5, 4, 3, 2,
      4, 5, 6, 3, 2, 1,
      1, 1, 0, 0, 0, 0,
    ],
  );

  @override
  Future<UsageResultDto> queryUsage({
    required int startTimeMs,
    required int endTimeMs,
  }) async {
    return mockResult;
  }
}

class FixedTimeProvider implements TimeProvider {
  final DateTime _fixed;
  FixedTimeProvider(this._fixed);

  @override
  DateTime now() => _fixed;

  @override
  DateTime todayMidnight() => DateTime(_fixed.year, _fixed.month, _fixed.day);

  @override
  int currentUtcTimestampMs() => _fixed.toUtc().millisecondsSinceEpoch;
}

void main() {
  late AppDatabase db;
  late MockPlatformBridge bridge;
  late FixedTimeProvider timeProvider;
  late UsageRepository repo;

  final testDate = DateTime(2026, 10, 12, 15, 30);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    bridge = MockPlatformBridge();
    timeProvider = FixedTimeProvider(testDate);
    repo = UsageRepository(db, bridge, timeProvider);
  });

  tearDown(() async {
    await db.close();
  });

  group('Usage Analytics & Repository Tests', () {
    test('syncUsageData cleans dirty records, inserts real events, and populates 24-hour distribution', () async {
      // Pre-insert dirty inflated data
      await db.into(db.usageDaily).insert(
        const UsageDailyCompanion(
          date: Value('2026-10-12'),
          packageName: Value('com.facebook.katana'),
          foregroundTimeMs: Value(99999999), // Corrupted 27 hours
        ),
      );

      final success = await repo.syncUsageData(backfillDays: 1);
      expect(success, isTrue);

      // Verify dirty record was replaced by clean event-stream telemetry
      final todayApps = await repo.watchTodayUsageWithCatalog().first;
      expect(todayApps.length, equals(2));
      expect(todayApps.first.appName, equals('Facebook'));
      expect(todayApps.first.usage.foregroundTimeMs, equals(12540000));
      expect(todayApps[1].appName, equals('eFootball™'));
      expect(todayApps[1].usage.foregroundTimeMs, equals(4920000));

      // Verify hourly distribution has 24 entries
      final hourly = await repo.watchHourlyUsage('2026-10-12').first;
      expect(hourly.length, equals(24));
      expect(hourly[14].foregroundTimeMs, equals(3000000));
      expect(hourly[14].deviceUnlocks, equals(6));
    });

    test('watchRecentDailyTotals correctly computes 7 days of daily minutes', () async {
      // Insert usage across several days
      await db.into(db.usageDaily).insert(
        const UsageDailyCompanion(
          date: Value('2026-10-10'),
          packageName: Value('com.whatsapp'),
          foregroundTimeMs: Value(3600000), // 60 mins
        ),
      );
      await db.into(db.usageDaily).insert(
        const UsageDailyCompanion(
          date: Value('2026-10-11'),
          packageName: Value('com.google.android.youtube'),
          foregroundTimeMs: Value(7200000), // 120 mins
        ),
      );
      await db.into(db.usageDaily).insert(
        const UsageDailyCompanion(
          date: Value('2026-10-12'),
          packageName: Value('com.facebook.katana'),
          foregroundTimeMs: Value(10800000), // 180 mins
        ),
      );

      final totals = await repo.watchRecentDailyTotals(days: 7).first;
      expect(totals.length, equals(7));

      // October 12 is index 6 (today)
      expect(totals[6].dateStr, equals('2026-10-12'));
      expect(totals[6].totalMinutes, equals(180));

      // October 11 is index 5
      expect(totals[5].dateStr, equals('2026-10-11'));
      expect(totals[5].totalMinutes, equals(120));

      // October 10 is index 4
      expect(totals[4].dateStr, equals('2026-10-10'));
      expect(totals[4].totalMinutes, equals(60));

      // Older days have 0 minutes
      expect(totals[0].totalMinutes, equals(0));
    });

    test('watchRangeUsageWithCatalog aggregates multi-day app usage and matches catalog names', () async {
      // Setup AppCatalog names
      await db.into(db.appCatalog).insert(
        const AppCatalogCompanion(
          packageName: Value('com.facebook.katana'),
          appName: Value('Facebook'),
        ),
      );
      await db.into(db.appCatalog).insert(
        const AppCatalogCompanion(
          packageName: Value('jp.konami.pesam'),
          appName: Value('eFootball™'),
        ),
      );

      // Insert multiple days of usage
      await db.into(db.usageDaily).insert(
        const UsageDailyCompanion(
          date: Value('2026-10-11'),
          packageName: Value('com.facebook.katana'),
          foregroundTimeMs: Value(6000000),
          launchCount: Value(10),
        ),
      );
      await db.into(db.usageDaily).insert(
        const UsageDailyCompanion(
          date: Value('2026-10-12'),
          packageName: Value('com.facebook.katana'),
          foregroundTimeMs: Value(4000000),
          launchCount: Value(5),
        ),
      );
      await db.into(db.usageDaily).insert(
        const UsageDailyCompanion(
          date: Value('2026-10-12'),
          packageName: Value('jp.konami.pesam'),
          foregroundTimeMs: Value(5000000),
          launchCount: Value(3),
        ),
      );

      final aggregated = await repo.watchRangeUsageWithCatalog('2026-10-11', '2026-10-12').first;
      expect(aggregated.length, equals(2));

      // Facebook: 6000000 + 4000000 = 10000000, 15 launches
      expect(aggregated[0].appName, equals('Facebook'));
      expect(aggregated[0].usage.foregroundTimeMs, equals(10000000));
      expect(aggregated[0].usage.launchCount, equals(15));

      // eFootball: 5000000, 3 launches
      expect(aggregated[1].appName, equals('eFootball™'));
      expect(aggregated[1].usage.foregroundTimeMs, equals(5000000));
      expect(aggregated[1].usage.launchCount, equals(3));
    });
  });
}
