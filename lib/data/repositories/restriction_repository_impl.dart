import 'dart:convert';
import 'package:drift/drift.dart';
import '../../core/logging/app_logger.dart';
import '../../core/platform/platform_bridge.dart';
import '../database/app_database.dart';

class RestrictionRuleWithTargets {
  final RestrictionRule rule;
  final List<String> targetPackages;

  const RestrictionRuleWithTargets({
    required this.rule,
    required this.targetPackages,
  });
}

class RestrictionRepository {
  final AppDatabase _db;
  final PlatformBridge _bridge;

  RestrictionRepository(this._db, this._bridge);

  Stream<List<RestrictionRuleWithTargets>> watchRules() {
    return _db.select(_db.restrictionRules).watch().asyncMap((rules) async {
      final result = <RestrictionRuleWithTargets>[];
      for (final rule in rules) {
        final targets = await (_db.select(
          _db.restrictionTargets,
        )..where((tbl) => tbl.ruleId.equals(rule.id))).get();
        result.add(
          RestrictionRuleWithTargets(
            rule: rule,
            targetPackages: targets.map((t) => t.packageName).toList(),
          ),
        );
      }
      return result;
    });
  }

  Future<void> saveRule({
    required String id,
    required String name,
    required List<String> packageNames,
    int limitMinutesPerDay = 0,
    int startMinuteOfDay = -1,
    int endMinuteOfDay = -1,
    List<int> daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    bool isEnabled = true,
    bool isTemporaryBlock = false,
    int tempBlockUntilMs = 0,
  }) async {
    await _db.transaction(() async {
      await _db
          .into(_db.restrictionRules)
          .insertOnConflictUpdate(
            RestrictionRulesCompanion.insert(
              id: id,
              name: name,
              limitMinutesPerDay: Value(limitMinutesPerDay),
              startMinuteOfDay: Value(startMinuteOfDay),
              endMinuteOfDay: Value(endMinuteOfDay),
              daysOfWeek: Value(daysOfWeek.join(',')),
              isEnabled: Value(isEnabled),
              isTemporaryBlock: Value(isTemporaryBlock),
              tempBlockUntilMs: Value(tempBlockUntilMs),
              updatedAt: Value(DateTime.now()),
            ),
          );

      // Replace targets
      await (_db.delete(
        _db.restrictionTargets,
      )..where((tbl) => tbl.ruleId.equals(id))).go();
      for (final pkg in packageNames) {
        await _db
            .into(_db.restrictionTargets)
            .insert(
              RestrictionTargetsCompanion.insert(ruleId: id, packageName: pkg),
            );
      }
    });

    await syncActiveRulesToPlatform();
  }

  Future<void> deleteRule(String id) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.restrictionTargets,
      )..where((tbl) => tbl.ruleId.equals(id))).go();
      await (_db.delete(
        _db.restrictionOverrides,
      )..where((tbl) => tbl.ruleId.equals(id))).go();
      await (_db.delete(
        _db.restrictionRules,
      )..where((tbl) => tbl.id.equals(id))).go();
    });
    await syncActiveRulesToPlatform();
  }

  Future<void> toggleRule(String id, bool isEnabled) async {
    await (_db.update(
      _db.restrictionRules,
    )..where((tbl) => tbl.id.equals(id))).write(
      RestrictionRulesCompanion(
        isEnabled: Value(isEnabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await syncActiveRulesToPlatform();
  }

  Future<RestrictionRuleWithTargets?> getRuleForPackage(String packageName) async {
    final targets = await (_db.select(_db.restrictionTargets)
          ..where((tbl) => tbl.packageName.equals(packageName)))
        .get();
    if (targets.isEmpty) return null;
    final ruleId = targets.first.ruleId;
    final rule = await (_db.select(_db.restrictionRules)
          ..where((tbl) => tbl.id.equals(ruleId)))
        .getSingleOrNull();
    if (rule == null) return null;
    return RestrictionRuleWithTargets(
      rule: rule,
      targetPackages: targets.map((t) => t.packageName).toList(),
    );
  }

  Stream<Map<String, int>> watchAppLimitsMap() {
    return watchRules().map((rules) {
      final map = <String, int>{};
      for (final r in rules) {
        if (r.rule.isEnabled && r.rule.limitMinutesPerDay > 0) {
          for (final pkg in r.targetPackages) {
            map[pkg] = r.rule.limitMinutesPerDay;
          }
        }
      }
      return map;
    });
  }

  Future<void> setAppLimit({
    required String packageName,
    required String appName,
    required int limitMinutes,
  }) async {
    final existing = await getRuleForPackage(packageName);
    final ruleId = existing?.rule.id ?? 'timer_$packageName';
    await saveRule(
      id: ruleId,
      name: '$appName Timer',
      packageNames: [packageName],
      limitMinutesPerDay: limitMinutes,
      isEnabled: true,
    );
  }

  Future<void> removeAppLimit(String packageName) async {
    final existing = await getRuleForPackage(packageName);
    if (existing != null) {
      await deleteRule(existing.rule.id);
    }
  }

  Future<void> grantOverride({
    required String packageName,
    required String ruleId,
    required int durationMinutes,
    String? reason,
  }) async {
    final overrideUntil =
        DateTime.now().millisecondsSinceEpoch + (durationMinutes * 60 * 1000);
    await _db
        .into(_db.restrictionOverrides)
        .insert(
          RestrictionOverridesCompanion.insert(
            ruleId: ruleId,
            packageName: packageName,
            overrideUntilMs: overrideUntil,
            durationMinutes: durationMinutes,
            reason: Value(reason),
          ),
        );

    await _bridge.grantOverride(
      packageName: packageName,
      ruleId: ruleId,
      durationMinutes: durationMinutes,
    );
  }

  Stream<List<RestrictionOverride>> watchActiveOverrides() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    return (_db.select(_db.restrictionOverrides)
          ..where((tbl) => tbl.overrideUntilMs.isBiggerThanValue(nowMs))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  Future<void> syncActiveRulesToPlatform() async {
    try {
      final activeRules = await (_db.select(
        _db.restrictionRules,
      )..where((tbl) => tbl.isEnabled.equals(true))).get();

      final jsonPayloadList = <Map<String, dynamic>>[];

      for (final rule in activeRules) {
        final targets = await (_db.select(
          _db.restrictionTargets,
        )..where((tbl) => tbl.ruleId.equals(rule.id))).get();

        final days = rule.daysOfWeek
            .split(',')
            .where((s) => s.isNotEmpty)
            .map((s) => int.tryParse(s.trim()) ?? 1)
            .toList();

        jsonPayloadList.add({
          'ruleId': rule.id,
          'ruleName': rule.name,
          'packages': targets.map((t) => t.packageName).toList(),
          'limitMinutesPerDay': rule.limitMinutesPerDay,
          'startMinuteOfDay': rule.startMinuteOfDay,
          'endMinuteOfDay': rule.endMinuteOfDay,
          'daysOfWeek': days,
          'isTemporaryBlock': rule.isTemporaryBlock,
          'tempBlockUntilMs': rule.tempBlockUntilMs,
        });
      }

      final jsonString = jsonEncode(jsonPayloadList);
      final success = await _bridge.syncRules(jsonString);
      AppLogger.info(
        'Synced ${jsonPayloadList.length} rules to native layer. Success: $success',
      );
    } catch (e, st) {
      AppLogger.error('Error synchronizing rules to native', e, st);
    }
  }
}
