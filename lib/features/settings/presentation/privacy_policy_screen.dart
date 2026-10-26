import 'package:flutter/material.dart';
import '../../../core/widgets/balance_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Digital Balance Privacy Policy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Last Updated: October 2026',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Divider(height: 24),
                _buildSection(
                  '1. 100% Local-First Operation',
                  'Digital Balance does not require an account, email address, or third-party cloud connection. All application statistics, usage logs, restriction rules, habit completions, and focus records are written exclusively to a private SQLite database residing on your physical device.',
                ),
                _buildSection(
                  '2. Android Usage Access',
                  'We utilize Android\'s UsageStatsManager API solely to calculate on-device screen time, application launch counts, and unlock frequencies. This data is never transmitted across the network and is never shared with third parties.',
                ),
                _buildSection(
                  '3. Accessibility Service Usage',
                  'Digital Balance uses an Accessibility Service exclusively to observe foreground application window transitions (TYPE_WINDOW_STATE_CHANGED) to enforce user-configured restriction schedules and deep-work focus sessions. The service does not read text on your screen, does not monitor keystrokes, does not collect personal identifiers, and does not alter system settings.',
                ),
                _buildSection(
                  '4. Data Retention & Deletion',
                  'You have complete control over your data. You may generate an offline JSON export at any time. You may also execute a complete zero-trace data wipe via Settings, which immediately erases all stored records.',
                ),
                _buildSection(
                  '5. Contact & Questions',
                  'For questions regarding Digital Balance, visit the project documentation or open-source repository.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
