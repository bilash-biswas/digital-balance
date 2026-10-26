import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../data/database/app_database.dart';

class FocusHomeScreen extends ConsumerStatefulWidget {
  const FocusHomeScreen({super.key});

  @override
  ConsumerState<FocusHomeScreen> createState() => _FocusHomeScreenState();
}

class _FocusHomeScreenState extends ConsumerState<FocusHomeScreen> {
  int _selectedDuration = 25;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusRepo = ref.watch(focusRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deep Focus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Active Session Banner if in progress
          StreamBuilder<FocusSession?>(
            stream: focusRepo.watchActiveSession(),
            builder: (context, snapshot) {
              final active = snapshot.data;
              if (active == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BalanceCard(
                  color: theme.colorScheme.tertiaryContainer.withValues(
                    alpha: 0.35,
                  ),
                  onTap: () => context.push('/focus/active'),
                  child: Row(
                    children: [
                      Icon(
                        Icons.hourglass_top,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Session in progress: ${active.status.toUpperCase()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Target: ${active.targetDurationMinutes} mins',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: () => context.push('/focus/active'),
                        child: const Text('Open'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Duration Selector Card
          BalanceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Focus Duration',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [15, 25, 45, 60].map((mins) {
                    final isSelected = _selectedDuration == mins;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text('${mins}m'),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _selectedDuration = mins),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: Text('Start $_selectedDuration-Minute Session'),
                    onPressed: () async {
                      await focusRepo.startSession(
                        durationMinutes: _selectedDuration,
                      );
                      if (context.mounted) {
                        await context.push('/focus/active');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Focus History
          StreamBuilder<List<FocusSession>>(
            stream: focusRepo.watchSessionHistory(),
            builder: (context, snapshot) {
              final sessions = snapshot.data ?? [];
              if (sessions.isEmpty) {
                return const SizedBox.shrink();
              }

              return BalanceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed Sessions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...sessions.take(5).map((s) {
                      final isCompleted = s.status == 'completed';
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.cancel_outlined,
                          color: isCompleted ? Colors.green : Colors.red,
                        ),
                        title: Text('${s.targetDurationMinutes} min session'),
                        subtitle: Text(
                          Formatters.formatDate(
                            DateTime.fromMillisecondsSinceEpoch(
                              s.startedAtUtcMs,
                            ),
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Chip(
                          label: Text(
                            s.status,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
