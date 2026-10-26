import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon_widget.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../data/database/app_database.dart';

class RuleEditorScreen extends ConsumerStatefulWidget {
  final String? ruleId;
  final String? preset;

  const RuleEditorScreen({super.key, this.ruleId, this.preset});

  @override
  ConsumerState<RuleEditorScreen> createState() => _RuleEditorScreenState();
}

class _RuleEditorScreenState extends ConsumerState<RuleEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Focus Rule');

  final Set<String> _selectedPackages = {};
  int _limitMinutes = 30;
  bool _enableDailyLimit = false;

  bool _enableSchedule = true;
  int _startMinute = 22 * 60; // 22:00
  int _endMinute = 7 * 60; // 07:00 (overnight)
  final Set<int> _selectedDays = {1, 2, 3, 4, 5, 6, 7};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.ruleId != null) {
      _loadExistingRule();
    } else if (widget.preset == 'distraction_cap') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyDistractionCapPreset();
      });
    }
  }

  Future<void> _applyDistractionCapPreset() async {
    final db = ref.read(databaseProvider);
    final apps = await db.select(db.appCatalog).get();
    final categories = await db.select(db.appCategories).get();

    final distractionCatIds = categories
        .where((c) {
          final n = c.name.toLowerCase();
          return n == 'social' || n == 'games' || n == 'entertainment';
        })
        .map((c) => c.id)
        .toSet();

    final targetPackages = apps
        .where(
          (a) =>
              a.categoryId != null && distractionCatIds.contains(a.categoryId),
        )
        .map((a) => a.packageName)
        .toSet();

    if (mounted) {
      setState(() {
        _nameController.text = 'Daily Distraction Cap';
        _enableDailyLimit = true;
        _limitMinutes = 45;
        _enableSchedule = false;
        _selectedPackages.addAll(targetPackages);
      });
    }
  }

  Future<void> _loadExistingRule() async {
    // Loads rule from database
    final db = ref.read(databaseProvider);
    final rule = await (db.select(
      db.restrictionRules,
    )..where((tbl) => tbl.id.equals(widget.ruleId!))).getSingleOrNull();
    if (rule != null) {
      final targets = await (db.select(
        db.restrictionTargets,
      )..where((tbl) => tbl.ruleId.equals(rule.id))).get();
      setState(() {
        _nameController.text = rule.name;
        _enableDailyLimit = rule.limitMinutesPerDay > 0;
        _limitMinutes = rule.limitMinutesPerDay > 0
            ? rule.limitMinutesPerDay
            : 30;
        _enableSchedule =
            rule.startMinuteOfDay >= 0 && rule.endMinuteOfDay >= 0;
        if (_enableSchedule) {
          _startMinute = rule.startMinuteOfDay;
          _endMinute = rule.endMinuteOfDay;
        }
        _selectedPackages.addAll(targets.map((t) => t.packageName));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restrictionRepo = ref.watch(restrictionRepositoryProvider);

    final isOvernight = _startMinute > _endMinute;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ruleId == null ? 'Create Rule' : 'Edit Rule'),
        actions: [
          if (widget.ruleId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                await restrictionRepo.deleteRule(widget.ruleId!);
                if (context.mounted) context.pop();
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Rule Name Field
            BalanceCard(
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Rule Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
            ),
            const SizedBox(height: 14),

            // Select Target Apps
            BalanceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Target Applications (${_selectedPackages.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _openAppPickerModal(context),
                        child: const Text('Choose Apps'),
                      ),
                    ],
                  ),
                  StreamBuilder<List<AppCatalogData>>(
                    stream: ref.watch(catalogRepositoryProvider).watchAllApps(),
                    builder: (context, catSnap) {
                      final appMap = {
                        for (final a in (catSnap.data ?? <AppCatalogData>[]))
                          a.packageName: a.appName,
                      };

                      if (_selectedPackages.isEmpty) {
                        return Text(
                          'No apps selected yet. Tap "Choose Apps" to pick targets.',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        );
                      }

                      return Wrap(
                        spacing: 8,
                        children: _selectedPackages.map((pkg) {
                          final label = (appMap[pkg] != null && appMap[pkg]!.isNotEmpty)
                              ? appMap[pkg]!
                              : pkg.split('.').last;
                          return Chip(
                            label: Text(
                              label,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onDeleted: () =>
                                setState(() => _selectedPackages.remove(pkg)),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Scheduled Window Section
            BalanceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scheduled Window',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: _enableSchedule,
                        onChanged: (val) =>
                            setState(() => _enableSchedule = val),
                      ),
                    ],
                  ),
                  if (_enableSchedule) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: _startMinute ~/ 60,
                                  minute: _startMinute % 60,
                                ),
                              );
                              if (time != null) {
                                setState(
                                  () => _startMinute =
                                      time.hour * 60 + time.minute,
                                );
                              }
                            },
                            child: Column(
                              children: [
                                const Text(
                                  'Starts',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  Formatters.formatMinuteOfDay(_startMinute),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: _endMinute ~/ 60,
                                  minute: _endMinute % 60,
                                ),
                              );
                              if (time != null) {
                                setState(
                                  () =>
                                      _endMinute = time.hour * 60 + time.minute,
                                );
                              }
                            },
                            child: Column(
                              children: [
                                const Text(
                                  'Ends',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  Formatters.formatMinuteOfDay(_endMinute),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isOvernight) ...[
                      const SizedBox(height: 8),
                      Text(
                        '• Overnight schedule (spans across midnight)',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Active Days:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDayChip('M', 1),
                        _buildDayChip('T', 2),
                        _buildDayChip('W', 3),
                        _buildDayChip('T', 4),
                        _buildDayChip('F', 5),
                        _buildDayChip('S', 6),
                        _buildDayChip('S', 7),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Daily Usage Limit Section
            BalanceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Time Limit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: _enableDailyLimit,
                        onChanged: (val) =>
                            setState(() => _enableDailyLimit = val),
                      ),
                    ],
                  ),
                  if (_enableDailyLimit) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Limit: ${Formatters.formatDurationMinutes(_limitMinutes)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Slider(
                      value: _limitMinutes.toDouble(),
                      min: 5,
                      max: 240,
                      divisions: 47,
                      label: '${_limitMinutes}m',
                      onChanged: (val) =>
                          setState(() => _limitMinutes = val.round()),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Action
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (_selectedPackages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select at least one application',
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);
                        final id =
                            widget.ruleId ??
                            'rule_${DateTime.now().millisecondsSinceEpoch}';

                        await restrictionRepo.saveRule(
                          id: id,
                          name: _nameController.text.trim(),
                          packageNames: _selectedPackages.toList(),
                          limitMinutesPerDay: _enableDailyLimit
                              ? _limitMinutes
                              : 0,
                          startMinuteOfDay: _enableSchedule ? _startMinute : -1,
                          endMinuteOfDay: _enableSchedule ? _endMinute : -1,
                          daysOfWeek: _selectedDays.toList(),
                        );

                        if (context.mounted) {
                          context.pop();
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save & Apply Restriction'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDayChip(String label, int day) {
    final isSelected = _selectedDays.contains(day);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          if (val) {
            _selectedDays.add(day);
          } else if (_selectedDays.length > 1) {
            _selectedDays.remove(day);
          }
        });
      },
    );
  }

  void _openAppPickerModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final catalogRepo = ref.watch(catalogRepositoryProvider);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              builder: (context, scrollController) {
                return StreamBuilder<List<AppCatalogData>>(
                  stream: catalogRepo.watchAllApps(),
                  builder: (context, snapshot) {
                    final apps = snapshot.data ?? [];

                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Select Applications to Restrict',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: apps.length,
                            itemBuilder: (context, index) {
                              final app = apps[index];
                              final isSelected = _selectedPackages.contains(
                                app.packageName,
                              );

                              return CheckboxListTile(
                                value: isSelected,
                                secondary: AppIconWidget(
                                  packageName: app.packageName,
                                  appName: app.appName,
                                  size: 36,
                                  borderRadius: 8,
                                ),
                                title: Text(app.appName),
                                subtitle: Text(
                                  app.packageName,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedPackages.add(app.packageName);
                                    } else {
                                      _selectedPackages.remove(app.packageName);
                                    }
                                  });
                                  (context as Element).markNeedsBuild();
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
