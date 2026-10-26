import 'package:flutter/material.dart';

class AccessibilityDisclosureDialog extends StatelessWidget {
  final VoidCallback onApproved;

  const AccessibilityDisclosureDialog({super.key, required this.onApproved});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onApproved,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AccessibilityDisclosureDialog(onApproved: onApproved),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.accessibility_new, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Accessibility Disclosure',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Digital Balance uses Android’s AccessibilityService API strictly to support self-imposed digital wellbeing goals:',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              icon: Icons.visibility_outlined,
              title: 'Foreground App Detection',
              description:
                  'Detects when an application you placed on a timer or scheduled limit opens in the foreground.',
              theme: theme,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              icon: Icons.block,
              title: 'Intervention Screen Display',
              description:
                  'Displays your configured restriction screen when limits or focus mode boundaries are reached.',
              theme: theme,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Privacy Guarantee: We never record typed keystrokes, personal messages, or screen contents. No data ever leaves your device.',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onApproved();
          },
          child: const Text('Acknowledge & Open Settings'),
        ),
      ],
    );
  }

  Widget _buildBulletPoint({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
