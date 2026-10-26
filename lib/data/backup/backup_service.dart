import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/constants/app_constants.dart';
import '../../core/logging/app_logger.dart';
import '../database/app_database.dart';

class BackupService {
  final AppDatabase _db;

  BackupService(this._db);

  Future<String> exportBackupJson() async {
    final rules = await _db.select(_db.restrictionRules).get();
    final targets = await _db.select(_db.restrictionTargets).get();
    final habits = await _db.select(_db.habits).get();
    final habitEntries = await _db.select(_db.habitEntries).get();
    final routines = await _db.select(_db.routines).get();
    final routineSteps = await _db.select(_db.routineSteps).get();
    final settings = await _db.select(_db.userSettings).get();

    final payload = {
      'version': AppConstants.schemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'rules': rules
          .map(
            (r) => {
              'id': r.id,
              'name': r.name,
              'limitMinutesPerDay': r.limitMinutesPerDay,
              'startMinuteOfDay': r.startMinuteOfDay,
              'endMinuteOfDay': r.endMinuteOfDay,
              'daysOfWeek': r.daysOfWeek,
              'isEnabled': r.isEnabled,
            },
          )
          .toList(),
      'targets': targets
          .map((t) => {'ruleId': t.ruleId, 'packageName': t.packageName})
          .toList(),
      'habits': habits
          .map(
            (h) => {
              'id': h.id,
              'title': h.title,
              'category': h.category,
              'targetDaysPerWeek': h.targetDaysPerWeek,
            },
          )
          .toList(),
      'habitEntries': habitEntries
          .map(
            (e) => {
              'habitId': e.habitId,
              'date': e.date,
              'completed': e.completed,
            },
          )
          .toList(),
      'routines': routines
          .map(
            (ro) => {
              'id': ro.id,
              'name': ro.name,
              'type': ro.type,
              'startMinuteOfDay': ro.startMinuteOfDay,
              'daysOfWeek': ro.daysOfWeek,
              'isEnabled': ro.isEnabled,
            },
          )
          .toList(),
      'routineSteps': routineSteps
          .map(
            (rs) => {
              'routineId': rs.routineId,
              'title': rs.title,
              'orderIndex': rs.orderIndex,
              'isCompleted': rs.isCompleted,
            },
          )
          .toList(),
      'settings': settings
          .map((s) => {'key': s.key, 'value': s.value})
          .toList(),
    };

    final jsonStr = jsonEncode(payload);
    final hash = sha256.convert(utf8.encode(jsonStr)).toString();

    final completeBackup = {'checksum': hash, 'data': payload};

    return jsonEncode(completeBackup);
  }

