import 'package:drift/drift.dart';

class AppCatalog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text().unique()();
  TextColumn get appName => text()();
  BoolColumn get isSystemApp => boolean().withDefault(const Constant(false))();
  TextColumn get iconPath => text().nullable()();
  IntColumn get categoryId => integer().nullable()();
  BoolColumn get isExcluded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class AppCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get colorHex => text().withDefault(const Constant('#3F51B5'))();
  TextColumn get iconName => text().withDefault(const Constant('category'))();
}

class UsageDaily extends Table {
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get packageName => text()();
  IntColumn get foregroundTimeMs => integer().withDefault(const Constant(0))();
  IntColumn get launchCount => integer().withDefault(const Constant(0))();
  IntColumn get lastUsedUtcMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date, packageName};
}

class UsageHourly extends Table {
  TextColumn get date => text()(); // YYYY-MM-DD
  IntColumn get hourOfDay => integer()(); // 0 - 23
  IntColumn get foregroundTimeMs => integer().withDefault(const Constant(0))();
  IntColumn get deviceUnlocks => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date, hourOfDay};
}

class UsageSyncState extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lastSyncUtcMs => integer()();
  TextColumn get syncStatus => text()(); // 'success', 'failed'
  TextColumn get errorMessage => text().nullable()();
}

class RestrictionRules extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  IntColumn get limitMinutesPerDay =>
      integer().withDefault(const Constant(0))();
  IntColumn get startMinuteOfDay => integer().withDefault(const Constant(-1))();
  IntColumn get endMinuteOfDay => integer().withDefault(const Constant(-1))();
  TextColumn get daysOfWeek =>
      text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isTemporaryBlock =>
      boolean().withDefault(const Constant(false))();
  IntColumn get tempBlockUntilMs => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class RestrictionTargets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ruleId => text()();
  TextColumn get packageName => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {ruleId, packageName},
  ];
}

class RestrictionOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ruleId => text()();
  TextColumn get packageName => text()();
  IntColumn get overrideUntilMs => integer()();
  IntColumn get durationMinutes => integer()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class FocusProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(25))();
  IntColumn get shortBreakMinutes => integer().withDefault(const Constant(5))();
  IntColumn get longBreakMinutes => integer().withDefault(const Constant(15))();
  IntColumn get cycles => integer().withDefault(const Constant(4))();
  BoolColumn get allowlistOnly =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().nullable()();
  IntColumn get startedAtUtcMs => integer()();
  IntColumn get targetDurationMinutes => integer()();
  IntColumn get completedMinutes => integer().withDefault(const Constant(0))();
  TextColumn get status =>
      text()(); // 'active', 'paused', 'completed', 'abandoned'
  IntColumn get pausedRemainingSeconds =>
      integer().withDefault(const Constant(0))();
  IntColumn get endedAtUtcMs => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'sleep', 'morning', 'evening', 'custom'
  IntColumn get startMinuteOfDay => integer()();
  TextColumn get daysOfWeek =>
      text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutineSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get routineId => text()();
  TextColumn get title => text()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('General'))();
  IntColumn get targetDaysPerWeek => integer().withDefault(const Constant(7))();
  IntColumn get targetMinutes => integer().nullable()();
  BoolColumn get isAvoidance => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get habitId => text()();
  TextColumn get date => text()(); // YYYY-MM-DD
  BoolColumn get completed => boolean().withDefault(const Constant(true))();
  IntColumn get value => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date},
  ];
}

class HabitStreaks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get habitId => text().unique()();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  TextColumn get lastCompletedDate => text().nullable()();
}

class Insights extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get type =>
      text()(); // 'trend', 'warning', 'achievement', 'suggestion'
  TextColumn get evidence => text()();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CustomGoals extends Table {
  TextColumn get id => text()();
  TextColumn get targetType => text()(); // 'total_screen_time', 'app_limit'
  TextColumn get targetIdentifier => text().nullable()(); // null or packageName
  IntColumn get limitMinutes => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class UserSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
