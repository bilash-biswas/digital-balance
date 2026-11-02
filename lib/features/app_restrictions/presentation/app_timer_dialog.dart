import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/accessibility_disclosure_dialog.dart';
import '../../../core/widgets/app_icon_widget.dart';

class AppTimerDialog extends ConsumerStatefulWidget {
  final String packageName;
  final String appName;
  final int currentLimitMinutes;

  const AppTimerDialog({
    super.key,
    required this.packageName,
    required this.appName,
    this.currentLimitMinutes = 0,
  });

  static Future<void> show(
    BuildContext context, {
    required String packageName,
    required String appName,
    int currentLimitMinutes = 0,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AppTimerDialog(
        packageName: packageName,
        appName: appName,
        currentLimitMinutes: currentLimitMinutes,
      ),
    );
  }

  @override
  ConsumerState<AppTimerDialog> createState() => _AppTimerDialogState();
}

class _AppTimerDialogState extends ConsumerState<AppTimerDialog> {
  late int _minutes;
  bool _isSaving = false;
  bool _isHardLock = false;
  bool _isLockedUntilMidnight = false;
  bool _isLoading = true;

  final List<int> _quickPresets = [15, 30, 45, 60, 90, 120, 180, 240];

  @override
  void initState() {
    super.initState();
    _minutes = widget.currentLimitMinutes > 0 ? widget.currentLimitMinutes : 30;
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    final repo = ref.read(restrictionRepositoryProvider);
    final hardLocked = await repo.isAppHardLocked(widget.packageName);
    final usageRepo = ref.read(usageRepositoryProvider);
    final todayUsage = await usageRepo.getTodayMinutesForPackage(widget.packageName);

    if (mounted) {
      setState(() {
        _isHardLock = hardLocked;
        if (hardLocked && widget.currentLimitMinutes > 0 && todayUsage >= widget.currentLimitMinutes) {
          _isLockedUntilMidnight = true;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permState = ref.watch(permissionsProvider);
    final hasExistingLimit = widget.currentLimitMinutes > 0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      title: Row(
        children: [
          AppIconWidget(
            packageName: widget.packageName,
            appName: widget.appName,
            size: 40,
            borderRadius: 10,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Set app timer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.appName,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      content: _isLoading
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!permState.accessibility) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.error.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.accessibility_new_rounded, color: theme.colorScheme.error, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Accessibility Service Disabled',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Enable Digital Balance in Accessibility Settings so Android allows it to pause ${widget.appName} when the timer ends.',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonal(
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                AccessibilityDisclosureDialog.show(
                                  context,
                                  onApproved: () => ref
                                      .read(permissionsProvider.notifier)
                                      .openAccessibilitySettings(),
                                );
                              },
                              child: const Text('Enable in Settings', style: TextStyle(fontSize: 11)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_isLockedUntilMidnight) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.error.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_rounded, color: theme.colorScheme.error, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Hard Lock Active: ${widget.appName} has reached today\'s limit (${Formatters.formatDurationMinutes(widget.currentLimitMinutes)}). The timer cannot be changed or removed until 12:00 AM.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Big Duration Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      Formatters.formatDurationMinutes(_minutes),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Continuous Slider
                  Slider(
                    value: _minutes.toDouble(),
                    min: 5,
                    max: 360,
                    divisions: 71, // 5 min increments up to 6 hours
                    label: '${_minutes}m',
                    onChanged: _isLockedUntilMidnight
                        ? null
                        : (val) => setState(() => _minutes = val.round()),
                  ),

                  const SizedBox(height: 8),
                  // Quick preset pills
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _quickPresets.map((preset) {
                      final isSelected = _minutes == preset;
                      return ChoiceChip(
                        label: Text(
                          Formatters.formatDurationMinutes(preset),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: _isLockedUntilMidnight
                            ? null
                            : (val) {
                                if (val) setState(() => _minutes = preset);
                              },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Hard Lock Switch Card
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isHardLock
                            ? theme.colorScheme.primary.withValues(alpha: 0.6)
                            : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: SwitchListTile.adaptive(
                      value: _isHardLock,
                      onChanged: _isLockedUntilMidnight
                          ? null
                          : (val) => setState(() => _isHardLock = val),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      secondary: Icon(
                        _isHardLock ? Icons.lock_rounded : Icons.lock_open_rounded,
                        color: _isHardLock ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      ),
                      title: const Text(
                        'Hard Lock (Strict Mode)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Hides the 5-minute unlock button and locks this timer until midnight when reached.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    _isHardLock
                        ? 'When the timer runs out, ${widget.appName} will pause and cannot be unlocked until tomorrow.'
                        : 'When the timer runs out, ${widget.appName} will pause and its notifications will be muted for the rest of today.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
      actions: [
        if (_isLockedUntilMidnight)
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          )
        else ...[
          if (hasExistingLimit)
            TextButton(
              onPressed: _isSaving ? null : _deleteLimit,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: const Text('Delete timer'),
            ),
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _isSaving ? null : _saveLimit,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Set timer'),
          ),
        ],
      ],
    );
  }

  Future<void> _saveLimit() async {
    setState(() => _isSaving = true);
    final repo = ref.read(restrictionRepositoryProvider);
    await repo.setAppLimit(
      packageName: widget.packageName,
      appName: widget.appName,
      limitMinutes: _minutes,
      isHardLock: _isHardLock,
    );

    if (mounted) {
      Navigator.of(context).pop();
      final permState = ref.read(permissionsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.appName} timer set to ${Formatters.formatDurationMinutes(_minutes)} per day${_isHardLock ? " (Hard Lock)" : ""}.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (!permState.accessibility) {
        AccessibilityDisclosureDialog.show(
          context,
          onApproved: () => ref
              .read(permissionsProvider.notifier)
              .openAccessibilitySettings(),
        );
      }
    }
  }

  Future<void> _deleteLimit() async {
    setState(() => _isSaving = true);
    final repo = ref.read(restrictionRepositoryProvider);
    await repo.removeAppLimit(widget.packageName);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.appName} timer deleted.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
