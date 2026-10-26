import 'package:digital_balance/core/time/time_provider.dart';
import 'package:digital_balance/data/database/app_database.dart';
import 'package:digital_balance/data/repositories/habit_repository_impl.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedTimeProvider extends TimeProvider {
  final DateTime _fixed;
  _FixedTimeProvider(this._fixed);

  @override
  DateTime now() => _fixed;

  @override
  DateTime todayMidnight() => DateTime(_fixed.year, _fixed.month, _fixed.day);

  @override
  int currentUtcTimestampMs() => _fixed.toUtc().millisecondsSinceEpoch;
}

int computeStreak({
  required List<String> sortedDescDateStrings,
  required String todayString,
  required String yesterdayString,
}) {
  if (sortedDescDateStrings.isEmpty) return 0;

  final latestDateStr = sortedDescDateStrings.first;
  final isStreakActive =
      latestDateStr == todayString || latestDateStr == yesterdayString;
  if (!isStreakActive) return 0;

  var currentStreak = 1;
  DateTime previousDate = DateTime.parse(latestDateStr);

  for (var i = 1; i < sortedDescDateStrings.length; i++) {
    final entryDate = DateTime.parse(sortedDescDateStrings[i]);
    final diff = previousDate.difference(entryDate).inDays;
    if (diff == 1) {
      currentStreak++;
      previousDate = entryDate;
    } else {
      break;
    }
  }

  return currentStreak;
}

void main() {
  group('Habit Streak Calculator Tests', () {
    const today = '2026-10-12';
    const yesterday = '2026-10-11';

    test('Returns 0 for empty completion history', () {
      expect(
        computeStreak(
          sortedDescDateStrings: [],
          todayString: today,
          yesterdayString: yesterday,
        ),
        equals(0),
      );
    });

    test('Returns 1 when completed only today', () {
      final dates = ['2026-10-12'];
      expect(
        computeStreak(
          sortedDescDateStrings: dates,
          todayString: today,
          yesterdayString: yesterday,
        ),
        equals(1),
      );
    });

    test('Returns 1 when completed yesterday but not yet today', () {
      final dates = ['2026-10-11'];
      expect(
        computeStreak(
          sortedDescDateStrings: dates,
          todayString: today,
          yesterdayString: yesterday,
        ),
        equals(1),
      );
    });

    test('Computes multi-day consecutive streak correctly', () {
      final dates = ['2026-10-12', '2026-10-11', '2026-10-10', '2026-10-09'];
      expect(
        computeStreak(
          sortedDescDateStrings: dates,
          todayString: today,
          yesterdayString: yesterday,
        ),
        equals(4),
      );
    });

    test('Resets streak to 0 if missed yesterday and today', () {
      final dates = ['2026-10-10', '2026-10-09', '2026-10-08'];
      expect(
        computeStreak(
          sortedDescDateStrings: dates,
          todayString: today,
          yesterdayString: yesterday,
        ),
        equals(0),
      );
    });

    test('Stops counting at gap in days', () {
      final dates = ['2026-10-12', '2026-10-11', '2026-10-09', '2026-10-08'];
      expect(
        computeStreak(
          sortedDescDateStrings: dates,
          todayString: today,
          yesterdayString: yesterday,
        ),
        equals(2),
      );
    });

    test('HabitRepository calculates active currentStreak=2 and longestStreak=5 correctly', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final timeProvider = _FixedTimeProvider(DateTime(2026, 10, 12, 12, 0));
      final repo = HabitRepository(db, timeProvider);

      await repo.saveHabit(
        id: 'habit_run',
        title: 'Daily Running',
      );

      // Past streak: 5 consecutive days (Oct 5 to Oct 9)
      for (final d in ['2026-10-05', '2026-10-06', '2026-10-07', '2026-10-08', '2026-10-09']) {
        await db.into(db.habitEntries).insert(
          HabitEntriesCompanion.insert(
            habitId: 'habit_run',
            date: d,
            completed: const Value(true),
          ),
        );
      }

      // Missed Oct 10 (gap)

      // Active streak: yesterday (Oct 11)
      await db.into(db.habitEntries).insert(
        HabitEntriesCompanion.insert(
          habitId: 'habit_run',
          date: '2026-10-11',
          completed: const Value(true),
        ),
      );

      // Complete today (Oct 12) via repo
      await repo.toggleHabitToday('habit_run');

      // Check recalculated streaks
      final streak = await (db.select(db.habitStreaks)..where((tbl) => tbl.habitId.equals('habit_run'))).getSingle();
      expect(streak.currentStreak, equals(2)); // Oct 11 + Oct 12 only
      expect(streak.longestStreak, equals(5)); // Historic 5 days

      await db.close();
    });
  });
}
