import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/widgets/balance_card.dart';

class YouHubScreen extends ConsumerWidget {
  const YouHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final permState = ref.watch(permissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'You & System',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Habits Quick Link
          BalanceCard(
            onTap: () => context.push('/habits'),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Habit Tracker',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Streaks, daily check-ins, and positive habits',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Routines & Sleep Quick Link
          BalanceCard(
            onTap: () => context.push('/routines'),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.bedtime, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Routines & Sleep',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Wind-down steps, bedtime, and morning rituals',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // App Catalog
          BalanceCard(
            onTap: () => context.push('/catalog'),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.apps, color: theme.colorScheme.secondary),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application Catalog',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Discover installed apps, categorize, and exclude',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // System Diagnostics Status
          Text(
            'System Health & Permissions',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          BalanceCard(
            child: Column(
              children: [
                _buildPermRow(
                  'Usage Access',
                  permState.usageAccess,
                  () => ref
                      .read(permissionsProvider.notifier)
                      .openUsageSettings(),
                ),
                const Divider(),
                _buildPermRow(
                  'Accessibility Service',
                  permState.accessibility,
                  () => ref
                      .read(permissionsProvider.notifier)
                      .openAccessibilitySettings(),
                ),
                const Divider(),
                _buildPermRow(
                  'Notifications',
                  permState.notifications,
                  () => ref
                      .read(permissionsProvider.notifier)
                      .openNotificationSettings(),
                ),
                const Divider(),
                _buildPermRow(
                  'Exact Alarms',
                  permState.exactAlarm,
                  () => ref
                      .read(permissionsProvider.notifier)
                      .openExactAlarmSettings(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Preferences & Backup
          Text(
            'Preferences & Data',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          BalanceCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.tune),
                  title: const Text('Preferences & Goals'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/settings'),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.backup_outlined),
                  title: const Text('Local Backup & Restore'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/backup'),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/privacy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPermRow(String label, bool isGranted, VoidCallback onFix) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isGranted ? Icons.check_circle : Icons.warning_amber_rounded,
                color: isGranted ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          if (!isGranted)
            TextButton(onPressed: onFix, child: const Text('Grant'))
          else
            const Text(
              'Active',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
