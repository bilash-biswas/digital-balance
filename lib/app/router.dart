import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'localization/app_strings.dart';
import '../features/analytics/presentation/analytics_screen.dart';
import '../features/analytics/presentation/app_detail_screen.dart';
import '../features/app_catalog/presentation/app_catalog_screen.dart';
import '../features/app_restrictions/presentation/rule_editor_screen.dart';
import '../features/app_restrictions/presentation/rules_list_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/focus/presentation/active_focus_session_screen.dart';
import '../features/focus/presentation/focus_home_screen.dart';
import '../features/habits/presentation/habits_screen.dart';
import '../features/insights/presentation/insights_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/routines/presentation/routines_screen.dart';
import '../features/settings/presentation/backup_restore_screen.dart';
import '../features/settings/presentation/privacy_policy_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/settings/presentation/you_hub_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main Navigation Shell (5 Destinations)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: context.tr('home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.insights_outlined),
                  selectedIcon: const Icon(Icons.insights),
                  label: context.tr('insights'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.timer_outlined),
                  selectedIcon: const Icon(Icons.timer),
                  label: context.tr('focus'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.shield_outlined),
                  selectedIcon: const Icon(Icons.shield),
                  label: context.tr('appRules'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: context.tr('you'),
                ),
              ],
            ),
          );
        },
        branches: [
          // Branch 0: Dashboard (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Branch 1: Insights (Analytics)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),

          // Branch 2: Focus
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/focus',
                builder: (context, state) => const FocusHomeScreen(),
              ),
            ],
          ),

          // Branch 3: App Rules
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rules',
                builder: (context, state) => const RulesListScreen(),
              ),
            ],
          ),

          // Branch 4: You (Hub)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/you',
                builder: (context, state) => const YouHubScreen(),
              ),
            ],
          ),
        ],
      ),

      // Detail & Modal Routes
      GoRoute(
        path: '/rules/editor',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          final preset = state.uri.queryParameters['preset'];
          return RuleEditorScreen(ruleId: id, preset: preset);
        },
      ),
      GoRoute(
        path: '/focus/active',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ActiveFocusSessionScreen(),
      ),
      GoRoute(
        path: '/app-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final packageName = state.uri.queryParameters['packageName'] ?? '';
          final appName = state.uri.queryParameters['appName'] ?? '';
          return AppDetailScreen(
            packageName: packageName,
            appName: appName,
          );
        },
      ),
      GoRoute(
        path: '/habits',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HabitsScreen(),
      ),
      GoRoute(
        path: '/routines',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RoutinesScreen(),
      ),
      GoRoute(
        path: '/catalog',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AppCatalogScreen(),
      ),
      GoRoute(
        path: '/insights-list',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/backup',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BackupRestoreScreen(),
      ),
      GoRoute(
        path: '/privacy',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );
});
