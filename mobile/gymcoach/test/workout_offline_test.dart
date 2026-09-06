import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymcoach/core/config/app_config.dart';
import 'package:gymcoach/core/config/personal_mode_service.dart';
import 'package:gymcoach/data/local/app_database.dart';
import 'package:gymcoach/features/workout/rest_timer_controller.dart';

void main() {
  test('PersonalMode is enabled by default via AppConfig', () {
    final service = DefaultPersonalModeService(AppConfig.current);
    expect(service.isEnabled, isTrue);
  });

  test('offline set persistence writes set and sync outbox', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.createSession(WorkoutSessionsCompanion.insert(
      id: 's1',
      name: 'Test',
      startedAt: DateTime.utc(2026, 1, 1),
    ));
    await db.createExercise(WorkoutExercisesCompanion.insert(
      id: 'e1',
      sessionId: 's1',
      exerciseName: 'Squat',
      position: 0,
    ));
    await db.saveSetOffline(
      workoutSet: WorkoutSetsCompanion.insert(
        id: 'set1',
        exerciseId: 'e1',
        weight: 100,
        reps: 5,
        rir: const Value(2),
        loggedAt: DateTime.utc(2026, 1, 1, 12),
      ),
      syncOperation: SyncOperationsCompanion.insert(
        id: 'op1',
        entityType: 'workout_set',
        entityId: 'set1',
        operation: 'upsert',
        payload: '{}',
        createdAt: DateTime.utc(2026, 1, 1, 12),
      ),
    );

    final sets = await db.select(db.workoutSets).get();
    final ops = await db.select(db.syncOperations).get();
    expect(sets, hasLength(1));
    expect(sets.first.weight, 100);
    expect(ops, hasLength(1));
  });

  test('active workout survives restore query after simulated restart', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.createSession(WorkoutSessionsCompanion.insert(
      id: 'active-1',
      name: 'Push',
      startedAt: DateTime.utc(2026, 1, 2),
    ));
    await db.createExercise(WorkoutExercisesCompanion.insert(
      id: 'ex-1',
      sessionId: 'active-1',
      exerciseName: 'Bench',
      position: 0,
    ));
    await db.saveSetOffline(
      workoutSet: WorkoutSetsCompanion.insert(
        id: 'set-a',
        exerciseId: 'ex-1',
        weight: 80,
        reps: 8,
        loggedAt: DateTime.utc(2026, 1, 2, 10),
      ),
      syncOperation: SyncOperationsCompanion.insert(
        id: 'op-a',
        entityType: 'workout_set',
        entityId: 'set-a',
        operation: 'upsert',
        payload: '{}',
        createdAt: DateTime.utc(2026, 1, 2, 10),
      ),
    );

    final active = await db.getActiveSession();
    expect(active, isNotNull);
    expect(active!.id, 'active-1');
    final sets = await db.setsForExercise('ex-1');
    expect(sets, hasLength(1));
  });

  test('rest timer starts, pauses, and skips', () async {
    final timer = RestTimerController();
    addTearDown(timer.dispose);
    timer.start(60);
    expect(timer.isRunning, isTrue);
    timer.pause();
    expect(timer.isPaused, isTrue);
    timer.resume();
    expect(timer.isPaused, isFalse);
    timer.addSeconds(30);
    expect(timer.remainingSeconds, greaterThan(60));
    timer.skip();
    expect(timer.remainingSeconds, 0);
  });
}
