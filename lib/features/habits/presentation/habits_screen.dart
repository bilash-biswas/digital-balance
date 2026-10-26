import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../data/repositories/habit_repository_impl.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitRepo = ref.watch(habitRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
        onPressed: () => _openAddHabitDialog(context),
      ),
      body: StreamBuilder<List<HabitWithStreak>>(
        stream: habitRepo.watchHabits(),
        builder: (context, snapshot) {
          final habits = snapshot.data ?? [];

          if (habits.isEmpty) {
            return EmptyStateView(
              icon: Icons.checklist_rtl_outlined,
              title: 'Build Positive Habits',
              description:
                  'Create daily or weekly routines such as reading, mindfulness, or device-free meals.',
              actionLabel: 'Create First Habit',
              onAction: () => _openAddHabitDialog(context),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: habits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final h = habits[index];
              final streak = h.streak?.currentStreak ?? 0;

              return BalanceCard(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        h.isCompletedToday
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: h.isCompletedToday
                            ? Colors.green
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                        size: 28,
                      ),
                      onPressed: () {
                        habitRepo.toggleHabitToday(h.habit.id);
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            h.habit.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: h.isCompletedToday
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            h.habit.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: streak > 0
                            ? Colors.orange.withValues(alpha: 0.15)
                            : theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: streak > 0
                                ? Colors.orange
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$streak d',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: streak > 0
                                  ? Colors.orange
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openAddHabitDialog(BuildContext context) {
    final titleController = TextEditingController();
    String category = 'Productivity';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                'New Habit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Habit Title',
                  hintText: 'e.g. Read for 20 minutes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items:
                    [
                          'Productivity',
                          'Mindfulness',
                          'Health',
                          'Learning',
                          'General',
                        ]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                onChanged: (val) {
                  if (val != null) category = val;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    if (title.isEmpty) return;

                    final id = 'habit_${DateTime.now().millisecondsSinceEpoch}';
                    await ref
                        .read(habitRepositoryProvider)
                        .saveHabit(id: id, title: title, category: category);

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Create Habit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
