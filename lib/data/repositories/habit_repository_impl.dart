import 'package:drift/drift.dart';
import '../../core/time/time_provider.dart';
import '../../core/utils/formatters.dart';
import '../database/app_database.dart';

class HabitWithStreak {
  final Habit habit;
  final HabitStreak? streak;
  final bool isCompletedToday;

  const HabitWithStreak({
    required this.habit,
    required this.streak,
    required this.isCompletedToday,
  });
}

class HabitRepository {
  final AppDatabase _db;
  final TimeProvider _timeProvider;

  HabitRepository(this._db, this._timeProvider);

  Stream<List<HabitWithStreak>> watchHabits() {
    final todayStr = Formatters.formatFullDate(_timeProvider.todayMidnight());

    return (_db.select(_db.habits)
          ..where((tbl) => tbl.isArchived.equals(false)))
        .watch()
        .asyncMap((habitList) async {
          final results = <HabitWithStreak>[];
          for (final h in habitList) {
            final streak = await (_db.select(
              _db.habitStreaks,
            )..where((tbl) => tbl.habitId.equals(h.id))).getSingleOrNull();

            final todayEntry =
                await (_db.select(_db.habitEntries)..where(
                      (tbl) =>
                          tbl.habitId.equals(h.id) & tbl.date.equals(todayStr),
                    ))
                    .getSingleOrNull();

            results.add(
              HabitWithStreak(
                habit: h,
                streak: streak,
                isCompletedToday: todayEntry?.completed ?? false,
              ),
            );
          }
          return results;
        });
  }

  Future<void> saveHabit({
    required String id,
    required String title,
    String? description,
    String category = 'General',
    int targetDaysPerWeek = 7,
    bool isAvoidance = false,
  }) async {
    await _db
        .into(_db.habits)
        .insertOnConflictUpdate(
          HabitsCompanion.insert(
            id: id,
            title: title,
            description: Value(description),
            category: Value(category),
            targetDaysPerWeek: Value(targetDaysPerWeek),
            isAvoidance: Value(isAvoidance),
          ),
        );
  }

  Future<void> toggleHabitToday(String habitId) async {
    final todayStr = Formatters.formatFullDate(_timeProvider.todayMidnight());
    final existing =
        await (_db.select(_db.habitEntries)..where(
              (tbl) => tbl.habitId.equals(habitId) & tbl.date.equals(todayStr),
            ))
            .getSingleOrNull();

    if (existing == null) {
      await _db
          .into(_db.habitEntries)
          .insert(
            HabitEntriesCompanion.insert(
              habitId: habitId,
              date: todayStr,
              completed: const Value(true),
            ),
          );
    } else {
      await (_db.update(_db.habitEntries)
            ..where((tbl) => tbl.id.equals(existing.id)))
          .write(HabitEntriesCompanion(completed: Value(!existing.completed)));
    }

    await _recalculateStreak(habitId);
  }

  Future<void> _recalculateStreak(String habitId) async {
    final entries =
        await (_db.select(_db.habitEntries)
              ..where(
                (tbl) =>
                    tbl.habitId.equals(habitId) & tbl.completed.equals(true),
              )
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
            .get();

    if (entries.isEmpty) {
      await _db
          .into(_db.habitStreaks)
          .insertOnConflictUpdate(
            HabitStreaksCompanion.insert(
              habitId: habitId,
              currentStreak: const Value(0),
              longestStreak: const Value(0),
            ),
          );
      return;
    }

    var currentStreak = 0;
    var longestStreak = 0;

    final today = _timeProvider.todayMidnight();
    final todayStr = Formatters.formatFullDate(today);
    final yesterdayStr = Formatters.formatFullDate(
      today.subtract(const Duration(days: 1)),
    );

    // Check if streak is active (completed today or yesterday)
    final latestDateStr = entries.first.date;
    final isStreakActive =
        latestDateStr == todayStr || latestDateStr == yesterdayStr;

    // 1. Calculate active current streak starting from the newest entry
    if (isStreakActive) {
      currentStreak = 1;
      var prev = DateTime.parse(entries.first.date);
      for (var i = 1; i < entries.length; i++) {
        final cur = DateTime.parse(entries[i].date);
        if (prev.difference(cur).inDays == 1) {
          currentStreak++;
          prev = cur;
        } else {
          break; // Stop counting at the first gap in days
        }
      }
    }

    // 2. Calculate longest streak across entire history
    var tempStreak = 0;
    DateTime? prevHistoryDate;
    for (final entry in entries) {
      final entryDate = DateTime.parse(entry.date);
      if (prevHistoryDate == null) {
        tempStreak = 1;
      } else {
        final diff = prevHistoryDate.difference(entryDate).inDays;
        if (diff == 1) {
          tempStreak++;
        } else {
          if (tempStreak > longestStreak) longestStreak = tempStreak;
          tempStreak = 1;
        }
      }
      prevHistoryDate = entryDate;
    }
    if (tempStreak > longestStreak) longestStreak = tempStreak;
    if (currentStreak > longestStreak) longestStreak = currentStreak;

    await _db
        .into(_db.habitStreaks)
        .insertOnConflictUpdate(
          HabitStreaksCompanion.insert(
            habitId: habitId,
            currentStreak: Value(currentStreak),
            longestStreak: Value(longestStreak),
            lastCompletedDate: Value(latestDateStr),
          ),
        );
  }

  Future<List<HabitEntry>> getEntriesForMonth(
    String habitId,
    int year,
    int month,
  ) {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    return (_db.select(_db.habitEntries)
          ..where(
            (tbl) => tbl.habitId.equals(habitId) & tbl.date.like('$prefix%'),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]))
        .get();
  }
}
