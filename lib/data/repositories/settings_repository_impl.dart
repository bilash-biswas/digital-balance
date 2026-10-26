import '../../core/constants/app_constants.dart';
import '../database/app_database.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  Future<String?> getSetting(String key) async {
    final entry = await (_db.select(
      _db.userSettings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return entry?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await _db
        .into(_db.userSettings)
        .insertOnConflictUpdate(
          UserSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<int> getDailyGoalMinutes() async {
    final val = await getSetting('daily_goal_minutes');
    return int.tryParse(val ?? '') ?? AppConstants.defaultDailyGoalMinutes;
  }

  Stream<int> watchDailyGoalMinutes() {
    return (_db.select(_db.userSettings)
          ..where((tbl) => tbl.key.equals('daily_goal_minutes')))
        .watchSingleOrNull()
        .map(
          (entry) =>
              int.tryParse(entry?.value ?? '') ??
              AppConstants.defaultDailyGoalMinutes,
        );
  }

  Future<void> setDailyGoalMinutes(int minutes) async {
    await setSetting('daily_goal_minutes', minutes.toString());
  }

  Future<bool> isDailyTargetRestrictionEnabled() async {
    final val = await getSetting('daily_target_restriction_enabled');
    return val == 'true';
  }

  Stream<bool> watchDailyTargetRestrictionEnabled() {
    return (_db.select(_db.userSettings)
          ..where((tbl) => tbl.key.equals('daily_target_restriction_enabled')))
        .watchSingleOrNull()
        .map((entry) => entry?.value == 'true');
  }

  Future<void> setDailyTargetRestrictionEnabled(bool enabled) async {
    await setSetting('daily_target_restriction_enabled', enabled ? 'true' : 'false');
  }

  Future<String> getThemeMode() async {
    final val = await getSetting('theme_mode');
    return val ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    await setSetting('theme_mode', mode);
  }

  Future<String> getLanguage() async {
    final val = await getSetting('language');
    return val ?? 'en';
  }

  Future<void> setLanguage(String lang) async {
    await setSetting('language', lang);
  }

  Future<bool> hasCompletedOnboarding() async {
    final val = await getSetting('onboarding_completed');
    return val == 'true';
  }

  Future<void> setCompletedOnboarding(bool completed) async {
    await setSetting('onboarding_completed', completed ? 'true' : 'false');
  }

  Future<bool> isBiometricOverrideEnabled() async {
    final val = await getSetting('biometric_override');
    return val == 'true';
  }

  Future<void> setBiometricOverrideEnabled(bool enabled) async {
    await setSetting('biometric_override', enabled ? 'true' : 'false');
  }

  Future<void> clearAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.appCatalog).go();
      await _db.delete(_db.usageDaily).go();
      await _db.delete(_db.usageHourly).go();
      await _db.delete(_db.usageSyncState).go();
      await _db.delete(_db.restrictionRules).go();
      await _db.delete(_db.restrictionTargets).go();
      await _db.delete(_db.restrictionOverrides).go();
      await _db.delete(_db.focusSessions).go();
      await _db.delete(_db.routines).go();
      await _db.delete(_db.routineSteps).go();
      await _db.delete(_db.habits).go();
      await _db.delete(_db.habitEntries).go();
      await _db.delete(_db.habitStreaks).go();
      await _db.delete(_db.insights).go();
      await _db.delete(_db.customGoals).go();
      await _db.delete(_db.userSettings).go();
    });
  }
}
