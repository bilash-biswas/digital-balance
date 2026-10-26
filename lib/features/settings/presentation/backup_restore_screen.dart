import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/balance_card.dart';

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() =>
      _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  final _restoreController = TextEditingController();
  String? _exportedPayload;
  bool _isExporting = false;

  @override
  void dispose() {
    _restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backupService = ref.watch(backupServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Local Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Export Section
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.upload_file, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Export Backup (JSON)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Generates a cryptographic SHA-256 verified backup of your rules, habits, routines, and settings.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.download),
                  label: Text(
                    _isExporting ? 'Generating...' : 'Generate Backup JSON',
                  ),
                  onPressed: _isExporting
                      ? null
                      : () async {
                          setState(() => _isExporting = true);
                          final jsonStr = await backupService
                              .exportBackupJson();
                          setState(() {
                            _exportedPayload = jsonStr;
                            _isExporting = false;
                          });
                        },
                ),
                if (_exportedPayload != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_exportedPayload!.substring(0, 100)}...',
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy to Clipboard'),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _exportedPayload!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Backup JSON copied to clipboard!',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Restore Section
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings_backup_restore,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Restore from Backup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Paste your previously exported backup JSON payload below to restore your configurations.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _restoreController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Paste backup JSON here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('Validate & Restore'),
                  onPressed: () async {
                    final text = _restoreController.text.trim();
                    if (text.isEmpty) return;

                    final messenger = ScaffoldMessenger.of(context);
                    final success = await backupService.restoreBackupJson(text);
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Data restored successfully!'
                              : 'Restore failed: Checksum verification failed.',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
