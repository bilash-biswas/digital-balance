import 'package:drift/drift.dart';
import '../database/app_database.dart';

class RoutineWithSteps {
  final Routine routine;
  final List<RoutineStep> steps;

  const RoutineWithSteps({required this.routine, required this.steps});
}

class RoutineRepository {
  final AppDatabase _db;

  RoutineRepository(this._db);

  Stream<List<RoutineWithSteps>> watchRoutines() {
    return _db.select(_db.routines).watch().asyncMap((routines) async {
      final result = <RoutineWithSteps>[];
      for (final r in routines) {
        final steps =
            await (_db.select(_db.routineSteps)
                  ..where((tbl) => tbl.routineId.equals(r.id))
                  ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]))
                .get();
        result.add(RoutineWithSteps(routine: r, steps: steps));
      }
      return result;
    });
  }

  Future<void> saveRoutine({
    required String id,
    required String name,
    required String type,
    required int startMinuteOfDay,
    List<int> daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    bool isEnabled = true,
    List<String> stepTitles = const [],
  }) async {
    await _db.transaction(() async {
      await _db
          .into(_db.routines)
          .insertOnConflictUpdate(
            RoutinesCompanion.insert(
              id: id,
              name: name,
              type: type,
              startMinuteOfDay: startMinuteOfDay,
              daysOfWeek: Value(daysOfWeek.join(',')),
              isEnabled: Value(isEnabled),
            ),
          );

      if (stepTitles.isNotEmpty) {
        await (_db.delete(
          _db.routineSteps,
        )..where((tbl) => tbl.routineId.equals(id))).go();
        for (var i = 0; i < stepTitles.length; i++) {
          await _db
              .into(_db.routineSteps)
              .insert(
                RoutineStepsCompanion.insert(
                  routineId: id,
                  title: stepTitles[i],
                  orderIndex: Value(i),
                  isCompleted: const Value(false),
                ),
              );
        }
      }
    });
  }

  Future<void> toggleRoutine(String id, bool isEnabled) async {
    await (_db.update(_db.routines)..where((tbl) => tbl.id.equals(id))).write(
      RoutinesCompanion(isEnabled: Value(isEnabled)),
    );
  }

  Future<void> toggleStep(int stepId, bool isCompleted) async {
    await (_db.update(_db.routineSteps)..where((tbl) => tbl.id.equals(stepId)))
        .write(RoutineStepsCompanion(isCompleted: Value(isCompleted)));
  }

  Future<void> deleteRoutine(String id) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.routineSteps,
      )..where((tbl) => tbl.routineId.equals(id))).go();
      await (_db.delete(_db.routines)..where((tbl) => tbl.id.equals(id))).go();
    });
  }
}
