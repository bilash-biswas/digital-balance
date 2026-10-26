import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../data/database/app_database.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final insightRepo = ref.watch(insightRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wellbeing Insights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Insight>>(
        stream: insightRepo.watchInsights(),
        builder: (context, snapshot) {
          final insights = snapshot.data ?? [];

          if (insights.isEmpty) {
            return const EmptyStateView(
              icon: Icons.lightbulb_outline,
              title: 'No New Insights',
              description:
                  'As you continue using your device, Digital Balance analyzes local usage trends without sending data to any cloud servers.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: insights.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final insight = insights[index];

              Color tagColor = theme.colorScheme.primary;
              IconData tagIcon = Icons.info_outline;

              switch (insight.type) {
                case 'achievement':
                  tagColor = Colors.green;
                  tagIcon = Icons.check_circle_outline;
                  break;
                case 'warning':
                  tagColor = Colors.orange;
                  tagIcon = Icons.warning_amber_outlined;
                  break;
                case 'suggestion':
                  tagColor = theme.colorScheme.secondary;
                  tagIcon = Icons.tips_and_updates_outlined;
                  break;
              }

              return BalanceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(tagIcon, size: 20, color: tagColor),
                        const SizedBox(width: 8),
                        Text(
                          insight.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () =>
                              insightRepo.dismissInsight(insight.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      insight.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.85,
                        ),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.data_usage,
                            size: 14,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Evidence: ${insight.evidence}',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
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
}
