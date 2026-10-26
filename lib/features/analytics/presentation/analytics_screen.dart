import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon_widget.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/usage_repository_impl.dart';
import 'package:go_router/go_router.dart';
import '../../app_restrictions/presentation/app_timer_dialog.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _selectedDayIndex = 6; // Index 0..6 in 7-day range (6 = today)
  String _viewMode = 'screen_time'; // 'screen_time' or 'hourly'
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    setState(() => _isSyncing = true);
    await ref.read(usageRepositoryProvider).syncUsageData();
    if (mounted) setState(() => _isSyncing = false);
  }

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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.6),
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
              )
            : null,
        title: const Text(
          'App activity details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            tooltip: 'Sync Usage',
            onPressed: _isSyncing ? null : _refreshData,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sync',
                onTap: _refreshData,
                child: const Text('Refresh usage data'),
              ),
              PopupMenuItem(
                value: 'rules',
                onTap: () => context.push('/rules'),
                child: const Text('Manage app timers'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<DailyUsageTotal>>(
        stream: usageRepo.watchRecentDailyTotals(days: 7),
        builder: (context, snapshot) {
          final dailyTotals = snapshot.data ?? [];
          final clampedIdx = dailyTotals.isEmpty
              ? 0
              : _selectedDayIndex.clamp(0, dailyTotals.length - 1);
          final selectedDay = dailyTotals.isNotEmpty ? dailyTotals[clampedIdx] : null;
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
          final selectedDateStr = selectedDay?.dateStr ??
              Formatters.formatFullDate(DateTime.now());

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Mode Selector Pill (Screen time v / Hourly heatmap v)
                Center(
                  child: PopupMenuButton<String>(
                    onSelected: (val) => setState(() => _viewMode = val),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'screen_time',
                        child: Row(
                          children: [
                            Icon(Icons.bar_chart, size: 20),
                            SizedBox(width: 10),
                            Text('Screen time'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'hourly',
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 20),
                            SizedBox(width: 10),
                            Text('Hourly heatmap'),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.65,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _viewMode == 'screen_time'
                                ? 'Screen time'
                                : 'Hourly heatmap',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hero Headline: e.g. "5 hr, 57 min" / "Today"
                Center(
                  child: Column(
                    children: [
                      Text(
                        _formatWellbeingDuration(selectedDayMinutes),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        daySubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Chart Container
                if (_viewMode == 'screen_time') ...[
                  // Weekly Bar Chart
                  _buildWeeklyBarChart(theme, dailyTotals, clampedIdx),
                ] else ...[
                  // Hourly Heatmap Bar Chart
                  _buildHourlyHeatmap(theme, usageRepo, selectedDateStr),
                ],
                const SizedBox(height: 16),

                // Date Navigator Row: <  Mon, Oct 12  >
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
                        fontWeight: FontWeight.bold,
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
                const SizedBox(height: 12),

                // App Activity List for selected day
                StreamBuilder<Map<String, int>>(
                  stream: restrictionRepo.watchAppLimitsMap(),
                  builder: (context, limitsSnap) {
                    final limitsMap = limitsSnap.data ?? {};

                    return StreamBuilder<List<AppUsageWithCatalog>>(
                      stream: usageRepo.watchDateUsageWithCatalog(selectedDateStr),
                      builder: (context, appsSnap) {
                        final apps = appsSnap.data ?? [];
                        if (apps.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No app activity recorded for $daySubtitle.',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: apps.map((item) {
                            final app = item.usage;
                            final appName = item.appName;
                            final limit = limitsMap[app.packageName];
                            final hasLimit = limit != null && limit > 0;
                            final mins = (app.foregroundTimeMs / (1000 * 60)).round();

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => context.push(
                                  '/app-detail?packageName=${Uri.encodeComponent(app.packageName)}&appName=${Uri.encodeComponent(appName)}',
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      // Real Native Android App Icon
                                      AppIconWidget(
                                        packageName: app.packageName,
                                        appName: appName,
                                        size: 44,
                                        borderRadius: 12,
                                      ),
                                      const SizedBox(width: 16),

                                      // App Name & Duration
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              appName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _formatWellbeingDuration(mins),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.65),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Divider & Hourglass App Timer Icon
                                      Container(
                                        height: 32,
                                        width: 1,
                                        color: theme.colorScheme.outlineVariant
                                            .withValues(alpha: 0.5),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                      ),
                                      IconButton(
                                        icon: hasLimit
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.hourglass_bottom_rounded,
                                                    color: theme.colorScheme.primary,
                                                    size: 22,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    Formatters.formatDurationMinutes(
                                                      limit,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme.colorScheme
                                                          .primary,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Icon(
                                                Icons.hourglass_empty_rounded,
                                                color: theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                                size: 22,
                                              ),
                                        tooltip: 'Set app timer',
                                        onPressed: () => AppTimerDialog.show(
                                          context,
                                          packageName: app.packageName,
                                          appName: appName,
                                          currentLimitMinutes: limit ?? 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyBarChart(
    ThemeData theme,
    List<DailyUsageTotal> dailyTotals,
    int selectedIdx,
  ) {
    var maxMins = 0;
    for (final d in dailyTotals) {
      if (d.totalMinutes > maxMins) maxMins = d.totalMinutes;
    }
    // Dynamic maxY rounded to next 3-hour interval (e.g. 6h, 9h, 12h)
    final maxY = max(360.0, ((maxMins + 120) ~/ 180 * 180).toDouble());

    return SizedBox(
      height: 180,
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
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = groupIndex < dailyTotals.length
                    ? dailyTotals[groupIndex]
                    : null;
                final dayLabel = item?.dayOfWeekLabel ?? '';
                final duration = _formatWellbeingDuration(rod.toY.toInt());
                return BarTooltipItem(
                  '$dayLabel\n$duration',
                  TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
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
                interval: 180, // 3h intervals
                getTitlesWidget: (val, _) {
                  return Text(
                    '${val.toInt() ~/ 60}h',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                  final label = (idx >= 0 && idx < dailyTotals.length)
                      ? dailyTotals[idx].dayOfWeekLabel
                      : '';
                  final isSelected = idx == selectedIdx;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
            horizontalInterval: 180,
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
                : theme.colorScheme.primary.withValues(alpha: 0.35);

            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: dailyTotals[idx].totalMinutes.toDouble(),
                  color: color,
                  width: 24,
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

  Widget _buildHourlyHeatmap(
    ThemeData theme,
    UsageRepository usageRepo,
    String dateStr,
  ) {
    return StreamBuilder<List<UsageHourlyData>>(
      stream: usageRepo.watchHourlyUsage(dateStr),
      builder: (context, snapshot) {
        final hourlyList = snapshot.data ?? [];

        return SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 60,
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
                    interval: 30,
                    getTitlesWidget: (val, _) {
                      return Text(
                        '${val.toInt()}m',
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 4,
                    getTitlesWidget: (val, _) {
                      final hour = val.toInt();
                      if (hour % 4 != 0 && hour != 23) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${hour}h',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
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
                horizontalInterval: 30,
                getDrawingHorizontalLine: (_) => FlLine(
                  color:
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(24, (hour) {
                final match = hourlyList
                    .where((h) => h.hourOfDay == hour)
                    .firstOrNull;
                final mins = match != null
                    ? (match.foregroundTimeMs / (1000 * 60))
                        .round()
                        .clamp(0, 60)
                    : 0;

                return BarChartGroupData(
                  x: hour,
                  barRods: [
                    BarChartRodData(
                      toY: mins.toDouble(),
                      color: mins > 0
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 8,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
