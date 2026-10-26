import 'package:drift/drift.dart';
import '../../core/time/time_provider.dart';
import '../../core/utils/formatters.dart';
import '../database/app_database.dart';

class InsightRepository {
  final AppDatabase _db;
  final TimeProvider _timeProvider;

  InsightRepository(this._db, this._timeProvider);

  Stream<List<Insight>> watchInsights() {
    return (_db.select(_db.insights)
          ..where((tbl) => tbl.isDismissed.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
          ..limit(10))
        .watch();
  }

  Future<void> dismissInsight(String id) async {
    await (_db.update(_db.insights)..where((tbl) => tbl.id.equals(id))).write(
      const InsightsCompanion(isDismissed: Value(true)),
    );
  }

  /// Deterministic, nonjudgmental local insights evaluation
  Future<void> generateInsights({
    required int todayTotalMinutes,
    required int yesterdayTotalMinutes,
    required int dailyGoalMinutes,
    required List<UsageDailyData> topApps,
  }) async {
    final now = _timeProvider.now();

    // 1. Screen Time Trend Insight
    if (yesterdayTotalMinutes > 0 && todayTotalMinutes > 0) {
      final diff = todayTotalMinutes - yesterdayTotalMinutes;
      final percentChange = ((diff.abs() / yesterdayTotalMinutes) * 100)
          .round();

      if (diff < -15) {
        await _insertInsight(
          id: 'trend_${Formatters.formatFullDate(now)}',
          title: 'Decreased screen time',
          message:
              'Your screen time is $percentChange% lower compared to yesterday at this time.',
          type: 'achievement',
          evidence:
              'Today: ${Formatters.formatDurationMinutes(todayTotalMinutes)}, Yesterday: ${Formatters.formatDurationMinutes(yesterdayTotalMinutes)}',
        );
      } else if (diff > 30) {
        await _insertInsight(
          id: 'trend_${Formatters.formatFullDate(now)}',
          title: 'Increased screen time',
          message:
              'Your screen time is $percentChange% higher compared to yesterday.',
          type: 'trend',
          evidence:
              'Today: ${Formatters.formatDurationMinutes(todayTotalMinutes)}, Yesterday: ${Formatters.formatDurationMinutes(yesterdayTotalMinutes)}',
        );
      }
    }

    // 2. Dominant Distraction App Insight
    if (topApps.isNotEmpty && todayTotalMinutes >= 30) {
      final topApp = topApps.first;
      final topAppMinutes = (topApp.foregroundTimeMs / (1000 * 60)).round();
      final share = ((topAppMinutes / todayTotalMinutes) * 100).round();

      if (share >= 40) {
        final catalogEntry =
            await (_db.select(_db.appCatalog)
                  ..where((tbl) => tbl.packageName.equals(topApp.packageName)))
                .getSingleOrNull();
        final name = catalogEntry?.appName ?? topApp.packageName;

        await _insertInsight(
          id: 'dominant_${topApp.packageName}_${Formatters.formatFullDate(now)}',
          title: '$name usage focus',
          message:
              '$name represents $share% of your device usage today ($topAppMinutes mins).',
          type: 'suggestion',
          evidence:
              'Single-app concentration: $topAppMinutes / $todayTotalMinutes minutes',
        );
      }
    }

    // 3. Daily Goal Progress & Milestone Insights
    if (dailyGoalMinutes > 0) {
      final percentOfGoal =
          ((todayTotalMinutes / dailyGoalMinutes) * 100).round();
      final dateStr = Formatters.formatFullDate(now);

      if (todayTotalMinutes >= dailyGoalMinutes) {
        await _insertInsight(
          id: 'goal_exceeded_$dateStr',
          title: 'Daily goal reached',
          message:
              'You have reached your daily total target of ${Formatters.formatDurationMinutes(dailyGoalMinutes)}.',
          type: 'warning',
          evidence:
              '$todayTotalMinutes minutes used vs $dailyGoalMinutes minutes goal ($percentOfGoal%)',
        );
      } else if (percentOfGoal >= 90) {
        await _insertInsight(
          id: 'goal_90_$dateStr',
          title: '90% of daily target used',
          message:
              'You are approaching your daily total limit. ${Formatters.formatDurationMinutes(dailyGoalMinutes - todayTotalMinutes)} remaining.',
          type: 'warning',
          evidence:
              '$todayTotalMinutes / $dailyGoalMinutes minutes ($percentOfGoal%)',
        );
      } else if (percentOfGoal >= 75) {
        await _insertInsight(
          id: 'goal_75_$dateStr',
          title: '75% of daily target reached',
          message:
              'Mindful check-in: You have used three-quarters of your screen time target today.',
          type: 'trend',
          evidence:
              '$todayTotalMinutes / $dailyGoalMinutes minutes ($percentOfGoal%)',
        );
      }
    }
  }

  Future<void> _insertInsight({
    required String id,
    required String title,
    required String message,
    required String type,
    required String evidence,
  }) async {
    await _db
        .into(_db.insights)
        .insertOnConflictUpdate(
          InsightsCompanion.insert(
            id: id,
            title: title,
            message: message,
            type: type,
            evidence: evidence,
            isDismissed: const Value(false),
            createdAt: Value(DateTime.now()),
          ),
        );
  }
}
