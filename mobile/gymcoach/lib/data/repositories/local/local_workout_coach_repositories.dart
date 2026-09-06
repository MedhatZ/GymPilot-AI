import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../training/local_training_math.dart';
import '../../local/app_database.dart';
import '../gym_models.dart';
import '../repository_contracts.dart';

class LocalWorkoutSessionRepository implements WorkoutSessionRepository {
  LocalWorkoutSessionRepository(this._db, {LocalTrainingMath? math})
      : _math = math ?? const LocalTrainingMath();
  final AppDatabase _db;
  final LocalTrainingMath _math;
  final _uuid = const Uuid();

  @override
  Future<Map<String, dynamic>?> getNextWorkout() async {
    final program = await _db.getActiveProgram();
    if (program == null) return null;
    final days = await _db.daysForProgram(program.id);
    if (days.isEmpty) return null;

    final profile = await _db.getProfile();
    final lastId = profile?.lastCompletedProgramDayId;
    var index = 0;
    if (lastId != null) {
      final lastIndex = days.indexWhere((d) => d.id == lastId);
      if (lastIndex >= 0) index = (lastIndex + 1) % days.length;
    }
    final day = days[index];
    final exercises = await _db.exercisesForProgramDay(day.id);

    return {
      'programDayId': day.id,
      'dayName': day.name,
      'dayIndex': day.dayIndex,
      'exerciseCount': exercises.length,
      'estimatedMinutes': profile?.preferredSessionMinutes ?? 60,
      'recommendation': 'Next in sequence: ${day.name}',
      'programName': program.name,
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
    };
  }

  @override
  Future<Map<String, dynamic>?> suggestLoad({
    required String catalogExerciseId,
    required String exerciseName,
    required int targetSets,
    required int minReps,
    required int maxReps,
    required double loadIncrementKg,
    double? startingLoadKg,
  }) async {
    final history = await _recentWorkingSetsForExercise(exerciseName, catalogExerciseId, targetSets);
    final current = history.isNotEmpty ? history.first.weightKg : (startingLoadKg ?? 0);
    final suggestion = _math.suggestNext(
      targetSets: targetSets,
      minReps: minReps,
      maxReps: maxReps,
      currentLoadKg: current,
      loadIncrementKg: loadIncrementKg,
      lastWorkingSets: history.reversed.toList(),
    );
    return {
      'suggestedLoadKg': suggestion.suggestedLoadKg,
      'suggestedReps': suggestion.suggestedReps,
      'reason': suggestion.reason,
      'decision': suggestion.decision,
      'confidence': suggestion.confidence,
    };
  }

  Future<List<WorkingSetSample>> _recentWorkingSetsForExercise(
    String exerciseName,
    String catalogExerciseId,
    int take,
  ) async {
    final sessions = await _db.completedSessions(limit: 20);
    final samples = <WorkingSetSample>[];
    for (final session in sessions) {
      final exercises = await _db.exercisesForSession(session.id);
      for (final ex in exercises) {
        final match = ex.exerciseName == exerciseName ||
            ex.serverExerciseId == catalogExerciseId;
        if (!match) continue;
        final sets = await _db.setsForExercise(ex.id);
        for (final s in sets.where((s) => !s.isWarmup)) {
          samples.add(WorkingSetSample(
            weightKg: s.weight,
            reps: s.reps,
            rir: s.rir?.toDouble(),
          ));
        }
      }
      if (samples.length >= take) break;
    }
    return samples.take(take).toList();
  }

  @override
  Future<void> markDayCompleted(String programDayId) async {
    final profile = await _db.getProfile();
    if (profile == null) return;
    await _db.upsertProfile(AthleteProfilesCompanion(
      id: Value(profile.id),
      displayName: Value(profile.displayName),
      age: Value(profile.age),
      sex: Value(profile.sex),
      heightCm: Value(profile.heightCm),
      bodyWeightKg: Value(profile.bodyWeightKg),
      experience: Value(profile.experience),
      yearsTraining: Value(profile.yearsTraining),
      primaryGoal: Value(profile.primaryGoal),
      secondaryGoal: Value(profile.secondaryGoal),
      trainingDaysPerWeek: Value(profile.trainingDaysPerWeek),
      preferredSessionMinutes: Value(profile.preferredSessionMinutes),
      equipmentSetting: Value(profile.equipmentSetting),
      injuryNotes: Value(profile.injuryNotes),
      baselineBenchKg: Value(profile.baselineBenchKg),
      onboardingCompleted: Value(profile.onboardingCompleted),
      lastCompletedProgramDayId: Value(programDayId),
      updatedAt: Value(DateTime.now().toUtc()),
    ));
  }

