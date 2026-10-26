import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon_widget.dart';
import '../../../data/repositories/usage_repository_impl.dart';
import '../../app_restrictions/presentation/app_timer_dialog.dart';

class AppDetailScreen extends ConsumerStatefulWidget {
  final String packageName;
  final String appName;

  const AppDetailScreen({
    super.key,
    required this.packageName,
    required this.appName,
  });

  @override
  ConsumerState<AppDetailScreen> createState() => _AppDetailScreenState();
}

class _AppDetailScreenState extends ConsumerState<AppDetailScreen> {
  int _selectedDayIndex = 6; // 0..6 (6 = today)

  String _formatWellbeingDuration(int totalMinutes) {
    if (totalMinutes <= 0) return '0 minutes';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '$hours hr, $minutes min';
    } else if (hours > 0) {
      return '$hours hr';
    } else if (minutes == 1) {
      return '1 minute';
    } else {
      return '$minutes minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usageRepo = ref.watch(usageRepositoryProvider);
    final restrictionRepo = ref.watch(restrictionRepositoryProvider);
    final bridge = ref.watch(platformBridgeProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          widget.appName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                onTap: () => bridge.openNotificationSettings(widget.packageName),
                child: const Text('App notification settings'),
              ),
              PopupMenuItem(
                value: 'timer',
                onTap: () async {
                  final limits = await restrictionRepo.watchAppLimitsMap().first;
                  if (context.mounted) {
                    await AppTimerDialog.show(
                      context,
                      packageName: widget.packageName,
                      appName: widget.appName,
                      currentLimitMinutes: limits[widget.packageName] ?? 0,
                    );
                  }
                },
                child: const Text('Set app timer'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<DailyUsageTotal>>(
        stream: usageRepo.watchAppLast7DaysUsage(widget.packageName),
        builder: (context, snapshot) {
          final dailyTotals = snapshot.data ?? [];
          final clampedIdx = dailyTotals.isEmpty
              ? 0
              : _selectedDayIndex.clamp(0, dailyTotals.length - 1);
          final selectedDay =
              dailyTotals.isNotEmpty ? dailyTotals[clampedIdx] : null;
          final isToday = clampedIdx == (dailyTotals.length - 1);
          final isYesterday = clampedIdx == (dailyTotals.length - 2);

          String daySubtitle = 'Today';
          if (selectedDay != null) {
            if (isToday) {
              daySubtitle = 'Today';
            } else if (isYesterday) {
              daySubtitle = 'Yesterday';
            } else {
              daySubtitle = Formatters.formatDate(selectedDay.date);
            }
          }

          final selectedDayMinutes = selectedDay?.totalMinutes ?? 0;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // Dropdown Pills Row: Screen time ▾ and Daily ▾
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.7,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Screen time',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.7,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Daily',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Big App Icon
              Center(
                child: AppIconWidget(
                  packageName: widget.packageName,
                  appName: widget.appName,
                  size: 58,
                  borderRadius: 16,
                ),
              ),

              const SizedBox(height: 14),

              // Hero Duration Text (e.g. 3 hr, 38 min)
              Center(
                child: Text(
                  _formatWellbeingDuration(selectedDayMinutes),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Date Subtitle (Today / Yesterday / Sat, Oct 10)
              Center(
                child: Text(
                  daySubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Weekly Bar Chart for this specific app
              _buildAppWeeklyBarChart(
                theme: theme,
                dailyTotals: dailyTotals,
                selectedIdx: clampedIdx,
              ),

              const SizedBox(height: 16),

              // Date Navigator: <  Mon, Oct 12  >
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: clampedIdx > 0
                        ? () => setState(() => _selectedDayIndex = clampedIdx - 1)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedDay != null
                        ? Formatters.formatDate(selectedDay.date)
                        : Formatters.formatDate(DateTime.now()),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: clampedIdx < dailyTotals.length - 1
                        ? () => setState(() => _selectedDayIndex = clampedIdx + 1)
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Settings Section Header
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 8),

              // App timer List Tile
              StreamBuilder<Map<String, int>>(
                stream: restrictionRepo.watchAppLimitsMap(),
                builder: (context, limitsSnap) {
                  final limitsMap = limitsSnap.data ?? {};
                  final currentLimit = limitsMap[widget.packageName] ?? 0;
                  final hasLimit = currentLimit > 0;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => AppTimerDialog.show(
                      context,
                      packageName: widget.packageName,
                      appName: widget.appName,
                      currentLimitMinutes: currentLimit,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            hasLimit
                                ? Icons.hourglass_bottom_rounded
                                : Icons.hourglass_empty_rounded,
                            size: 24,
                            color: hasLimit
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'App timer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasLimit
                                      ? Formatters.formatDurationMinutes(
                                          currentLimit,
                                        )
                                      : 'No timer',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 4),

              // Manage notifications List Tile
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => bridge.openNotificationSettings(widget.packageName),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 24,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text(
                          'Manage notifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppWeeklyBarChart({
    required ThemeData theme,
    required List<DailyUsageTotal> dailyTotals,
    required int selectedIdx,
  }) {
    var maxMins = 0;
    for (final d in dailyTotals) {
      if (d.totalMinutes > maxMins) maxMins = d.totalMinutes;
    }
    // Dynamic maxY rounded to clean hours (min 4h)
    final maxY = max(240.0, ((maxMins + 59) ~/ 60 * 60).toDouble());
    final interval = max(60.0, maxY / 4);

    return SizedBox(
      height: 170,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchCallback: (event, response) {
              if (response != null &&
                  response.spot != null &&
                  event.isInterestedForInteractions) {
                final touchedIdx = response.spot!.touchedBarGroupIndex;
                if (touchedIdx >= 0 && touchedIdx < dailyTotals.length) {
                  setState(() => _selectedDayIndex = touchedIdx);
                }
              }
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: interval,
                getTitlesWidget: (val, _) {
                  final h = (val / 60).round();
                  return Text(
                    '${h}h',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final idx = val.toInt();
                  if (idx < 0 || idx >= dailyTotals.length) {
                    return const SizedBox.shrink();
                  }
                  final item = dailyTotals[idx];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      item.dayOfWeekLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: idx == selectedIdx
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: idx == selectedIdx
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (_) => FlLine(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(dailyTotals.length, (idx) {
            final isSelected = idx == selectedIdx;
            final color = isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.primaryContainer.withValues(alpha: 0.75);

            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: dailyTotals[idx].totalMinutes.toDouble(),
                  color: color,
                  width: 26,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
