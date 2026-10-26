import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/accessibility_disclosure_dialog.dart';
import '../../../core/widgets/app_icon_widget.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/permission_guard_view.dart';
import '../../../data/repositories/restriction_repository_impl.dart';

class RulesListScreen extends ConsumerWidget {
  const RulesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final restrictionRepo = ref.watch(restrictionRepositoryProvider);
    final permState = ref.watch(permissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Restrictions & Timers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New Rule'),
        onPressed: () => context.push('/rules/editor'),
      ),
      body: StreamBuilder<List<RestrictionRuleWithTargets>>(
        stream: restrictionRepo.watchRules(),
        builder: (context, snapshot) {
          final rules = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // Accessibility disclosure banner if not enabled
              if (!permState.accessibility) ...[
                PermissionGuardCard(
                  title: 'Enforcement Service Inactive',
                  description:
                      'To intervene when restricted apps are launched, Digital Balance requires the Accessibility Service to be enabled.',
                  icon: Icons.accessibility_new,
                  buttonLabel: 'Enable Service',
                  onAction: () {
                    AccessibilityDisclosureDialog.show(
                      context,
                      onApproved: () {
                        ref
                            .read(permissionsProvider.notifier)
                            .openAccessibilitySettings();
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Quick Distraction Cap Template Card
              BalanceCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Multi-App Distraction Cap',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'One total limit for all Social, Games & Media',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: () => context.push(
                        '/rules/editor?preset=distraction_cap',
                      ),
                      child: const Text('Set Cap'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (rules.isEmpty)
                EmptyStateView(
                  icon: Icons.hourglass_empty_rounded,
                  title: 'No App Timers or Rules',
                  description:
                      'Set daily limits or schedules on distracting applications to help build healthier phone habits.',
                  actionLabel: 'Create First Rule',
                  onAction: () => context.push('/rules/editor'),
                )
              else
                ...rules.map((item) {
                  final rule = item.rule;
                  final hasSchedule =
                      rule.startMinuteOfDay >= 0 && rule.endMinuteOfDay >= 0;
                  final hasDailyLimit = rule.limitMinutesPerDay > 0;
                  final singlePackage = item.targetPackages.length == 1
                      ? item.targetPackages.first
                      : null;

                  String scheduleLabel = 'No schedule';
                  if (hasSchedule) {
                    final start = Formatters.formatMinuteOfDay(
                      rule.startMinuteOfDay,
                    );
                    final end = Formatters.formatMinuteOfDay(
                      rule.endMinuteOfDay,
                    );
                    scheduleLabel = '$start – $end';
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BalanceCard(
                      onTap: () => context.push('/rules/editor?id=${rule.id}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (singlePackage != null) ...[
                                AppIconWidget(
                                  packageName: singlePackage,
                                  appName: rule.name,
                                  size: 40,
                                  borderRadius: 10,
                                ),
                                const SizedBox(width: 12),
                              ] else ...[
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.shield_outlined,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rule.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${item.targetPackages.length} target ${item.targetPackages.length == 1 ? "app" : "apps"}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: rule.isEnabled,
                                onChanged: (val) {
                                  restrictionRepo.toggleRule(rule.id, val);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (hasDailyLimit) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.hourglass_bottom_rounded,
                                        size: 14,
                                        color: theme.colorScheme.onPrimaryContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Timer: ${Formatters.formatDurationMinutes(rule.limitMinutesPerDay)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (hasSchedule)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.schedule_rounded,
                                        size: 14,
                                        color:
                                            theme.colorScheme.onSecondaryContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        scheduleLabel,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: theme
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 60),
            ],
          );
        },
      ),
    );
  }
}
