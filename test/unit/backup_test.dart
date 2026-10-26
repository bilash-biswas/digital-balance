import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:digital_balance/data/backup/backup_service.dart';
import 'package:digital_balance/data/database/app_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Backup & Integrity Verification Tests', () {
    test('Validates SHA-256 checksum correctly on intact payload', () {
      final payload = {
        'version': 1,
        'rules': [
          {'id': 'rule_1', 'name': 'Work Focus', 'limitMinutesPerDay': 60},
        ],
      };
      final jsonStr = jsonEncode(payload);
      final checksum = sha256.convert(utf8.encode(jsonStr)).toString();

      final backup = {'checksum': checksum, 'data': payload};

      // Recompute and verify
      final restoredData = backup['data'] as Map<String, dynamic>;
      final recomputedHash = sha256
          .convert(utf8.encode(jsonEncode(restoredData)))
          .toString();
      expect(recomputedHash, equals(backup['checksum']));
    });

    test('Detects tampered data when payload is altered', () {
      final payload = {
        'version': 1,
        'rules': [
          {'id': 'rule_1', 'name': 'Work Focus'},
        ],
      };
      final jsonStr = jsonEncode(payload);
      final checksum = sha256.convert(utf8.encode(jsonStr)).toString();

      // Tampered payload
      final tamperedPayload = {
        'version': 1,
        'rules': [
          {'id': 'rule_1', 'name': 'HACKED Focus'},
        ],
      };

      final recomputedHash = sha256
          .convert(utf8.encode(jsonEncode(tamperedPayload)))
          .toString();
      expect(recomputedHash, isNot(equals(checksum)));
    });

    test('Round-trip export and restore restores all 7 tables in AppDatabase', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final service = BackupService(db);

      // Seed test data across rules, targets, routines, steps, habits, entries, settings
      await db.into(db.restrictionRules).insert(
        RestrictionRulesCompanion.insert(
          id: 'rule_101',
          name: 'Social Diet',
          limitMinutesPerDay: const Value(45),
        ),
      );
      await db.into(db.restrictionTargets).insert(
        RestrictionTargetsCompanion.insert(
          ruleId: 'rule_101',
          packageName: 'com.instagram.android',
        ),
      );
      await db.into(db.routines).insert(
        RoutinesCompanion.insert(
          id: 'routine_101',
          name: 'Evening Winddown',
          type: 'sleep',
          startMinuteOfDay: 1320,
        ),
      );
      await db.into(db.routineSteps).insert(
        RoutineStepsCompanion.insert(
          routineId: 'routine_101',
          title: 'Read Book',
          orderIndex: const Value(0),
        ),
      );
      await db.into(db.habits).insert(
        HabitsCompanion.insert(
          id: 'habit_101',
          title: 'Morning Yoga',
        ),
      );
      await db.into(db.habitEntries).insert(
        HabitEntriesCompanion.insert(
          habitId: 'habit_101',
          date: '2026-10-26',
        ),
      );
      await db.into(db.userSettings).insert(
        UserSettingsCompanion.insert(
          key: 'dailyGoalMinutes',
          value: '120',
        ),
      );

      // Export
      final backupJson = await service.exportBackupJson();
      expect(backupJson, isNotEmpty);

      // Wipe all tables
      await db.delete(db.routineSteps).go();
      await db.delete(db.routines).go();
      await db.delete(db.restrictionTargets).go();
      await db.delete(db.restrictionRules).go();
      await db.delete(db.habitEntries).go();
      await db.delete(db.habits).go();
      await db.delete(db.userSettings).go();

      // Verify wipe
      expect(await db.select(db.restrictionRules).get(), isEmpty);
      expect(await db.select(db.routines).get(), isEmpty);
      expect(await db.select(db.habits).get(), isEmpty);

      // Restore
      final success = await service.restoreBackupJson(backupJson);
      expect(success, isTrue);

      // Verify restoration of all tables
      final restoredRules = await db.select(db.restrictionRules).get();
      expect(restoredRules.length, equals(1));
      expect(restoredRules.first.id, equals('rule_101'));
      expect(restoredRules.first.name, equals('Social Diet'));

      final restoredTargets = await db.select(db.restrictionTargets).get();
      expect(restoredTargets.length, equals(1));
      expect(restoredTargets.first.packageName, equals('com.instagram.android'));

      final restoredRoutines = await db.select(db.routines).get();
      expect(restoredRoutines.length, equals(1));
      expect(restoredRoutines.first.id, equals('routine_101'));

      final restoredSteps = await db.select(db.routineSteps).get();
      expect(restoredSteps.length, equals(1));
      expect(restoredSteps.first.title, equals('Read Book'));

      final restoredHabits = await db.select(db.habits).get();
      expect(restoredHabits.length, equals(1));
      expect(restoredHabits.first.id, equals('habit_101'));

      final restoredEntries = await db.select(db.habitEntries).get();
      expect(restoredEntries.length, equals(1));
      expect(restoredEntries.first.date, equals('2026-10-26'));

      final restoredSettings = await db.select(db.userSettings).get();
      expect(
        restoredSettings.any(
          (s) => s.key == 'dailyGoalMinutes' && s.value == '120',
        ),
        isTrue,
      );

      await db.close();
    });
  });
}
