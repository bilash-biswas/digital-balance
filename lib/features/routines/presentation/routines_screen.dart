import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../data/repositories/routine_repository_impl.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final routineRepo = ref.watch(routineRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Routines & Sleep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Routine'),
        onPressed: () => _openAddRoutineDialog(context, ref),
      ),
      body: StreamBuilder<List<RoutineWithSteps>>(
        stream: routineRepo.watchRoutines(),
        builder: (context, snapshot) {
          final routines = snapshot.data ?? [];

          if (routines.isEmpty) {
            return EmptyStateView(
              icon: Icons.bedtime_outlined,
              title: 'Set Wind-Down & Morning Routines',
              description:
                  'Maintain healthy sleep hygiene by preparing step-by-step evening and morning rituals.',
              actionLabel: 'Create Bedtime Routine',
              onAction: () => _openAddRoutineDialog(context, ref),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: routines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = routines[index];
              final routine = r.routine;
              final timeStr = Formatters.formatMinuteOfDay(
                routine.startMinuteOfDay,
              );

              return BalanceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              routine.type == 'sleep'
                                  ? Icons.nightlight_round
                                  : Icons.wb_sunny_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routine.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: routine.isEnabled,
                          onChanged: (val) {
                            routineRepo.toggleRoutine(routine.id, val);
                          },
                        ),
                      ],
                    ),
                    if (r.steps.isNotEmpty) ...[
                      const Divider(height: 24),
                      ...r.steps.map((step) {
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            step.title,
                            style: TextStyle(
                              decoration: step.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontSize: 14,
                            ),
                          ),
                          value: step.isCompleted,
                          onChanged: (val) {
                            routineRepo.toggleStep(step.id, val ?? false);
                          },
                        );
                      }),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openAddRoutineDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: 'Evening Wind-Down');
    final stepsController = TextEditingController(
      text: 'Turn off notifications\nRead a book\nDim bedroom lights',
    );
    var startMinute = 22 * 60; // 22:00

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Routine',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Routine Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: Text(
                      'Starts at ${Formatters.formatMinuteOfDay(startMinute)}',
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: startMinute ~/ 60,
                          minute: startMinute % 60,
                        ),
                      );
                      if (time != null) {
                        setState(
                          () => startMinute = time.hour * 60 + time.minute,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: stepsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Steps (one per line)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;

                        final lines = stepsController.text
                            .split('\n')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList();

                        final id =
                            'routine_${DateTime.now().millisecondsSinceEpoch}';
                        await ref
                            .read(routineRepositoryProvider)
                            .saveRoutine(
                              id: id,
                              name: name,
                              type: 'sleep',
                              startMinuteOfDay: startMinute,
                              stepTitles: lines,
                            );

                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Save Routine'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
