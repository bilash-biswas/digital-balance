import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon_widget.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../data/database/app_database.dart';
import '../../app_restrictions/presentation/app_timer_dialog.dart';

class AppCatalogScreen extends ConsumerStatefulWidget {
  const AppCatalogScreen({super.key});

  @override
  ConsumerState<AppCatalogScreen> createState() => _AppCatalogScreenState();
}

class _AppCatalogScreenState extends ConsumerState<AppCatalogScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogRepo = ref.watch(catalogRepositoryProvider);
    final restrictionRepo = ref.watch(restrictionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Catalog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search installed apps...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) =>
                  setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
          ),

          // App List
          Expanded(
            child: StreamBuilder<Map<String, int>>(
              stream: restrictionRepo.watchAppLimitsMap(),
              builder: (context, limitsSnap) {
                final limitsMap = limitsSnap.data ?? {};

                return StreamBuilder<List<AppCatalogData>>(
                  stream: catalogRepo.watchAllApps(),
                  builder: (context, snapshot) {
                    final allApps = snapshot.data ?? [];
                    final filtered = allApps.where((app) {
                      if (_searchQuery.isEmpty) return true;
                      return app.appName.toLowerCase().contains(_searchQuery) ||
                          app.packageName.toLowerCase().contains(_searchQuery);
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text('No applications match your search.'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final app = filtered[index];
                        final limit = limitsMap[app.packageName];
                        final hasLimit = limit != null && limit > 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: BalanceCard(
                            onTap: () => context.push(
                              '/app-detail?packageName=${Uri.encodeComponent(app.packageName)}&appName=${Uri.encodeComponent(app.appName)}',
                            ),
                            child: Row(
                              children: [
                                // Real Native Android App Icon
                                AppIconWidget(
                                  packageName: app.packageName,
                                  appName: app.appName,
                                  size: 44,
                                  borderRadius: 12,
                                ),
                                const SizedBox(width: 14),

                                // App Name & Package
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        app.appName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        app.packageName,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                if (app.isSystemApp) ...[
                                  const Chip(
                                    label: Text(
                                      'System',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],

                                // Hourglass Timer Trigger
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
                                              Formatters.formatDurationMinutes(limit),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: theme.colorScheme.primary,
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
                                    appName: app.appName,
                                    currentLimitMinutes: limit ?? 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
