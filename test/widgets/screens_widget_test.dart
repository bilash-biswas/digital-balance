import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:digital_balance/app/providers.dart';
import 'package:digital_balance/core/widgets/balance_card.dart';
import 'package:digital_balance/core/widgets/permission_guard_view.dart';
import 'package:digital_balance/data/database/app_database.dart';
import 'package:digital_balance/features/onboarding/presentation/onboarding_screen.dart';
import 'package:digital_balance/features/settings/presentation/privacy_policy_screen.dart';
import 'package:digital_balance/features/settings/presentation/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase testDb;

  setUp(() {
    testDb = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await testDb.close();
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(testDb)],
      child: MaterialApp(home: child),
    );
  }

  group('Core Widgets Tests', () {
    testWidgets('BalanceCard displays child content and handles onTap', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          BalanceCard(
            onTap: () => tapped = true,
            child: const Column(
              children: [
                Text('Test Card Title'),
                Text('Test Subtitle Details'),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Test Card Title'), findsOneWidget);
      expect(find.text('Test Subtitle Details'), findsOneWidget);

      await tester.tap(find.text('Test Card Title'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets(
      'PermissionGuardCard renders warning and invokes action callback',
      (tester) async {
        var actionTriggered = false;

        await tester.pumpWidget(
          createTestWidget(
            PermissionGuardCard(
              title: 'Usage Permission Required',
              description: 'Needed for screen-time metrics calculation',
              icon: Icons.security,
              buttonLabel: 'Grant Access',
              onAction: () {
                actionTriggered = true;
              },
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Usage Permission Required'), findsOneWidget);
        expect(
          find.text('Needed for screen-time metrics calculation'),
          findsOneWidget,
        );
        expect(find.text('Grant Access'), findsOneWidget);

        await tester.tap(find.text('Grant Access'));
        await tester.pump();

        expect(actionTriggered, isTrue);
      },
    );
  });

  group('Screens Presentation Tests', () {
    testWidgets(
      'PrivacyPolicyScreen renders zero-cloud commitment and sections',
      (tester) async {
        await tester.pumpWidget(createTestWidget(const PrivacyPolicyScreen()));
        await tester.pump();

        expect(find.text('Privacy Policy'), findsOneWidget);
        expect(find.text('Digital Balance Privacy Policy'), findsOneWidget);
        expect(find.text('1. 100% Local-First Operation'), findsOneWidget);
      },
    );

    testWidgets('SettingsScreen renders configuration tiles and options', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const SettingsScreen()));
      // Wait for initial async state load from database
      await tester.pumpAndSettle();

      expect(find.text('Settings & Preferences'), findsOneWidget);
      expect(find.text('Daily Screen Time Goal'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Language / ভাষা'), findsOneWidget);
      expect(find.text('Biometric Override Confirmation'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Zero-Trace Data Deletion'),
        100,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('Zero-Trace Data Deletion'), findsOneWidget);
    });

    testWidgets(
      'OnboardingScreen renders initial welcome page and start button',
      (tester) async {
        await tester.pumpWidget(createTestWidget(const OnboardingScreen()));
        await tester.pump();

        expect(find.text('Digital Balance'), findsOneWidget);
        expect(
          find.text(
            'Take back control of your screen time with calm, nonjudgmental tools and deep work focus sessions.',
          ),
          findsOneWidget,
        );
        expect(find.text('Continue'), findsOneWidget);
      },
    );
  });
}
