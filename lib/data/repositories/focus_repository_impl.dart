import 'package:drift/drift.dart';
import '../../core/time/time_provider.dart';
import '../database/app_database.dart';

class FocusRepository {
  final AppDatabase _db;
  final TimeProvider _timeProvider;

  FocusRepository(this._db, this._timeProvider);

  Stream<List<FocusProfile>> watchProfiles() {
    return _db.select(_db.focusProfiles).watch();
  }

  Future<void> saveProfile({
    required String id,
    required String name,
    required int durationMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int cycles,
  }) async {
    await _db
        .into(_db.focusProfiles)
        .insertOnConflictUpdate(
          FocusProfilesCompanion.insert(
            id: id,
            name: name,
            durationMinutes: Value(durationMinutes),
            shortBreakMinutes: Value(shortBreakMinutes),
            longBreakMinutes: Value(longBreakMinutes),
            cycles: Value(cycles),
          ),
        );
  }

  Stream<FocusSession?> watchActiveSession() {
    return (_db.select(_db.focusSessions)
          ..where((tbl) => tbl.status.isIn(['active', 'paused']))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAtUtcMs)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<String> startSession({
    String? profileId,
    required int durationMinutes,
  }) async {
    // Abandon any previously hanging active sessions
    await (_db.update(
      _db.focusSessions,
    )..where((tbl) => tbl.status.isIn(['active', 'paused']))).write(
      FocusSessionsCompanion(
        status: const Value('abandoned'),
        endedAtUtcMs: Value(_timeProvider.currentUtcTimestampMs()),
      ),
    );

    final id = 'session_${DateTime.now().millisecondsSinceEpoch}';
    await _db
        .into(_db.focusSessions)
        .insert(
          FocusSessionsCompanion.insert(
            id: id,
            profileId: Value(profileId),
            startedAtUtcMs: _timeProvider.currentUtcTimestampMs(),
            targetDurationMinutes: durationMinutes,
            status: 'active',
          ),
        );
    return id;
  }

  Future<void> pauseSession(String id, int remainingSeconds) async {
    await (_db.update(
      _db.focusSessions,
    )..where((tbl) => tbl.id.equals(id))).write(
      FocusSessionsCompanion(
        status: const Value('paused'),
        pausedRemainingSeconds: Value(remainingSeconds),
      ),
    );
  }

  Future<void> resumeSession(String id) async {
    await (_db.update(_db.focusSessions)..where((tbl) => tbl.id.equals(id)))
        .write(const FocusSessionsCompanion(status: Value('active')));
  }

  Future<void> completeSession(String id, int completedMinutes) async {
    await (_db.update(
      _db.focusSessions,
    )..where((tbl) => tbl.id.equals(id))).write(
      FocusSessionsCompanion(
        status: const Value('completed'),
        completedMinutes: Value(completedMinutes),
        endedAtUtcMs: Value(_timeProvider.currentUtcTimestampMs()),
      ),
    );
  }

  Future<void> abandonSession(String id, int completedMinutes) async {
    await (_db.update(
      _db.focusSessions,
    )..where((tbl) => tbl.id.equals(id))).write(
      FocusSessionsCompanion(
        status: const Value('abandoned'),
        completedMinutes: Value(completedMinutes),
        endedAtUtcMs: Value(_timeProvider.currentUtcTimestampMs()),
      ),
    );
  }

  Stream<List<FocusSession>> watchSessionHistory() {
    return (_db.select(_db.focusSessions)
          ..where((tbl) => tbl.status.isIn(['completed', 'abandoned']))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAtUtcMs)])
          ..limit(50))
        .watch();
  }
}
