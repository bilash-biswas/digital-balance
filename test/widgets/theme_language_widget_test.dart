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

  testWidgets(
    'DigitalBalanceApp reactively changes theme and language on provider updates',
    (WidgetTester tester) async {
      final testDb = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(testDb)],
      );
      addTearDown(() => container.dispose());

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DigitalBalanceApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Initial state: English language labels
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(
        find.widgetWithText(NavigationDestination, 'Focus'),
        findsOneWidget,
      );

      // Switch language to Bengali (বাংলা)
      await container.read(localeControllerProvider.notifier).setLanguage('bn');
      await tester.pumpAndSettle();

      // Verify Bengali language labels are now rendered
      expect(find.text('হোম'), findsOneWidget);
      expect(find.text('অন্তর্দৃষ্টি'), findsOneWidget);
      expect(
        find.widgetWithText(NavigationDestination, 'ফোকাস'),
        findsOneWidget,
      );

      // Switch back to English
      await container.read(localeControllerProvider.notifier).setLanguage('en');
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);

      // Switch Theme to Dark Mode
      await container
          .read(themeModeControllerProvider.notifier)
          .setThemeMode('dark');
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.dark));

      // Switch Theme to Light Mode
      await container
          .read(themeModeControllerProvider.notifier)
          .setThemeMode('light');
      await tester.pumpAndSettle();

      final materialAppLight = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialAppLight.themeMode, equals(ThemeMode.light));

      // Clean unmount and flush stream timers
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 500));
      await testDb.close();
    },
  );
}
