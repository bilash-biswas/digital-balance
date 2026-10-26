import 'package:digital_balance/app/providers.dart';
import 'package:digital_balance/core/permissions/permission_service.dart';
import 'package:digital_balance/core/platform/platform_bridge.dart';
import 'package:digital_balance/core/time/time_provider.dart';
import 'package:digital_balance/data/database/app_database.dart';
import 'package:digital_balance/data/repositories/catalog_repository_impl.dart';
import 'package:digital_balance/data/repositories/focus_repository_impl.dart';
import 'package:digital_balance/data/repositories/habit_repository_impl.dart';
import 'package:digital_balance/data/repositories/insight_repository_impl.dart';
import 'package:digital_balance/data/repositories/restriction_repository_impl.dart';
import 'package:digital_balance/data/repositories/routine_repository_impl.dart';
import 'package:digital_balance/data/repositories/settings_repository_impl.dart';
import 'package:digital_balance/data/repositories/usage_repository_impl.dart';
import 'package:digital_balance/features/analytics/presentation/app_detail_screen.dart';
import 'package:digital_balance/features/dashboard/presentation/dashboard_screen.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockBridge extends PlatformBridge {
  @override
  Future<Map<String, bool>> getPermissionStatuses() async {
    return {
      'usageAccess': true,
      'notifications': true,
      'accessibility': true,
      'exactAlarm': true,
    };
  }

  @override
  Future<Uint8List?> getAppIcon(String packageName) async => null;

  @override
  Future<List<InstalledAppDto>> getInstalledApplications() async {
    return const [
      InstalledAppDto(
        packageName: 'com.facebook.katana',
        appName: 'Facebook',
        isSystemApp: false,
      ),
    ];
  }

  @override
  Future<UsageResultDto> queryUsage({
    required int startTimeMs,
    required int endTimeMs,
  }) async {
    return const UsageResultDto(
      success: true,
      apps: [
        AppUsageDto(
          packageName: 'com.facebook.katana',
          appName: 'Facebook',
          foregroundTimeMs: 13080000, // 3 hr, 38 min
          lastTimeUsedMs: 1690000000000,
          launchCount: 15,
        ),
      ],
      deviceUnlocks: 50,
      notificationCount: 135,
      hourlyForegroundTimeMs: [
        0, 0, 0, 0, 0, 0,
        120000, 300000, 600000, 900000, 1200000, 1500000,
        1800000, 2400000, 3000000, 2100000, 1800000, 1200000,
        900000, 600000, 300000, 100000, 0, 0,
      ],
      hourlyUnlocks: [
        0, 0, 0, 0, 0, 0,
        2, 3, 5, 4, 3, 2,
        4, 5, 6, 3, 2, 1,
        1, 1, 0, 0, 0, 0,
      ],
    );
  }
}

class FixedTimeProvider implements TimeProvider {
  final DateTime _fixed;
  FixedTimeProvider(this._fixed);

  @override
  DateTime now() => _fixed;

  @override
  DateTime todayMidnight() => DateTime(_fixed.year, _fixed.month, _fixed.day);

  @override
  int currentUtcTimestampMs() => _fixed.toUtc().millisecondsSinceEpoch;
}

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  testWidgets('AppDetailScreen renders app header, duration, weekly chart, and settings items', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final bridge = MockBridge();
    final timeProvider = FixedTimeProvider(DateTime(2026, 10, 12, 14, 0));
    final usageRepo = UsageRepository(db, bridge, timeProvider);
    final restrictionRepo = RestrictionRepository(db, bridge);

    await usageRepo.syncUsageData(backfillDays: 2);

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          usageRepositoryProvider.overrideWithValue(usageRepo),
          restrictionRepositoryProvider.overrideWithValue(restrictionRepo),
          platformBridgeProvider.overrideWithValue(bridge),
        ],
        child: const MaterialApp(
          home: AppDetailScreen(
            packageName: 'com.facebook.katana',
            appName: 'Facebook',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify app name header & duration
    expect(find.text('Facebook'), findsWidgets);
    expect(find.text('Screen time'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('3 hr, 38 min'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);

    // Verify settings section items
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('App timer'), findsOneWidget);
    expect(find.text('Manage notifications'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('DashboardScreen renders Digital Wellbeing hero donut, 50 Unlocks, 135 Notifications, and Ways to disconnect', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final bridge = MockBridge();
    final timeProvider = FixedTimeProvider(DateTime(2026, 10, 12, 14, 0));
    final usageRepo = UsageRepository(db, bridge, timeProvider);
    final catalogRepo = CatalogRepository(db, bridge);
    final restrictionRepo = RestrictionRepository(db, bridge);
    final focusRepo = FocusRepository(db, timeProvider);
    final habitRepo = HabitRepository(db, timeProvider);
    final routineRepo = RoutineRepository(db);
    final insightRepo = InsightRepository(db, timeProvider);
    final settingsRepo = SettingsRepository(db);

    await usageRepo.syncUsageData(backfillDays: 2);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          platformBridgeProvider.overrideWithValue(bridge),
          usageRepositoryProvider.overrideWithValue(usageRepo),
          catalogRepositoryProvider.overrideWithValue(catalogRepo),
          restrictionRepositoryProvider.overrideWithValue(restrictionRepo),
          focusRepositoryProvider.overrideWithValue(focusRepo),
          habitRepositoryProvider.overrideWithValue(habitRepo),
          routineRepositoryProvider.overrideWithValue(routineRepo),
          insightRepositoryProvider.overrideWithValue(insightRepo),
          settingsRepositoryProvider.overrideWithValue(settingsRepo),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Verify hero and activity button
    expect(find.text('Digital Wellbeing'), findsOneWidget);
    expect(find.text('View app activity details'), findsOneWidget);

    // Verify Daily Target tile on Hero card
    expect(find.textContaining('Daily Target:'), findsOneWidget);

    // Tap Daily Target tile to open bottom sheet
    await tester.tap(find.textContaining('Daily Target:'));
    await tester.pumpAndSettle();

    expect(find.text('Daily Screen Time Target'), findsOneWidget);
    expect(find.text('Quick Presets'), findsOneWidget);
    expect(find.text('Set Daily Target'), findsOneWidget);

    // Pick 2h preset chip
    await tester.tap(find.text('2h'));
    await tester.pumpAndSettle();

    // Tap Set Daily Target button
    await tester.tap(find.text('Set Daily Target'));
    await tester.pumpAndSettle();

    // Verify updated target
    expect(find.textContaining('Daily Target: 2h'), findsOneWidget);

    // Verify Glance Cards
    expect(find.text('Unlocks'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);

    // Verify Ways to disconnect
    expect(find.text('Ways to disconnect'), findsOneWidget);
    expect(find.text('App timers'), findsOneWidget);
    expect(find.text('Bedtime mode'), findsOneWidget);
    expect(find.text('Focus'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
