import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class DailyGoalBottomSheet extends StatefulWidget {
  final int initialMinutes;
  final ValueChanged<int> onSaved;

  const DailyGoalBottomSheet({
    super.key,
    required this.initialMinutes,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    required int initialMinutes,
    required ValueChanged<int> onSaved,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DailyGoalBottomSheet(
        initialMinutes: initialMinutes,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<DailyGoalBottomSheet> createState() => _DailyGoalBottomSheetState();
}

class _DailyGoalBottomSheetState extends State<DailyGoalBottomSheet> {
  late int _selectedMinutes;

  final List<int> _presetOptions = const [90, 120, 150, 180, 240];

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.initialMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Icon(Icons.flag_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Daily Screen Time Target',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Sets your overall device usage goal across all applications. Displayed on your home dashboard and 7-day analytics.',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),

            // Target Preview Value
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  Formatters.formatDurationMinutes(_selectedMinutes),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Presets Label
            Text(
              'Quick Presets',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),

            // Preset Choice Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _presetOptions.map((mins) {
                  final isSelected = _selectedMinutes == mins;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(Formatters.formatDurationMinutes(mins)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedMinutes = mins);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Slider
            Text(
              'Custom Duration: ${_selectedMinutes ~/ 60}h ${_selectedMinutes % 60}m',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Slider(
              value: _selectedMinutes.toDouble(),
              min: 30,
              max: 480,
              divisions: 30, // 15-minute steps
              onChanged: (val) {
                setState(() => _selectedMinutes = val.round());
              },
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    widget.onSaved(_selectedMinutes);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Set Daily Target'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
