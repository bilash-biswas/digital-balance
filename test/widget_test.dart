import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:digital_balance/app/app.dart';
import 'package:digital_balance/app/providers.dart';
import 'package:digital_balance/core/constants/app_constants.dart';
import 'package:digital_balance/data/database/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(AppConstants.usageChannel),
          (MethodCall call) async {
            if (call.method == 'getPermissionStatus') {
              return {
                'usageAccess': true,
                'notification': true,
                'accessibility': true,
                'exactAlarm': true,
              };
            }
            if (call.method == 'queryUsage') {
              return {'success': true, 'apps': <dynamic>[], 'deviceUnlocks': 0};
            }
            if (call.method == 'getInstalledApps') {
              return <dynamic>[];
            }
            return null;
          },
        );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(AppConstants.enforcementChannel),
          (MethodCall call) async {
            return true;
          },
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(AppConstants.usageChannel),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(AppConstants.enforcementChannel),
          null,
        );
  });

  testWidgets('Digital Balance smoke test renders root app', (
    WidgetTester tester,
  ) async {
    final testDb = AppDatabase.forTesting(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(testDb)],
        child: const DigitalBalanceApp(),
      ),
    );

    // Allow post-frame callbacks and async operations to settle
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(DigitalBalanceApp), findsOneWidget);

    // Unmount and flush any pending Drift query stream debouncers
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));

    await testDb.close();
  });
}
