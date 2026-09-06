import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/network/api_client.dart';
import '../../data/local/app_database.dart';
import '../../data/local/database_provider.dart';
import '../../data/sync/sync_service.dart';
import 'rest_timer_controller.dart';

class ActiveWorkoutState {
  const ActiveWorkoutState({
    this.session,
    this.exercises = const [],
    this.currentExerciseIndex = 0,
    this.loading = true,
    this.error,
  });

  final WorkoutSession? session;
  final List<WorkoutExercise> exercises;
  final int currentExerciseIndex;
  final bool loading;
  final String? error;

  WorkoutExercise? get currentExercise =>
      exercises.isEmpty ? null : exercises[currentExerciseIndex.clamp(0, exercises.length - 1)];

  ActiveWorkoutState copyWith({
    WorkoutSession? session,
    List<WorkoutExercise>? exercises,
    int? currentExerciseIndex,
    bool? loading,
    String? error,
  }) =>
      ActiveWorkoutState(
        session: session ?? this.session,
        exercises: exercises ?? this.exercises,
        currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
        loading: loading ?? this.loading,
        error: error,
      );
}

class ActiveWorkoutController extends StateNotifier<ActiveWorkoutState> {
  ActiveWorkoutController(this._db, this._api, this._sync, this._timer)
      : super(const ActiveWorkoutState()) {
    restore();
  }

  final AppDatabase _db;
  final ApiClient _api;
  final SyncService _sync;
  final RestTimerController _timer;
  final _uuid = const Uuid();

  Future<void> restore() async {
    state = state.copyWith(loading: true);
    final active = await _db.getActiveSession();
    if (active == null) {
      state = const ActiveWorkoutState(loading: false);
      return;
    }
    final exercises = await _db.exercisesForSession(active.id);
    state = ActiveWorkoutState(session: active, exercises: exercises, loading: false);
  }