  @override
  Future<Map<String, dynamic>> buildSummary(String sessionClientId) async {
    final session = await (_db.select(_db.workoutSessions)
          ..where((s) => s.id.equals(sessionClientId)))
        .getSingleOrNull();
    if (session == null) {
      return {
        'durationLabel': '—',
        'workingSetCount': 0,
        'exerciseCount': 0,
        'totalWorkingVolume': 0,
        'personalRecords': <String>[],
        'comparisons': <Map>[],
        'insight': 'Session not found.',
      };
    }

    final exercises = await _db.exercisesForSession(session.id);
    var working = 0;
    var volume = 0.0;
    final newPrs = <String>[];

    for (final ex in exercises) {
      final sets = await _db.setsForExercise(ex.id);
      final workingSets = sets.where((s) => !s.isWarmup).toList();
      for (final s in workingSets) {
        working++;
        volume += s.weight * s.reps;
        final e1 = _math.e1rm(s.weight, s.reps);
        final existing = await (_db.select(_db.localPersonalRecords)
              ..where((p) => p.exerciseName.equals(ex.exerciseName) & p.recordType.equals('Estimated1Rm')))
            .get();
        final best = existing.isEmpty ? 0.0 : existing.map((p) => p.value).reduce((a, b) => a > b ? a : b);
        if (e1 > best + 0.5) {
          await _db.into(_db.localPersonalRecords).insert(LocalPersonalRecordsCompanion.insert(
                id: _uuid.v4(),
                exerciseName: ex.exerciseName,
                catalogExerciseId: Value(ex.serverExerciseId),
                recordType: 'Estimated1Rm',
                value: e1,
                achievedAtUtc: s.loggedAt,
              ));
          newPrs.add('${ex.exerciseName} e1RM ${e1.toStringAsFixed(1)}');
        }
        final weightPrs = await (_db.select(_db.localPersonalRecords)
              ..where((p) => p.exerciseName.equals(ex.exerciseName) & p.recordType.equals('HeaviestWeight')))
            .get();
        final bestW = weightPrs.isEmpty ? 0.0 : weightPrs.map((p) => p.value).reduce((a, b) => a > b ? a : b);
        if (s.weight > bestW) {
          await _db.into(_db.localPersonalRecords).insert(LocalPersonalRecordsCompanion.insert(
                id: _uuid.v4(),
                exerciseName: ex.exerciseName,
                catalogExerciseId: Value(ex.serverExerciseId),
                recordType: 'HeaviestWeight',
                value: s.weight,
                achievedAtUtc: s.loggedAt,
              ));
          newPrs.add('${ex.exerciseName} weight ${s.weight}');
        }
      }
    }

    final mins = session.completedAt == null
        ? 0
        : session.completedAt!.difference(session.startedAt).inMinutes;

    if (session.programDayId != null) {
      await markDayCompleted(session.programDayId!);
    }

    return {
      'durationLabel': '${mins}m',
      'duration': '${mins}m',
      'workingSetCount': working,
      'exerciseCount': exercises.length,
      'totalWorkingVolume': volume,
      'personalRecords': newPrs,
      'comparisons': <Map>[],
      'insight': newPrs.isNotEmpty
          ? 'New PRs logged. Keep the program — no calendar change needed.'
          : 'Solid session. Continue while progression remains positive.',
    };
  }
}

class LocalCoachRepository implements CoachRepository {
  LocalCoachRepository(this._db, this._progress, {LocalTrainingMath? math})
      : _math = math ?? const LocalTrainingMath();
  final AppDatabase _db;
  final ProgressRepository _progress;
  final LocalTrainingMath _math;

