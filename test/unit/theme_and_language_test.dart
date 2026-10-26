import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:digital_balance/app/localization/app_strings.dart';
import 'package:digital_balance/app/providers.dart';
import 'package:digital_balance/data/database/app_database.dart';
import 'package:digital_balance/data/repositories/settings_repository_impl.dart';

void main() {
  group('Localization AppStrings Unit Tests', () {
    test('Returns accurate English strings by default', () {
      expect(
        AppStrings.get('appName', locale: 'en'),
        equals('Digital Balance'),
      );
      expect(AppStrings.get('home', locale: 'en'), equals('Home'));
      expect(
        AppStrings.get('todayUsage', locale: 'en'),
        equals("Today's Screen Time"),
      );
      expect(AppStrings.get('appearance', locale: 'en'), equals('Appearance'));
      expect(AppStrings.get('theme', locale: 'en'), equals('Theme'));
      expect(AppStrings.get('language', locale: 'en'), equals('Language'));
    });

    test('Returns accurate Bengali (বাংলা) translations', () {
      expect(
        AppStrings.get('appName', locale: 'bn'),
        equals('ডিজিটাল ব্যালেন্স'),
      );
      expect(AppStrings.get('home', locale: 'bn'), equals('হোম'));
      expect(
        AppStrings.get('todayUsage', locale: 'bn'),
        equals('আজকের স্ক্রিন টাইম'),
      );
      expect(
        AppStrings.get('appearance', locale: 'bn'),
        equals('রূপরেখা ও থিম'),
      );
      expect(AppStrings.get('theme', locale: 'bn'), equals('থিম'));
      expect(AppStrings.get('language', locale: 'bn'), equals('ভাষা'));
      expect(
        AppStrings.get('darkTheme', locale: 'bn'),
        equals('গাঢ় থিম (ডার্ক)'),
      );
      expect(
        AppStrings.get('lightTheme', locale: 'bn'),
        equals('হালকা থিম (লাইট)'),
      );
    });

    test('Falls back to English if key is missing in other locales', () {
      expect(
        AppStrings.get('appName', locale: 'fr'),
        equals('Digital Balance'),
      );
    });
  });

  group('ThemeModeNotifier & LocaleNotifier Tests', () {
    late AppDatabase db;
    late SettingsRepository settingsRepo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      settingsRepo = SettingsRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('ThemeModeNotifier updates state and persists to database', () async {
      final themeNotifier = ThemeModeNotifier(settingsRepo);
      expect(themeNotifier.state, equals(ThemeMode.system));

      await themeNotifier.setThemeMode('dark');
      expect(themeNotifier.state, equals(ThemeMode.dark));
      final savedTheme = await settingsRepo.getThemeMode();
      expect(savedTheme, equals('dark'));

      await themeNotifier.setThemeMode('light');
      expect(themeNotifier.state, equals(ThemeMode.light));
      final savedTheme2 = await settingsRepo.getThemeMode();
      expect(savedTheme2, equals('light'));
    });

    test('LocaleNotifier updates state and persists to database', () async {
      final localeNotifier = LocaleNotifier(settingsRepo);
      expect(localeNotifier.state, equals(const Locale('en')));

      await localeNotifier.setLanguage('bn');
      expect(localeNotifier.state, equals(const Locale('bn')));
      final savedLang = await settingsRepo.getLanguage();
      expect(savedLang, equals('bn'));

      await localeNotifier.setLanguage('en');
      expect(localeNotifier.state, equals(const Locale('en')));
      final savedLang2 = await settingsRepo.getLanguage();
      expect(savedLang2, equals('en'));
    });

    test('SettingsRepository watchDailyGoalMinutes emits default and updates reactively', () async {
      expect(await settingsRepo.getDailyGoalMinutes(), equals(180));

      final expectation = expectLater(
        settingsRepo.watchDailyGoalMinutes(),
        emitsInOrder([180, 150, 240]),
      );

      await settingsRepo.setDailyGoalMinutes(150);
      await pumpEventQueue();
      await settingsRepo.setDailyGoalMinutes(240);
      await pumpEventQueue();

      await expectation;
    });

    test('SettingsRepository watchDailyTargetRestrictionEnabled emits false then true', () async {
      expect(await settingsRepo.isDailyTargetRestrictionEnabled(), isFalse);

      final expectation = expectLater(
        settingsRepo.watchDailyTargetRestrictionEnabled(),
        emitsInOrder([false, true, false]),
      );

      await settingsRepo.setDailyTargetRestrictionEnabled(true);
      await pumpEventQueue();
      await settingsRepo.setDailyTargetRestrictionEnabled(false);
      await pumpEventQueue();

      await expectation;
    });
  });
}
