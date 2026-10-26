import 'package:digital_balance/app/providers.dart';
import 'package:digital_balance/core/platform/platform_bridge.dart';
import 'package:digital_balance/core/time/time_provider.dart';
import 'package:digital_balance/data/database/app_database.dart';
import 'package:digital_balance/data/repositories/catalog_repository_impl.dart';
import 'package:digital_balance/data/repositories/restriction_repository_impl.dart';
import 'package:digital_balance/data/repositories/usage_repository_impl.dart';
import 'package:digital_balance/features/analytics/presentation/analytics_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockBridge extends PlatformBridge {
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
          foregroundTimeMs: 12540000,
          lastTimeUsedMs: 1690000000000,
          launchCount: 14,
        ),
        AppUsageDto(
          packageName: 'jp.konami.pesam',
          appName: 'eFootball™',
          foregroundTimeMs: 4920000,
          lastTimeUsedMs: 1690000000000,
          launchCount: 5,
        ),
      ],
      deviceUnlocks: 42,
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
  testWidgets('AnalyticsScreen renders App activity details with real app names and hourglass buttons', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final bridge = MockBridge();
    final timeProvider = FixedTimeProvider(DateTime(2026, 10, 12, 14, 0));
    final usageRepo = UsageRepository(db, bridge, timeProvider);
    final catalogRepo = CatalogRepository(db, bridge);
    final restrictionRepo = RestrictionRepository(db, bridge);

    // Populate database
    await usageRepo.syncUsageData(backfillDays: 2);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          usageRepositoryProvider.overrideWithValue(usageRepo),
          catalogRepositoryProvider.overrideWithValue(catalogRepo),
          restrictionRepositoryProvider.overrideWithValue(restrictionRepo),
        ],
        child: const MaterialApp(
          home: AnalyticsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title & Screen time pill
    expect(find.text('App activity details'), findsOneWidget);
    expect(find.text('Screen time'), findsOneWidget);

    // Verify real human-readable app names
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.text('eFootball™'), findsOneWidget);

    // Verify raw package tails are NOT displayed
    expect(find.text('katana'), findsNothing);
    expect(find.text('pesam'), findsNothing);

    // Verify Hourglass timer buttons are present
    expect(find.byIcon(Icons.hourglass_empty_rounded), findsWidgets);

    await db.close();
  });
}
