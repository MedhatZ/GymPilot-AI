import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../training/local_program_generator.dart';
import '../../../training/local_training_math.dart';
import '../../local/app_database.dart';
import '../gym_models.dart';
import '../repository_contracts.dart';

class LocalOnboardingRepository implements OnboardingRepository {
  LocalOnboardingRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();
  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Future<bool> isOnboardingComplete() async {
    final p = await _db.getProfile();
    return p?.onboardingCompleted == true;
  }

  @override
  Future<Map<String, dynamic>?> getProfile() async {
    final p = await _db.getProfile();
    if (p == null) return null;
    return {
      'displayName': p.displayName,
      'age': p.age,
      'sex': p.sex,
      'heightCm': p.heightCm,
      'bodyWeightKg': p.bodyWeightKg,
      'experience': p.experience,
      'yearsTraining': p.yearsTraining,
      'primaryGoal': p.primaryGoal,
      'secondaryGoal': p.secondaryGoal,
      'trainingDaysPerWeek': p.trainingDaysPerWeek,
      'preferredSessionMinutes': p.preferredSessionMinutes,
      'equipmentSetting': p.equipmentSetting,
      'limitations': p.injuryNotes == null || p.injuryNotes!.isEmpty
          ? <Map>[]
          : [
              {'injuryDescription': p.injuryNotes}
            ],
      'baselineLifts': <Map>[],
      'onboardingCompleted': p.onboardingCompleted,
    };
  }

  @override
  Future<void> completeSetup(OnboardingInput input) async {
    final existing = await _db.getProfile();
    final id = existing?.id ?? _uuid.v4();
    await _db.upsertProfile(AthleteProfilesCompanion.insert(
      id: id,
      displayName: input.displayName,
      age: input.age,
      sex: Value(input.sex),
      heightCm: input.heightCm,
      bodyWeightKg: input.bodyWeightKg,
      experience: Value(input.experience),
      yearsTraining: Value(input.yearsTraining),
      primaryGoal: Value(input.primaryGoal),
      secondaryGoal: Value(input.secondaryGoal),
      trainingDaysPerWeek: Value(input.trainingDaysPerWeek),
      preferredSessionMinutes: Value(input.preferredSessionMinutes),
      equipmentSetting: Value(input.equipmentSetting),
      injuryNotes: Value(input.injuryNotes),
      baselineBenchKg: Value(input.baselineBenchKg),
      onboardingCompleted: const Value(true),
      lastCompletedProgramDayId: Value(existing?.lastCompletedProgramDayId),
      updatedAt: DateTime.now().toUtc(),
    ));
  }

  @override
  Future<void> updateProfile(OnboardingInput input) => completeSetup(input);
}

class LocalProgramRepository implements ProgramRepository {
  LocalProgramRepository(this._db, {LocalProgramGenerator? generator})
      : _generator = generator ?? LocalProgramGenerator();
  final AppDatabase _db;
  final LocalProgramGenerator _generator;

  @override
  Future<Map<String, dynamic>?> getActiveProgram() async {
    final program = await _db.getActiveProgram();
    if (program == null) return null;
    final days = await _db.daysForProgram(program.id);
    final dayMaps = <Map<String, dynamic>>[];
    for (final d in days) {
      final exercises = await _db.exercisesForProgramDay(d.id);
      dayMaps.add({
        'id': d.id,
        'dayIndex': d.dayIndex,
        'name': d.name,
        'split': d.split,
        'exercises': [
          for (final e in exercises)
            {
              'id': e.id,
              'exerciseId': e.catalogExerciseId,
              'exerciseName': e.exerciseName,
              'order': e.position,
              'sets': e.sets,
              'minReps': e.minReps,
              'maxReps': e.maxReps,
              'startingLoadKg': e.startingLoadKg,
              'restSeconds': e.restSeconds,
              'targetRir': e.targetRir,
              'loadIncrementKg': e.loadIncrementKg,
            }
        ],
      });
    }
    return {
      'id': program.id,
      'name': program.name,
      'status': program.status,
      'startDateUtc': program.startDateUtc.toIso8601String(),
      'endDateUtc': program.endDateUtc,
      'currentVersionNumber': program.currentVersionNumber,
      'reason': program.reason,
      'days': dayMaps,
    };
  }