  Future<bool> restoreBackupJson(String backupJsonStr) async {
    try {
      final map = jsonDecode(backupJsonStr) as Map<String, dynamic>;
      final checksum = map['checksum'] as String?;
      final payload = map['data'] as Map<String, dynamic>?;

      if (payload == null || checksum == null) {
        throw const FormatException(
          'Invalid backup structure: missing data or checksum',
        );
      }

      // Verify checksum
      final recomputed = sha256
          .convert(utf8.encode(jsonEncode(payload)))
          .toString();
      if (recomputed != checksum) {
        throw const FormatException(
          'Checksum mismatch. Backup file may be corrupted.',
        );
      }

      // Restore inside transaction
      await _db.transaction(() async {
        // 1. Restore settings
        final settingsList = payload['settings'] as List<dynamic>? ?? [];
        for (final s in settingsList) {
          final m = s as Map<String, dynamic>;
          await _db
              .into(_db.userSettings)
              .insertOnConflictUpdate(
                UserSettingsCompanion.insert(
                  key: m['key'] as String,
                  value: m['value'] as String,
                ),
              );
        }

        // 2. Restore restriction rules
        final rulesList = payload['rules'] as List<dynamic>? ?? [];
        for (final r in rulesList) {
          final m = r as Map<String, dynamic>;
          await _db
              .into(_db.restrictionRules)
              .insertOnConflictUpdate(
                RestrictionRulesCompanion.insert(
                  id: m['id'] as String,
                  name: m['name'] as String,
                  limitMinutesPerDay: drift.Value(
                    (m['limitMinutesPerDay'] as num?)?.toInt() ?? 0,
                  ),
                  startMinuteOfDay: drift.Value(
                    (m['startMinuteOfDay'] as num?)?.toInt() ?? -1,
                  ),
                  endMinuteOfDay: drift.Value(
                    (m['endMinuteOfDay'] as num?)?.toInt() ?? -1,
                  ),
                  daysOfWeek: drift.Value(
                    m['daysOfWeek'] as String? ?? '1,2,3,4,5,6,7',
                  ),
                  isEnabled: drift.Value(m['isEnabled'] as bool? ?? true),
                ),
              );
        }

        // 3. Restore restriction targets
        final targetsList = payload['targets'] as List<dynamic>? ?? [];
        for (final t in targetsList) {
          final m = t as Map<String, dynamic>;
          await _db
              .into(_db.restrictionTargets)
              .insertOnConflictUpdate(
                RestrictionTargetsCompanion.insert(
                  ruleId: m['ruleId'] as String,
                  packageName: m['packageName'] as String,
                ),
              );
        }

        // 4. Restore routines
        final routinesList = payload['routines'] as List<dynamic>? ?? [];
        for (final ro in routinesList) {
          final m = ro as Map<String, dynamic>;
          await _db
              .into(_db.routines)
              .insertOnConflictUpdate(
                RoutinesCompanion.insert(
                  id: m['id'] as String,
                  name: m['name'] as String,
                  type: m['type'] as String? ?? 'custom',
                  startMinuteOfDay:
                      (m['startMinuteOfDay'] as num?)?.toInt() ?? 0,
                  daysOfWeek: drift.Value(
                    m['daysOfWeek'] as String? ?? '1,2,3,4,5,6,7',
                  ),
                  isEnabled: drift.Value(m['isEnabled'] as bool? ?? true),
                ),
              );
        }

        // 5. Restore routine steps
        final routineStepsList =
            payload['routineSteps'] as List<dynamic>? ?? [];
        if (routineStepsList.isNotEmpty) {
          final routineIds = routineStepsList
              .map((rs) => (rs as Map<String, dynamic>)['routineId'] as String)
              .toSet();
          for (final rId in routineIds) {
            await (_db.delete(_db.routineSteps)
                  ..where((tbl) => tbl.routineId.equals(rId)))
                .go();
          }
          for (final rs in routineStepsList) {
            final m = rs as Map<String, dynamic>;
            await _db
                .into(_db.routineSteps)
                .insert(
                  RoutineStepsCompanion.insert(
                    routineId: m['routineId'] as String,
                    title: m['title'] as String,
                    orderIndex: drift.Value(
                      (m['orderIndex'] as num?)?.toInt() ?? 0,
                    ),
                    isCompleted: drift.Value(
                      m['isCompleted'] as bool? ?? false,
                    ),
                  ),
                );
          }
        }

        // 6. Restore habits
        final habitsList = payload['habits'] as List<dynamic>? ?? [];
        for (final h in habitsList) {
          final m = h as Map<String, dynamic>;
          await _db
              .into(_db.habits)
              .insertOnConflictUpdate(
                HabitsCompanion.insert(
                  id: m['id'] as String,
                  title: m['title'] as String,
                  category: drift.Value(m['category'] as String? ?? 'General'),
                  targetDaysPerWeek: drift.Value(
                    (m['targetDaysPerWeek'] as num?)?.toInt() ?? 7,
                  ),
                ),
              );
        }

        // 7. Restore habit entries
        final habitEntriesList =
            payload['habitEntries'] as List<dynamic>? ?? [];
        for (final e in habitEntriesList) {
          final m = e as Map<String, dynamic>;
          await _db
              .into(_db.habitEntries)
              .insertOnConflictUpdate(
                HabitEntriesCompanion.insert(
                  habitId: m['habitId'] as String,
                  date: m['date'] as String,
                  completed: drift.Value(m['completed'] as bool? ?? true),
                ),
              );
        }
      });

      return true;
    } catch (e, st) {
      AppLogger.error('Failed to restore backup', e, st);
      return false;
    }
  }
}
