import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymcoach/core/config/app_config.dart';
import 'package:gymcoach/core/config/personal_mode_service.dart';
import 'package:gymcoach/data/local/app_database.dart';
import 'package:gymcoach/data/repositories/gym_models.dart';
import 'package:gymcoach/data/repositories/local/local_core_repositories.dart';
import 'package:gymcoach/data/repositories/local/local_workout_coach_repositories.dart';
import 'package:gymcoach/training/local_program_generator.dart';
import 'package:gymcoach/training/local_training_math.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  OnboardingInput sampleInput({int days = 4, double? bench}) => OnboardingInput(
        displayName: 'Medhat',
        age: 44,
        sex: 0,
        heightCm: 178,
        bodyWeightKg: 90,
        experience: 1,
        yearsTraining: 3,
        primaryGoal: 0,
        trainingDaysPerWeek: days,
        preferredSessionMinutes: 60,
        equipmentSetting: 0,
        baselineBenchKg: bench,
      );

  test('PersonalMode follows AppConfig (cloud or standalone)', () {
    expect(
      DefaultPersonalModeService(AppConfig.current).isEnabled,
      AppConfig.current.personalMode,
    );
    expect(DefaultPersonalModeService(const AppConfig(personalMode: true)).isEnabled, isTrue);
  });

  test('standalone onboarding + program generation works with no network', () async {
    final onboarding = LocalOnboardingRepository(db);
    final programs = LocalProgramRepository(db);

    expect(await onboarding.isOnboardingComplete(), isFalse);

    final input = sampleInput(bench: 80);
    await onboarding.completeSetup(input);
    final program = await programs.generateInitial(input);

    expect(await onboarding.isOnboardingComplete(), isTrue);
    expect(program['endDateUtc'], isNull);
    expect(program['name'], 'GymCoach Program v1');
    expect(program['currentVersionNumber'], 1);
    final days = program['days'] as List;
    expect(days, hasLength(4));
    final firstDay = Map<String, dynamic>.from(days.first as Map);
    expect((firstDay['exercises'] as List), isNotEmpty);
  });

  test('next workout advances by sequence after marking day complete', () async {
    final onboarding = LocalOnboardingRepository(db);
    final programs = LocalProgramRepository(db);
    final workouts = LocalWorkoutSessionRepository(db);
    final input = sampleInput(days: 3);
    await onboarding.completeSetup(input);
    await programs.generateInitial(input);

    final first = await workouts.getNextWorkout();
    expect(first, isNotNull);
    final firstId = first!['programDayId'] as String;
    await workouts.markDayCompleted(firstId);

    final second = await workouts.getNextWorkout();
    expect(second!['programDayId'], isNot(firstId));
  });

  test('progressive overload and e1RM stay local', () {
    const math = LocalTrainingMath();
    expect(math.e1rm(100, 5), closeTo(116.67, 0.1));

    final suggestion = math.suggestNext(
      targetSets: 3,
      minReps: 8,
      maxReps: 12,
      currentLoadKg: 60,
      loadIncrementKg: 2.5,
      lastWorkingSets: const [
        WorkingSetSample(weightKg: 60, reps: 12, rir: 2),
        WorkingSetSample(weightKg: 60, reps: 12, rir: 2),
        WorkingSetSample(weightKg: 60, reps: 12, rir: 1),
      ],
    );
    expect(suggestion.decision, 'PROGRESS_LOAD');
    expect(suggestion.suggestedLoadKg, 62.5);
  });

  test('local coach answers without network and refuses nutrition', () async {
    final onboarding = LocalOnboardingRepository(db);
    final programs = LocalProgramRepository(db);
    final progress = LocalProgressRepository(db);
    final coach = LocalCoachRepository(db, progress);
    await onboarding.completeSetup(sampleInput());
    await programs.generateInitial(sampleInput());

    final nutrition = await coach.ask('What calorie surplus should I eat?');
    expect(nutrition.source, 'TRAINING_ENGINE');
    expect(nutrition.answer.toLowerCase(), contains('nutrition'));

    final progressAsk = await coach.ask('Am I progressing?');
    expect(progressAsk.source, 'TRAINING_ENGINE');
    expect(progressAsk.answer, isNotEmpty);
  });

  test('program generator respects days/week and optional bench baseline', () {
    final gen = LocalProgramGenerator();
    final program = gen.generate(sampleInput(days: 4, bench: 87.5));
    expect(program.days, hasLength(4));
    expect(program.endDateUtc, isNull);
    final bench = program.days
        .expand((d) => d.exercises)
        .where((e) => e.exerciseName.toLowerCase().contains('bench'))
        .toList();
    expect(bench, isNotEmpty);
    expect(bench.first.startingLoadKg, 87.5);
  });

  test('full offline path: setup → program → summary with no Dio errors', () async {
    final onboarding = LocalOnboardingRepository(db);
    final programs = LocalProgramRepository(db);
    final workouts = LocalWorkoutSessionRepository(db);
    final input = sampleInput();
    await onboarding.completeSetup(input);
    await programs.generateInitial(input);

    final next = await workouts.getNextWorkout();
    expect(next!['exercises'], isNotEmpty);

    await db.createSession(WorkoutSessionsCompanion.insert(
      id: 'sess-1',
      name: next['dayName'] as String,
      programDayId: Value(next['programDayId'] as String),
      startedAt: DateTime.utc(2026, 1, 1, 10),
    ));
    await db.createExercise(WorkoutExercisesCompanion.insert(
      id: 'ex-local-1',
      sessionId: 'sess-1',
      exerciseName: 'Bench Press',
      position: 0,
    ));
    await db.saveSetOffline(
      workoutSet: WorkoutSetsCompanion.insert(
        id: 'set-1',
        exerciseId: 'ex-local-1',
        weight: 80,
        reps: 8,
        loggedAt: DateTime.utc(2026, 1, 1, 10, 20),
      ),
      syncOperation: SyncOperationsCompanion.insert(
        id: 'op-1',
        entityType: 'workout_set',
        entityId: 'set-1',
        operation: 'upsert',
        payload: '{}',
        createdAt: DateTime.utc(2026, 1, 1, 10, 20),
      ),
    );
    await db.completeSession(sessionId: 'sess-1', difficulty: 1, painReported: false);

    final summary = await workouts.buildSummary('sess-1');
    expect(summary['workingSetCount'], 1);
    expect(summary['insight'], isNotEmpty);
    final blob = summary.toString().toLowerCase();
    expect(blob.contains('dioexception'), isFalse);
    expect(blob.contains('socketexception'), isFalse);
  });
}