  Future<void> startFromRecommended({Map<String, dynamic>? readiness}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      Map<String, dynamic>? day;
      Map<String, dynamic>? program;
      try {
        final home = await _api.dio.get('/api/home');
        day = home.data['todaysWorkout'] as Map<String, dynamic>?;
        program = home.data['activeProgram'] as Map<String, dynamic>?;
      } catch (_) {}

      final sessionId = _uuid.v4();
      final dayName = day?['name']?.toString() ?? 'Workout';
      final programDayId = day?['id']?.toString();

      await _db.createSession(WorkoutSessionsCompanion.insert(
        id: sessionId,
        name: dayName,
        programDayId: Value(programDayId),
        programName: Value(program?['name']?.toString()),
        startedAt: DateTime.now().toUtc(),
        readinessJson: Value(readiness == null ? null : jsonEncode(readiness)),
      ));

      try {
        await _api.dio.post('/api/workouts/start', data: {
          'programDayId': programDayId,
          'clientId': sessionId,
          'startedAtUtc': DateTime.now().toUtc().toIso8601String(),
        });
      } catch (_) {}

      final exerciseMaps = (day?['exercises'] as List?) ?? [];
      for (var i = 0; i < exerciseMaps.length; i++) {
        final e = Map<String, dynamic>.from(exerciseMaps[i] as Map);
        final localId = _uuid.v4();
        var suggested = (e['startingLoadKg'] as num?)?.toDouble();
        String? previousJson;
        try {
          final sug = await _api.dio.get('/api/workouts/suggest/${e['exerciseId']}');
          suggested = (sug.data['suggestedLoadKg'] as num?)?.toDouble() ?? suggested;
          previousJson = jsonEncode({
            'reason': sug.data['reason'],
            'suggestedReps': sug.data['suggestedReps'],
            'decision': sug.data['decision'],
          });
        } catch (_) {}

        await _db.createExercise(WorkoutExercisesCompanion.insert(
          id: localId,
          sessionId: sessionId,
          serverExerciseId: Value(e['exerciseId']?.toString()),
          exerciseName: e['exerciseName']?.toString() ?? 'Exercise',
          position: i,
          targetSets: Value((e['sets'] as num?)?.toInt() ?? 3),
          minReps: Value((e['minReps'] as num?)?.toInt() ?? 6),
          maxReps: Value((e['maxReps'] as num?)?.toInt() ?? 8),
          suggestedWeight: Value(suggested),
          restSeconds: Value((e['restSeconds'] as num?)?.toInt() ?? 90),
          loadIncrement: const Value(2.5),
          previousPerformanceJson: Value(previousJson),
        ));
      }

      if (exerciseMaps.isEmpty) {
        // Offline fallback: one placeholder exercise
        await _db.createExercise(WorkoutExercisesCompanion.insert(
          id: _uuid.v4(),
          sessionId: sessionId,
          exerciseName: 'Main lift',
          position: 0,
        ));
      }

      final session = await (_db.select(_db.workoutSessions)..where((s) => s.id.equals(sessionId))).getSingle();
      final exercises = await _db.exercisesForSession(sessionId);
      state = ActiveWorkoutState(session: session, exercises: exercises, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void selectExercise(int index) {
    state = state.copyWith(currentExerciseIndex: index);
  }

  Future<void> logSet({
    required double weight,
    required int reps,
    int? rir,
    required bool warmup,
  }) async {
    final ex = state.currentExercise;
    final session = state.session;
    if (ex == null || session == null) return;

    final existing = await _db.setsForExercise(ex.id);
    final setNumber = existing.length + 1;
    final setId = _uuid.v4();
    await _db.saveSetOffline(
      workoutSet: WorkoutSetsCompanion.insert(
        id: setId,
        exerciseId: ex.id,
        setNumber: Value(setNumber),
        weight: weight,
        reps: reps,
        rir: Value(rir),
        isWarmup: Value(warmup),
        loggedAt: DateTime.now().toUtc(),
      ),
      syncOperation: SyncOperationsCompanion.insert(
        id: _uuid.v4(),
        entityType: 'workout_set',
        entityId: setId,
        operation: 'upsert',
        payload: jsonEncode({'sessionId': session.id, 'setId': setId}),
        createdAt: DateTime.now().toUtc(),
      ),
    );

    try {
      await _api.dio.post('/api/workouts/${session.id}/sets', data: {
        'workoutExerciseClientId': ex.id,
        'setClientId': setId,
        'exerciseId': ex.serverExerciseId,
        'order': ex.position,
        'setNumber': setNumber,
        'weightKg': weight,
        'reps': reps,
        'rir': rir,
        'setType': warmup ? 0 : 1,
        'note': null,
        'completedAtUtc': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {}

    if (!warmup) {
      _timer.start(ex.restSeconds);
    }
    // refresh exercise list reference
    state = state.copyWith(exercises: await _db.exercisesForSession(session.id));
  }

  Future<void> updateSet(String setId, {double? weight, int? reps, int? rir}) async {
    await _db.updateSet(WorkoutSetsCompanion(
      id: Value(setId),
      weight: weight != null ? Value(weight) : const Value.absent(),
      reps: reps != null ? Value(reps) : const Value.absent(),
      rir: rir != null ? Value(rir) : const Value.absent(),
    ));
  }

  Future<void> deleteSet(String setId) => _db.deleteSet(setId);

  Future<void> substituteExercise(String newName, {String? serverExerciseId}) async {
    final ex = state.currentExercise;
    final session = state.session;
    if (ex == null || session == null) return;
    await (_db.update(_db.workoutExercises)..where((e) => e.id.equals(ex.id))).write(
      WorkoutExercisesCompanion(
        exerciseName: Value(newName),
        serverExerciseId: Value(serverExerciseId),
        substitutedFromName: Value(ex.exerciseName),
      ),
    );
    state = state.copyWith(exercises: await _db.exercisesForSession(session.id));
  }

  Future<String?> finish({required int difficulty, required bool pain}) async {
    final session = state.session;
    if (session == null) return null;
    await _db.completeSession(sessionId: session.id, difficulty: difficulty, painReported: pain);
    try {
      await _api.dio.post('/api/workouts/complete', data: {
        'sessionClientId': session.id,
        'difficulty': difficulty,
        'painReported': pain,
        'painLocation': null,
        'painExerciseId': null,
        'notes': null,
        'completedAtUtc': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {}
    try {
      await _sync.flush();
    } catch (_) {}
    _timer.skip();
    final id = session.id;
    state = const ActiveWorkoutState(loading: false);
    return id;
  }
}

final activeWorkoutProvider =
    StateNotifierProvider<ActiveWorkoutController, ActiveWorkoutState>((ref) {
  return ActiveWorkoutController(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider),
    ref.watch(syncServiceProvider),
    ref.watch(restTimerProvider),
  );
});