  @override
  Future<Map<String, dynamic>> generateInitial(OnboardingInput input) async {
    // Replace any active programs (no calendar end — mark replaced only when generating new).
    final existing = await _db.select(_db.programs).get();
    for (final p in existing.where((p) => p.status == 'Active')) {
      await (_db.update(_db.programs)..where((x) => x.id.equals(p.id))).write(
        ProgramsCompanion(
          status: const Value('Replaced'),
          endDateUtc: Value(DateTime.now().toUtc()),
        ),
      );
    }

    final generated = _generator.generate(input);
    await _db.into(_db.programs).insert(ProgramsCompanion.insert(
          id: generated.id,
          name: generated.name,
          status: Value(generated.status),
          startDateUtc: generated.startDateUtc,
          endDateUtc: const Value(null),
          currentVersionNumber: Value(generated.currentVersionNumber),
          reason: Value(generated.reason),
        ));

    for (final day in generated.days) {
      await _db.into(_db.programDays).insert(ProgramDaysCompanion.insert(
            id: day.id,
            programId: generated.id,
            dayIndex: day.dayIndex,
            name: day.name,
            split: day.split,
          ));
      for (final ex in day.exercises) {
        await _db.into(_db.programExercises).insert(ProgramExercisesCompanion.insert(
              id: ex.id,
              programDayId: day.id,
              catalogExerciseId: ex.catalogExerciseId,
              exerciseName: ex.exerciseName,
              position: ex.position,
              sets: ex.sets,
              minReps: ex.minReps,
              maxReps: ex.maxReps,
              startingLoadKg: Value(ex.startingLoadKg),
              restSeconds: Value(ex.restSeconds),
              targetRir: Value(ex.targetRir),
              isCompound: Value(ex.isCompound),
              loadIncrementKg: Value(ex.loadIncrementKg),
            ));
      }
    }

    return (await getActiveProgram())!;
  }
}

class LocalHomeRepository implements HomeRepository {
  LocalHomeRepository(this._db, this._programs, this._workouts);
  final AppDatabase _db;
  final ProgramRepository _programs;
  final WorkoutSessionRepository _workouts;

  @override
  Future<Map<String, dynamic>> getHome() async {
    final program = await _programs.getActiveProgram();
    final next = await _workouts.getNextWorkout();
    final profile = await _db.getProfile();
    final active = await _db.getActiveSession();
    final completed = await _db.completedSessions(limit: 1);
    final last = completed.isEmpty ? null : completed.first;

    String insight = next?['recommendation']?.toString() ??
        'Log workouts to unlock progressive insights.';
    if (program != null) {
      insight = 'Program active with no end date. Continue while progression remains positive.';
    }

    return {
      'activeProgram': program,
      'todaysWorkout': next == null
          ? null
          : {
              'id': next['programDayId'],
              'name': next['dayName'],
              'exercises': next['exercises'],
            },
      'nextWorkout': next,
      'recovery': {
        'readinessScore': 70,
        'label': 'moderate',
        'summary': 'Training-only readiness estimate (on-device).',
      },
      'insight': insight,
      'nextAction': next == null ? 'Complete setup and generate your program.' : 'Start ${next['dayName']} when ready.',
      'lastWorkoutName': last?.name,
      'lastWorkoutAtUtc': last?.completedAt?.toIso8601String(),
      'recentPr': null,
      'hasActiveSession': active != null,
      'displayName': profile?.displayName,
    };
  }
}

class LocalProgressRepository implements ProgressRepository {
  LocalProgressRepository(this._db, {LocalTrainingMath? math})
      : _math = math ?? const LocalTrainingMath();
  final AppDatabase _db;
  final LocalTrainingMath _math;

  @override
  Future<Map<String, dynamic>> getOverview() async {
    final sessions = await _db.completedSessions(limit: 100);
    final byName = <String, _LiftAgg>{};

    for (final session in sessions) {
      final exercises = await _db.exercisesForSession(session.id);
      for (final ex in exercises) {
        final sets = await _db.setsForExercise(ex.id);
        final working = sets.where((s) => !s.isWarmup).toList();
        if (working.isEmpty) continue;
        final agg = byName.putIfAbsent(ex.exerciseName, () => _LiftAgg(ex.exerciseName));
        agg.sessionCount++;
        for (final s in working) {
          final e1 = _math.e1rm(s.weight, s.reps);
          agg.bestWeight = agg.bestWeight == null ? s.weight : (s.weight > agg.bestWeight! ? s.weight : agg.bestWeight);
          agg.bestE1rm = agg.bestE1rm == null ? e1 : (e1 > agg.bestE1rm! ? e1 : agg.bestE1rm);
          agg.e1Points.add(e1);
        }
      }
    }

    final exercises = byName.values.map((a) {
      final points = a.e1Points.length > 12 ? a.e1Points.sublist(a.e1Points.length - 12) : a.e1Points;
      return {
        'exerciseId': a.name,
        'name': a.name,
        'bestWeight': a.bestWeight,
        'bestE1rm': a.bestE1rm == null ? null : double.parse(a.bestE1rm!.toStringAsFixed(1)),
        'sessionCount': a.sessionCount,
        'recentE1rmPoints': points.map((p) => double.parse(p.toStringAsFixed(1))).toList(),
      };
    }).toList();

    final prs = await _db.select(_db.localPersonalRecords).get();
    return {
      'exercises': exercises,
      'recentPrs': [
        for (final p in prs.take(20))
          {
            'exerciseId': p.catalogExerciseId,
            'exerciseName': p.exerciseName,
            'type': p.recordType,
            'value': p.value,
            'achievedAtUtc': p.achievedAtUtc.toIso8601String(),
          }
      ],
      'recovery': {
        'readinessScore': 70,
        'label': 'moderate',
      },
    };
  }
}

class _LiftAgg {
  _LiftAgg(this.name);
  final String name;
  int sessionCount = 0;
  double? bestWeight;
  double? bestE1rm;
  final List<double> e1Points = [];
}