  @override
  Future<CoachAnswer> ask(String question, {String? exerciseId}) async {
    final q = question.toLowerCase();
    if (q.contains('calorie') ||
        q.contains('nutrition') ||
        q.contains('meal') ||
        q.contains('macro') ||
        q.contains('diet')) {
      return const CoachAnswer(
        answer:
            'Nutrition and meal planning are out of scope for GymCoach AI. I can help with training, recovery readiness, and program decisions.',
        source: 'TRAINING_ENGINE',
        confidence: 1,
      );
    }

    final overview = await _progress.getOverview();
    final exercises = (overview['exercises'] as List?) ?? [];
    final program = await _db.getActiveProgram();
    final sessions = await _db.completedSessions(limit: 20);

    if (exercises.isEmpty && sessions.isEmpty) {
      return const CoachAnswer(
        answer:
            'Available training data is limited. Keep logging workouts so I can give a grounded answer from your on-device history.',
        source: 'TRAINING_ENGINE',
        confidence: 0.4,
      );
    }

    final progressing = exercises.where((e) {
      final m = Map<String, dynamic>.from(e as Map);
      final pts = (m['recentE1rmPoints'] as List?) ?? [];
      return pts.length >= 2 && (pts.last as num) >= (pts.first as num);
    }).length;

    if (q.contains('progress')) {
      return CoachAnswer(
        answer:
            'Based on on-device logs: $progressing of ${exercises.length} tracked lifts show a non-declining e1RM trend across recent exposures. '
            'Program "${program?.name ?? 'none'}" has no calendar end date — continue while progression remains positive.',
        source: 'TRAINING_ENGINE',
        confidence: 0.8,
      );
    }

    if (q.contains('deload')) {
      return CoachAnswer(
        answer: sessions.length < 6
            ? 'Not enough completed sessions to justify a deload yet. Keep logging consistent working sets first.'
            : 'Deload only if multiple key lifts decline with fatigue signals. Your recent session count is ${sessions.length}; '
                'prefer holding the program unless several lifts stall together.',
        source: 'TRAINING_ENGINE',
        confidence: 0.75,
      );
    }

    if (q.contains('program') || q.contains('change')) {
      return CoachAnswer(
        answer:
            'Program changes are evidence-based, not calendar-based. With $progressing lifts trending okay, stay on '
            'Program "${program?.name ?? 'your program'}". Replace the program only after plateaus persist across multiple key lifts.',
        source: 'TRAINING_ENGINE',
        confidence: 0.8,
      );
    }

    if (q.contains('weight') || q.contains('recommended') || q.contains('today')) {
      return const CoachAnswer(
        answer:
            'Today\'s weight comes from progressive overload on your recent working sets: hit the top of the rep range with enough RIR to add the load increment; otherwise keep load and push reps.',
        source: 'TRAINING_ENGINE',
        confidence: 0.75,
      );
    }

    if (q.contains('improved') || q.contains('pr')) {
      final prs = (overview['recentPrs'] as List?) ?? [];
      if (prs.isEmpty) {
        return const CoachAnswer(
          answer: 'No PRs stored yet. Finish more sessions to unlock PR detection from logged sets.',
          source: 'TRAINING_ENGINE',
          confidence: 0.6,
        );
      }
      final first = Map<String, dynamic>.from(prs.first as Map);
      return CoachAnswer(
        answer: 'Recent highlight: ${first['exerciseName']} ${first['type']} = ${first['value']}.',
        source: 'TRAINING_ENGINE',
        confidence: 0.8,
      );
    }

    // Plateau question for a named lift
    for (final raw in exercises) {
      final m = Map<String, dynamic>.from(raw as Map);
      final name = m['name']?.toString() ?? '';
      if (name.isNotEmpty && q.contains(name.toLowerCase().split(' ').first.toLowerCase())) {
        final pts = ((m['recentE1rmPoints'] as List?) ?? []).cast<num>().map((e) => e.toDouble()).toList();
        final plateau = _math.assessPlateau(pts);
        return CoachAnswer(
          answer:
              '$name: plateau state ${plateau.state} (e1RM trend ${plateau.trendPercent.toStringAsFixed(1)}%). ${plateau.reason}',
          source: 'TRAINING_ENGINE',
          confidence: 0.78,
        );
      }
    }

    return CoachAnswer(
      answer:
          'From your on-device training context: ${exercises.length} lifts tracked, ${sessions.length} completed sessions, '
          'program "${program?.name ?? 'none'}". Ask about progress, deload, program changes, or a specific lift.',
      source: 'TRAINING_ENGINE',
      confidence: 0.7,
    );
  }
}
