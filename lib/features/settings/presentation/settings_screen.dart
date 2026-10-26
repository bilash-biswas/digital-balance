import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_strings.dart';
import '../../../app/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/balance_card.dart';
import 'update_available_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _dailyGoalMinutes = 180;
  bool _biometricOverride = false;
  bool _isLoading = true;
  bool _isCheckingUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final goal = await settingsRepo.getDailyGoalMinutes();
    final bio = await settingsRepo.isBiometricOverrideEnabled();

    if (mounted) {
      setState(() {
        _dailyGoalMinutes = goal;
        _biometricOverride = bio;
        _isLoading = false;
      });
    }
  }

  Future<void> _checkForAppUpdates() async {
    setState(() => _isCheckingUpdate = true);
    final updateService = ref.read(appUpdateServiceProvider);
    final update = await updateService.checkForUpdate();
    if (!mounted) return;
    setState(() => _isCheckingUpdate = false);

    if (update != null) {
      await UpdateAvailableDialog.show(
        context,
        updateInfo: update,
        updateService: updateService,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are using the latest version of Digital Balance!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsRepo = ref.watch(settingsRepositoryProvider);
    final activeThemeMode = ref.watch(themeModeControllerProvider);
    final activeLocale = ref.watch(localeControllerProvider);

    final currentThemeModeString = ThemeModeNotifier.themeModeToString(
      activeThemeMode,
    );
    final currentLanguageString = activeLocale.languageCode == 'bn'
        ? 'bn'
        : 'en';

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('settingsAndPreferences'))),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Daily Goal
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Screen Time Goal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current Target: ${Formatters.formatDurationMinutes(_dailyGoalMinutes)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Slider(
                  value: _dailyGoalMinutes.toDouble(),
                  min: 30,
                  max: 480,
                  divisions: 30,
                  onChanged: (val) {
                    setState(() => _dailyGoalMinutes = val.round());
                  },
                  onChangeEnd: (val) {
                    settingsRepo.setDailyGoalMinutes(val.round());
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Theme & Appearance
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('appearance'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: currentThemeModeString,
                  decoration: InputDecoration(
                    labelText: context.tr('theme'),
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(context.tr('followSystem')),
                    ),
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(context.tr('lightTheme')),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(context.tr('darkTheme')),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(themeModeControllerProvider.notifier)
                          .setThemeMode(val);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Language
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.tr('language')} / ভাষা',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: currentLanguageString,
                  decoration: InputDecoration(
                    labelText: context.tr('language'),
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(context.tr('english')),
                    ),
                    DropdownMenuItem(
                      value: 'bn',
                      child: Text(context.tr('bangla')),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(localeControllerProvider.notifier)
                          .setLanguage(val);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Security & Overrides
          BalanceCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Biometric Override Confirmation'),
              subtitle: const Text(
                'Require fingerprint or face recognition before granting temporary restriction override.',
                style: TextStyle(fontSize: 12),
              ),
              value: _biometricOverride,
              onChanged: (val) {
                setState(() => _biometricOverride = val);
                settingsRepo.setBiometricOverrideEnabled(val);
              },
            ),
          ),
          const SizedBox(height: 14),

          // App Version & Updates
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'App Version & Updates',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: const Text('v${AppConstants.appVersion}'),
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Checks for official updates directly from the GitHub repository.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  icon: _isCheckingUpdate
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    _isCheckingUpdate
                        ? 'Checking GitHub...'
                        : 'Check for Updates',
                  ),
                  onPressed: _isCheckingUpdate ? null : _checkForAppUpdates,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Danger Zone: Complete Wipe
          BalanceCard(
            color: theme.colorScheme.errorContainer.withValues(alpha: 0.15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: theme.colorScheme.error),
                    const SizedBox(width: 8),
                    Text(
                      'Zero-Trace Data Deletion',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Permanently delete all usage history, rules, habits, and routines stored on this device. This cannot be undone.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete All Local Data'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  onPressed: () => _confirmDataWipe(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _confirmDataWipe(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete All Data?'),
          content: const Text(
            'This action completely purges the local SQLite database. You will be returned to the onboarding setup.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(ctx);
                await ref.read(settingsRepositoryProvider).clearAllData();
                if (context.mounted) {
                  context.go('/onboarding');
                }
              },
              child: const Text('Confirm & Delete'),
            ),
          ],
        );
      },
    );
  }
}
