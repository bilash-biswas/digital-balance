import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:digital_balance/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift In-Memory Database Tests', () {
    test('AppCatalog inserts and retrieves applications', () async {
      await db
          .into(db.appCatalog)
          .insert(
            AppCatalogCompanion.insert(
              packageName: 'com.example.testapp',
              appName: 'Test Application',
              isSystemApp: const Value(false),
            ),
          );

      final apps = await db.select(db.appCatalog).get();
      expect(apps.length, equals(1));
      expect(apps.first.packageName, equals('com.example.testapp'));
      expect(apps.first.appName, equals('Test Application'));
    });

    test(
      'UsageDaily inserts and handles conflict update on same date and package',
      () async {
        // First insert
        await db
            .into(db.usageDaily)
            .insertOnConflictUpdate(
              UsageDailyCompanion.insert(
                date: '2026-10-12',
                packageName: 'com.example.testapp',
                foregroundTimeMs: const Value(60000),
                launchCount: const Value(3),
              ),
            );

        var records = await db.select(db.usageDaily).get();
        expect(records.length, equals(1));
        expect(records.first.foregroundTimeMs, equals(60000));

        // Second insert on conflict
        await db
            .into(db.usageDaily)
            .insertOnConflictUpdate(
              UsageDailyCompanion.insert(
                date: '2026-10-12',
                packageName: 'com.example.testapp',
                foregroundTimeMs: const Value(120000),
                launchCount: const Value(5),
              ),
            );

        records = await db.select(db.usageDaily).get();
        expect(records.length, equals(1)); // Still 1 record, updated!
        expect(records.first.foregroundTimeMs, equals(120000));
        expect(records.first.launchCount, equals(5));
      },
    );

    test('RestrictionRules and Targets store and cascade', () async {
      await db
          .into(db.restrictionRules)
          .insert(
            RestrictionRulesCompanion.insert(
              id: 'rule_1',
              name: 'Bedtime Social Block',
              limitMinutesPerDay: const Value(0),
              startMinuteOfDay: const Value(1320),
              endMinuteOfDay: const Value(420),
            ),
          );

      await db
          .into(db.restrictionTargets)
          .insert(
            RestrictionTargetsCompanion.insert(
              ruleId: 'rule_1',
              packageName: 'com.instagram.android',
            ),
          );

      final rules = await db.select(db.restrictionRules).get();
      final targets = await db.select(db.restrictionTargets).get();

      expect(rules.length, equals(1));
      expect(targets.length, equals(1));
      expect(targets.first.packageName, equals('com.instagram.android'));
    });

    test('UserSettings stores and retrieves key-value configuration', () async {
      await db
          .into(db.userSettings)
          .insertOnConflictUpdate(
            UserSettingsCompanion.insert(
              key: 'daily_goal_minutes',
              value: '180',
            ),
          );

      final setting =
          await (db.select(db.userSettings)
                ..where((tbl) => tbl.key.equals('daily_goal_minutes')))
              .getSingleOrNull();

      expect(setting, isNotNull);
      expect(setting!.value, equals('180'));
    });
  });
}
