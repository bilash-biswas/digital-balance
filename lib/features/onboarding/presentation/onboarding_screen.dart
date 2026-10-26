import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/widgets/balance_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedGoalMinutes = 180;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permState = ref.watch(permissionsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  // Page 1: Welcome
                  _buildWelcomePage(theme),

                  // Page 2: Privacy Guarantee
                  _buildPrivacyPage(theme),

                  // Page 3: Goal Selection
                  _buildGoalPage(theme),

                  // Page 4: Permissions
                  _buildPermissionsPage(theme, permState),
                ],
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 80),

                  FilledButton(
                    onPressed: () async {
                      if (_currentPage < 3) {
                        await _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Finish onboarding
                        final settingsRepo = ref.read(
                          settingsRepositoryProvider,
                        );
                        await settingsRepo.setDailyGoalMinutes(
                          _selectedGoalMinutes,
                        );
                        await settingsRepo.setCompletedOnboarding(true);

                        // Trigger initial sync
                        await ref.read(usageRepositoryProvider).syncUsageData();
                        await ref
                            .read(catalogRepositoryProvider)
                            .syncInstalledApps();

                        if (context.mounted) {
                          context.go('/dashboard');
                        }
                      }
                    },
                    child: Text(_currentPage == 3 ? 'Get Started' : 'Continue'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spa_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Digital Balance',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Take back control of your screen time with calm, nonjudgmental tools and deep work focus sessions.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.4,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 64,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Privacy by Default',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'All your usage statistics, restriction schedules, and habits are stored strictly on your device inside SQLite.\n\nNo mandatory account. No cloud analytics. Your data belongs to you.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPage(ThemeData theme) {
    final goalOptions = [
      {'label': '1h 30m', 'minutes': 90, 'desc': 'Light digital diet'},
      {'label': '2h 30m', 'minutes': 150, 'desc': 'Balanced everyday usage'},
      {
        'label': '3h 30m',
        'minutes': 210,
        'desc': 'Moderate productivity target',
      },
      {'label': '4h 30m', 'minutes': 270, 'desc': 'Gradual reduction'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Daily Goal',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a realistic screen-time benchmark for your typical day.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: goalOptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final opt = goalOptions[index];
                final minutes = opt['minutes'] as int;
                final isSelected = _selectedGoalMinutes == minutes;

                return BalanceCard(
                  onTap: () => setState(() => _selectedGoalMinutes = minutes),
                  color: isSelected
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.35,
                        )
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt['label'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            opt['desc'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsPage(ThemeData theme, PermissionState permState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enable System Access',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To calculate on-device screen time and send timely reminders, Digital Balance requires standard Android permissions.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Permission 1: Usage Access
          BalanceCard(
            child: Row(
              children: [
                Icon(
                  permState.usageAccess
                      ? Icons.check_circle
                      : Icons.insights_outlined,
                  color: permState.usageAccess
                      ? Colors.green
                      : theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usage Access',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Required to read on-device application screen time.',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!permState.usageAccess)
                  OutlinedButton(
                    onPressed: () {
                      ref
                          .read(permissionsProvider.notifier)
                          .openUsageSettings();
                    },
                    child: const Text('Grant'),
                  )
                else
                  const Chip(
                    label: Text('Granted', style: TextStyle(fontSize: 11)),
                    backgroundColor: Color(0xFFE8F5E9),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Permission 2: Notifications
          BalanceCard(
            child: Row(
              children: [
                Icon(
                  permState.notifications
                      ? Icons.check_circle
                      : Icons.notifications_none,
                  color: permState.notifications
                      ? Colors.green
                      : theme.colorScheme.secondary,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Alerts you when nearing daily limits or finishing focus.',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!permState.notifications)
                  OutlinedButton(
                    onPressed: () {
                      ref
                          .read(permissionsProvider.notifier)
                          .openNotificationSettings();
                    },
                    child: const Text('Grant'),
                  )
                else
                  const Chip(
                    label: Text('Granted', style: TextStyle(fontSize: 11)),
                    backgroundColor: Color(0xFFE8F5E9),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
