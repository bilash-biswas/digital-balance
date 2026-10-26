import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_strings.dart';
import '../../../app/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon_widget.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../core/widgets/permission_guard_view.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/habit_repository_impl.dart';
import '../../../data/repositories/routine_repository_impl.dart';
import '../../../data/repositories/usage_repository_impl.dart';
import '../../app_restrictions/presentation/app_timer_dialog.dart';
import 'daily_goal_bottom_sheet.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  bool _isSyncing = false;

  final List<Color> _appColors = const [
    Color(0xFF9D65C9), // Soft Purple (e.g. Facebook)
    Color(0xFF2E7D32), // Forest Green (e.g. eFootball)
    Color(0xFF0288D1), // Cyan/Teal (e.g. Digital Balance)
    Color(0xFFEF6C00), // Amber (e.g. Chrome)
    Color(0xFFD81B60), // Deep Pink (e.g. YouTube)
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() => _isSyncing = true);
    try {
      await ref.read(usageRepositoryProvider).syncUsageData(backfillDays: 1);
      await ref.read(catalogRepositoryProvider).syncInstalledApps();
      await ref.read(permissionsProvider.notifier).refreshPermissions();

      // Trigger insight generation with real top apps
      final todayMins = await ref
          .read(usageRepositoryProvider)
          .getTodayTotalMinutes();
      final yestMins = await ref
          .read(usageRepositoryProvider)
          .getYesterdayTotalMinutes();
      final goalMins = await ref
          .read(settingsRepositoryProvider)
          .getDailyGoalMinutes();
      final topApps = await ref
          .read(usageRepositoryProvider)
          .getTodayTopApps();

      await ref
          .read(insightRepositoryProvider)
          .generateInsights(
            todayTotalMinutes: todayMins,
            yesterdayTotalMinutes: yestMins,
            dailyGoalMinutes: goalMins,
            topApps: topApps,
          );
    } catch (e, st) {
      AppLogger.error('Failed to refresh dashboard data: $e', e, st);
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permState = ref.watch(permissionsProvider);
    final usageRepo = ref.watch(usageRepositoryProvider);
    final habitRepo = ref.watch(habitRepositoryProvider);
    final insightRepo = ref.watch(insightRepositoryProvider);
    final focusRepo = ref.watch(focusRepositoryProvider);
    final restrictionRepo = ref.watch(restrictionRepositoryProvider);
    final todayStr = Formatters.formatFullDate(DateTime.now());

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
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
                Icons.spa_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          'Digital Wellbeing',
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
            tooltip: context.tr('syncUsage'),
            onPressed: _isSyncing ? null : _refreshData,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (val) {
              if (val == 'settings') context.push('/settings');
              if (val == 'catalog') context.push('/catalog');
              if (val == 'backup') context.push('/backup');
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Text(context.tr('settings')),
              ),
              const PopupMenuItem(
                value: 'catalog',
                child: Text('Manage apps'),
              ),
              const PopupMenuItem(
                value: 'backup',
                child: Text('Backup & restore'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Permission Alert Banner if Usage Access missing
            if (!permState.usageAccess) ...[
              PermissionGuardCard(
                title: 'Usage Access Required',
                description:
                    'To calculate and display your accurate on-device screen time, please enable Usage Access in Android Settings.',
                icon: Icons.lock_clock_outlined,
                buttonLabel: 'Enable Access',
                onAction: () =>
                    ref.read(permissionsProvider.notifier).openUsageSettings(),
              ),
              const SizedBox(height: 16),
            ],

            // Hero Multi-Colored Digital Wellbeing Donut Chart Card
            StreamBuilder<List<AppUsageWithCatalog>>(
              stream: usageRepo.watchTodayUsageWithCatalog(),
              builder: (context, snapshot) {
                final apps = snapshot.data ?? [];
                var totalMs = 0;
                for (final a in apps) {
                  totalMs += a.usage.foregroundTimeMs;
                }
                final totalMinutes = (totalMs / (1000 * 60)).round();

                return BalanceCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Donut Chart with Outer Slice Labels & Center Duration
                      SizedBox(
                        height: 230,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 68,
                                startDegreeOffset: -90,
                                sections: _buildDonutSections(
                                  theme,
                                  apps,
                                  totalMs,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.65),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  Formatters.formatWellbeingDuration(
                                    totalMinutes,
                                  ),
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Interactive Total Screen Time Daily Target Tile
                      StreamBuilder<int>(
                        stream: ref
                            .watch(settingsRepositoryProvider)
                            .watchDailyGoalMinutes(),
                        builder: (context, goalSnap) {
                          final goalMinutes =
                              goalSnap.data ??
                              AppConstants.defaultDailyGoalMinutes;
                          final fraction = goalMinutes > 0
                              ? (totalMinutes / goalMinutes).clamp(0.0, 1.0)
                              : 0.0;
                          final percent = goalMinutes > 0
                              ? ((totalMinutes / goalMinutes) * 100).round()
                              : 0;

                          final Color progressColor = percent >= 100
                              ? Colors.redAccent
                              : (percent >= 75
                                  ? Colors.amber
                                  : theme.colorScheme.primary);

                          return InkWell(
                            onTap: () {
                              DailyGoalBottomSheet.show(
                                context,
                                initialMinutes: goalMinutes,
                                onSaved: (newGoal) {
                                  ref
                                      .read(settingsRepositoryProvider)
                                      .setDailyGoalMinutes(newGoal);
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHigh
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.flag_outlined,
                                            size: 16,
                                            color: progressColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Daily Target: ${Formatters.formatDurationMinutes(goalMinutes)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '$percent%',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: progressColor,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.edit_outlined,
                                            size: 14,
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: fraction,
                                      minHeight: 6,
                                      backgroundColor: theme
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        progressColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Full-width Outlined Stadium Button: View app activity details
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.push('/analytics'),
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: BorderSide(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'View app activity details',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // Two Glance Cards: Unlocks & Notifications
            StreamBuilder<List<UsageHourlyData>>(
              stream: usageRepo.watchHourlyUsage(todayStr),
              builder: (context, hourlySnap) {
                final hourlyList = hourlySnap.data ?? [];
                var totalUnlocks = 0;
                for (final h in hourlyList) {
                  totalUnlocks += h.deviceUnlocks;
                }

                return StreamBuilder<int>(
                  stream: usageRepo.watchTodayNotificationCount(),
                  builder: (context, notifSnap) {
                    final notifCount = notifSnap.data ?? 0;

                    return Row(
                      children: [
                        // Unlocks Card
                        Expanded(
                          child: BalanceCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$totalUnlocks',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 32,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Unlocks',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Notifications Card
                        Expanded(
                          child: BalanceCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$notifCount',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 32,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Notifications',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Disclaimer Note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Text(
                "This data is from your personal profile and doesn't include other profile activities.",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Ways to disconnect Section
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Ways to disconnect',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

            BalanceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // App timers
                  StreamBuilder<Map<String, int>>(
                    stream: restrictionRepo.watchAppLimitsMap(),
                    builder: (context, limitsSnap) {
                      final count = limitsSnap.data?.length ?? 0;
                      final subtitle = count == 0
                          ? 'No timers set'
                          : (count == 1 ? '1 timer set' : '$count timers set');

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 4,
                        ),
                        title: const Text(
                          'App timers',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          subtitle,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () => context.push('/rules'),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),

                  // Bedtime mode
                  StreamBuilder<List<RoutineWithSteps>>(
                    stream: ref
                        .watch(routineRepositoryProvider)
                        .watchRoutines(),
                    builder: (context, snap) {
                      final routines = snap.data ?? [];
                      final bedtime = routines
                          .where(
                            (r) =>
                                r.routine.name
                                    .toLowerCase()
                                    .contains('bedtime') ||
                                r.routine.type == 'bedtime',
                          )
                          .firstOrNull;
                      final subtitle =
                          bedtime != null && bedtime.routine.isEnabled
                              ? 'Turns on at ${Formatters.formatMinuteOfDay(bedtime.routine.startMinuteOfDay)}'
                              : 'Off / Turns on at 12:00 AM';

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 4,
                        ),
                        title: const Text(
                          'Bedtime mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          subtitle,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () => context.push('/routines'),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),

                  // Focus
                  StreamBuilder<FocusSession?>(
                    stream: focusRepo.watchActiveSession(),
                    builder: (context, snap) {
                      final session = snap.data;
                      final subtitle = session != null
                          ? 'Active session (${session.status})'
                          : 'Tap to set up';

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 4,
                        ),
                        title: const Text(
                          'Focus',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          subtitle,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () => session != null
                            ? context.push('/focus/active')
                            : context.push('/focus'),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Active Focus Session or Quick Focus Card
            StreamBuilder<FocusSession?>(
              stream: focusRepo.watchActiveSession(),
              builder: (context, focusSnap) {
                final session = focusSnap.data;
                if (session != null) {
                  return BalanceCard(
                    color: theme.colorScheme.tertiaryContainer.withValues(
                      alpha: 0.35,
                    ),
                    onTap: () => context.push('/focus/active'),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: theme.colorScheme.tertiary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Focus Session Active (${session.status})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Tap to resume controls',
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
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  );
                }

                return BalanceCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Need to focus?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Start a 25-minute Pomodoro session',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('Focus'),
                        onPressed: () async {
                          await focusRepo.startSession(durationMinutes: 25);
                          if (context.mounted) {
                            await context.push('/focus/active');
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // Most Used Applications Card (with Real Icons & Hourglass Timers)
            StreamBuilder<Map<String, int>>(
              stream: restrictionRepo.watchAppLimitsMap(),
              builder: (context, limitsSnap) {
                final limitsMap = limitsSnap.data ?? {};

                return StreamBuilder<List<AppUsageWithCatalog>>(
                  stream: usageRepo.watchTodayUsageWithCatalog(),
                  builder: (context, snapshot) {
                    final apps = snapshot.data ?? [];
                    if (apps.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final topApps = apps.take(5).toList();

                    return BalanceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.tr('mostUsed'),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.push('/catalog'),
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...topApps.map((item) {
                            final app = item.usage;
                            final appName = item.appName;
                            final limit = limitsMap[app.packageName];
                            final hasLimit = limit != null && limit > 0;
                            final durationStr = Formatters.formatDurationMs(
                              app.foregroundTimeMs,
                            );

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => context.push(
                                  '/app-detail?packageName=${Uri.encodeComponent(app.packageName)}&appName=${Uri.encodeComponent(appName)}',
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      // Real Native Android App Icon
                                      AppIconWidget(
                                        packageName: app.packageName,
                                        appName: appName,
                                        size: 42,
                                        borderRadius: 12,
                                      ),
                                      const SizedBox(width: 14),

                                      // App Name & Duration
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              appName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              durationStr,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.65),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Hourglass App Timer Icon Button
                                      IconButton(
                                        icon: hasLimit
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.hourglass_bottom_rounded,
                                                    color: theme.colorScheme.primary,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    Formatters.formatDurationMinutes(
                                                      limit,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                          theme.colorScheme.primary,
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
                          }),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 14),

            // Habits Row
            StreamBuilder<List<HabitWithStreak>>(
              stream: habitRepo.watchHabits(),
              builder: (context, snapshot) {
                final habits = snapshot.data ?? [];
                if (habits.isEmpty) return const SizedBox.shrink();

                return BalanceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Habit Check-in',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/you'),
                            child: const Text('Habits'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ...habits.take(3).map((h) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            h.habit.title,
                            style: TextStyle(
                              decoration: h.isCompletedToday
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Streak: ${h.streak?.currentStreak ?? 0} days',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              h.isCompletedToday
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: h.isCompletedToday
                                  ? Colors.green
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    ),
                            ),
                            onPressed: () async {
                              await habitRepo.toggleHabitToday(h.habit.id);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // Recent Insight Card
            StreamBuilder<List<Insight>>(
              stream: insightRepo.watchInsights(),
              builder: (context, snapshot) {
                final insights = snapshot.data ?? [];
                if (insights.isEmpty) return const SizedBox.shrink();
                final insight = insights.first;

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
                                Icons.lightbulb_outline,
                                color: theme.colorScheme.tertiary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                insight.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () =>
                                insightRepo.dismissInsight(insight.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        insight.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildDonutSections(
    ThemeData theme,
    List<AppUsageWithCatalog> apps,
    int totalMs,
  ) {
    if (apps.isEmpty || totalMs == 0) {
      return [
        PieChartSectionData(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          value: 100,
          radius: 24,
          showTitle: false,
        ),
      ];
    }

    final sections = <PieChartSectionData>[];
    final topApps = apps.take(4).toList();
    var topMs = 0;

    for (var i = 0; i < topApps.length; i++) {
      final app = topApps[i];
      final ms = app.usage.foregroundTimeMs;
      topMs += ms;
      final color = _appColors[i % _appColors.length];
      final title = app.appName.length > 8
          ? '${app.appName.substring(0, 6)}…'
          : app.appName;

      sections.add(
        PieChartSectionData(
          color: color,
          value: ms.toDouble(),
          radius: 26,
          showTitle: true,
          title: title,
          titlePositionPercentageOffset: 1.45,
          titleStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    final remainingMs = totalMs - topMs;
    if (remainingMs > 0) {
      sections.add(
        PieChartSectionData(
          color: const Color(0xFFB0A4C4),
          value: remainingMs.toDouble(),
          radius: 26,
          showTitle: true,
          title: 'Other',
          titlePositionPercentageOffset: 1.45,
          titleStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    return sections;
  }
}
