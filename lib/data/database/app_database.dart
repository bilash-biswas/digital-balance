import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/all_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AppCatalog,
    AppCategories,
    UsageDaily,
    UsageHourly,
    UsageSyncState,
    RestrictionRules,
    RestrictionTargets,
    RestrictionOverrides,
    FocusProfiles,
    FocusSessions,
    Routines,
    RoutineSteps,
    Habits,
    HabitEntries,
    HabitStreaks,
    Insights,
    CustomGoals,
    UserSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'digital_balance_db');
  }

  // Pre-populate default categories and profiles on first open
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();

      // Seed default categories
      final defaultCategories = [
        AppCategoriesCompanion.insert(
          name: 'Social',
          colorHex: const Value('#E91E63'),
          iconName: const Value('people'),
        ),
        AppCategoriesCompanion.insert(
          name: 'Entertainment',
          colorHex: const Value('#9C27B0'),
          iconName: const Value('movie'),
        ),
        AppCategoriesCompanion.insert(
          name: 'Productivity',
          colorHex: const Value('#2196F3'),
          iconName: const Value('work'),
        ),
        AppCategoriesCompanion.insert(
          name: 'Communication',
          colorHex: const Value('#00BCD4'),
          iconName: const Value('chat'),
        ),
        AppCategoriesCompanion.insert(
          name: 'Games',
          colorHex: const Value('#FF9800'),
          iconName: const Value('games'),
        ),
        AppCategoriesCompanion.insert(
          name: 'Education',
          colorHex: const Value('#4CAF50'),
          iconName: const Value('school'),
        ),
        AppCategoriesCompanion.insert(
          name: 'Uncategorized',
          colorHex: const Value('#757575'),
          iconName: const Value('apps'),
        ),
      ];
      for (final cat in defaultCategories) {
        await into(appCategories).insert(cat, mode: InsertMode.insertOrIgnore);
      }

      // Seed default focus profile
      await into(focusProfiles).insert(
        FocusProfilesCompanion.insert(
          id: 'default_pomodoro',
          name: 'Pomodoro Focus',
          durationMinutes: const Value(25),
          shortBreakMinutes: const Value(5),
          longBreakMinutes: const Value(15),
          cycles: const Value(4),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    },
  );
}
