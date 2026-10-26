import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/permissions/permission_service.dart';
import '../core/time/time_provider.dart';
import '../data/database/app_database.dart';
import '../data/repositories/catalog_repository_impl.dart';
import '../data/repositories/focus_repository_impl.dart';
import '../data/repositories/habit_repository_impl.dart';
import '../data/repositories/insight_repository_impl.dart';
import '../data/repositories/restriction_repository_impl.dart';
import '../data/repositories/routine_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../data/repositories/usage_repository_impl.dart';
import '../data/backup/backup_service.dart';
import '../features/notifications/services/notification_service.dart';

// Database & Core Providers
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final timeProvider = Provider<TimeProvider>((ref) {
  return const SystemTimeProvider();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.initialize();
  return service;
});

// Repository Providers
final usageRepositoryProvider = Provider<UsageRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final bridge = ref.watch(platformBridgeProvider);
  final time = ref.watch(timeProvider);
  return UsageRepository(db, bridge, time);
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final bridge = ref.watch(platformBridgeProvider);
  return CatalogRepository(db, bridge);
});

final restrictionRepositoryProvider = Provider<RestrictionRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final bridge = ref.watch(platformBridgeProvider);
  return RestrictionRepository(db, bridge);
});

final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final time = ref.watch(timeProvider);
  return FocusRepository(db, time);
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final time = ref.watch(timeProvider);
  return HabitRepository(db, time);
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return RoutineRepository(db);
});

final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final time = ref.watch(timeProvider);
  return InsightRepository(db, time);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepository(db);
});

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(databaseProvider);
  return BackupService(db);
});

// Theme & Localization State Controllers
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SettingsRepository _settingsRepo;
  bool _isExplicitlySet = false;

  ThemeModeNotifier(this._settingsRepo) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final modeStr = await _settingsRepo.getThemeMode();
    if (!_isExplicitlySet) {
      state = _stringToThemeMode(modeStr);
    }
  }

  Future<void> setThemeMode(String modeStr) async {
    _isExplicitlySet = true;
    state = _stringToThemeMode(modeStr);
    await _settingsRepo.setThemeMode(modeStr);
  }

  static ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

class LocaleNotifier extends StateNotifier<Locale> {
  final SettingsRepository _settingsRepo;
  bool _isExplicitlySet = false;

  LocaleNotifier(this._settingsRepo) : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final langStr = await _settingsRepo.getLanguage();
    if (!_isExplicitlySet) {
      state = Locale(langStr);
    }
  }

  Future<void> setLanguage(String langStr) async {
    _isExplicitlySet = true;
    state = Locale(langStr);
    await _settingsRepo.setLanguage(langStr);
  }
}

final themeModeControllerProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
      final settingsRepo = ref.watch(settingsRepositoryProvider);
      return ThemeModeNotifier(settingsRepo);
    });

final localeControllerProvider = StateNotifierProvider<LocaleNotifier, Locale>((
  ref,
) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return LocaleNotifier(settingsRepo);
});
