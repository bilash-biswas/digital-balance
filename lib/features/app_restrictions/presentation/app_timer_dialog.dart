import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/utils/formatters.dart';
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

  final List<int> _quickPresets = [15, 30, 45, 60, 90, 120, 180, 240];

  @override
  void initState() {
    super.initState();
    _minutes = widget.currentLimitMinutes > 0 ? widget.currentLimitMinutes : 30;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
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
              onChanged: (val) => setState(() => _minutes = val.round()),
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
                  onSelected: (val) {
                    if (val) setState(() => _minutes = preset);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              'When the timer runs out, ${widget.appName} will pause and its notifications will be muted for the rest of today.',
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
    );
  }

  Future<void> _saveLimit() async {
    setState(() => _isSaving = true);
    final repo = ref.read(restrictionRepositoryProvider);
    await repo.setAppLimit(
      packageName: widget.packageName,
      appName: widget.appName,
      limitMinutes: _minutes,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.appName} timer set to ${Formatters.formatDurationMinutes(_minutes)} per day.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
