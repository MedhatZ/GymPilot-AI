import 'package:uuid/uuid.dart';

import '../data/repositories/gym_models.dart';
import 'exercise_catalog.dart';

/// Deterministic initial program generator (on-device). No network.
class LocalProgramGenerator {
  LocalProgramGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  GeneratedProgram generate(OnboardingInput input) {
    final daysPerWeek = input.trainingDaysPerWeek.clamp(2, 6);
    final split = _chooseSplit(daysPerWeek);
    final goalName = _goalLabel(input.primaryGoal);
    final programId = _uuid.v4();
    final injury = (input.injuryNotes ?? '').toLowerCase();

    final days = <GeneratedProgramDay>[];
    for (var i = 0; i < split.length; i++) {
      final plan = split[i];
      final dayId = _uuid.v4();
      final exercises = _pickExercises(
        patterns: plan.patterns,
        sessionMinutes: input.preferredSessionMinutes,
        seed: i,
        injury: injury,
        goal: input.primaryGoal,
        experience: input.experience,
        baselineBenchKg: input.baselineBenchKg,
      );
      days.add(GeneratedProgramDay(
        id: dayId,
        dayIndex: i,
        name: plan.name,
        split: plan.split,
        exercises: exercises,
      ));
    }

    return GeneratedProgram(
      id: programId,
      name: '$goalName Program',
      status: 'Active',
      startDateUtc: DateTime.now().toUtc(),
      endDateUtc: null,
      currentVersionNumber: 1,
      reason:
          'Generated on-device from your profile, goals, schedule, and equipment. No calendar end date.',
      days: days,
    );
  }

  List<_DayPlan> _chooseSplit(int days) {
    if (days <= 3) {
      return const [
        _DayPlan('Full Body A', 'FullBody', ['Squat', 'HorizontalPush', 'HorizontalPull', 'Hinge']),
        _DayPlan('Full Body B', 'FullBody', ['Hinge', 'VerticalPush', 'VerticalPull', 'Lunge']),
        _DayPlan('Full Body C', 'FullBody', ['Squat', 'HorizontalPush', 'HorizontalPull', 'Core']),
      ].take(days).toList();
    }
    if (days == 4) {
      return const [
        _DayPlan('Upper A', 'Upper', ['HorizontalPush', 'HorizontalPull', 'VerticalPush']),
        _DayPlan('Lower A', 'Lower', ['Squat', 'Hinge', 'Lunge']),
        _DayPlan('Upper B', 'Upper', ['VerticalPull', 'HorizontalPush', 'HorizontalPull']),
        _DayPlan('Lower B', 'Lower', ['Hinge', 'Squat', 'Core']),
      ];
    }
    return const [
      _DayPlan('Push', 'Push', ['HorizontalPush', 'VerticalPush']),
      _DayPlan('Pull', 'Pull', ['HorizontalPull', 'VerticalPull']),
      _DayPlan('Legs', 'Legs', ['Squat', 'Hinge', 'Lunge']),
      _DayPlan('Push B', 'Push', ['HorizontalPush', 'VerticalPush']),
      _DayPlan('Pull B', 'Pull', ['HorizontalPull', 'VerticalPull']),
      _DayPlan('Legs B', 'Legs', ['Squat', 'Hinge', 'Core']),
    ].take(days).toList();
  }

  List<GeneratedProgramExercise> _pickExercises({
    required List<String> patterns,
    required int sessionMinutes,
    required int seed,
    required String injury,
    required int goal,
    required int experience,
    required double? baselineBenchKg,
  }) {
    final targetCount = sessionMinutes >= 75 ? 6 : sessionMinutes >= 45 ? 5 : 4;
    final picked = <CatalogExercise>[];
    final catalog = ExerciseCatalog.all.where((e) => !_avoided(e, injury)).toList();

    for (final pattern in patterns) {
      final candidates = catalog
          .where((e) => e.pattern == pattern && !picked.contains(e))
          .toList()
        ..sort((a, b) {
          final c = (b.isCompound ? 1 : 0).compareTo(a.isCompound ? 1 : 0);
          return c != 0 ? c : a.name.compareTo(b.name);
        });
      if (candidates.isEmpty) continue;
      final pick = candidates[seed % candidates.length];
      picked.add(pick);
      if (picked.length >= targetCount) break;
    }

    while (picked.length < targetCount) {
      CatalogExercise? next;
      for (final e in catalog) {
        if (!picked.contains(e) && e.isCompound) {
          next = e;
          break;
        }
      }
      next ??= catalog.cast<CatalogExercise?>().firstWhere(
            (e) => e != null && !picked.contains(e),
            orElse: () => null,
          );
      if (next == null) break;
      picked.add(next);
    }

    return [
      for (var i = 0; i < picked.length; i++)
        () {
          final ex = picked[i];
          final rx = _prescription(goal, ex.isCompound, experience);
          double? start = ex.name.toLowerCase().contains('bench') ? baselineBenchKg : null;
          if (start == null && ex.isCompound) {
            start = _defaultStart(ex, experience);
          }
          return GeneratedProgramExercise(
            id: _uuid.v4(),
            catalogExerciseId: ex.id,
            exerciseName: ex.name,
            position: i,
            sets: rx.sets,
            minReps: rx.min,
            maxReps: rx.max,
            startingLoadKg: start,
            restSeconds: rx.rest,
            targetRir: rx.rir,
            isCompound: ex.isCompound,
            loadIncrementKg: ex.loadIncrementKg,
          );
        }()
    ];
  }

  bool _avoided(CatalogExercise e, String injury) {
    if (injury.isEmpty) return false;
    if (injury.contains('shoulder') &&
        (e.pattern == 'VerticalPush' || e.name.toLowerCase().contains('overhead'))) {
      return true;
    }
    if (injury.contains('knee') && (e.pattern == 'Lunge' || e.name.toLowerCase().contains('lunge'))) {
      return true;
    }
    if (injury.contains('back') && e.name.toLowerCase().contains('deadlift') && !e.name.contains('Romanian')) {
      return true;
    }
    return false;
  }

  double _defaultStart(CatalogExercise ex, int experience) {
    final base = switch (ex.pattern) {
      'Squat' => 40.0,
      'Hinge' => 50.0,
      'HorizontalPush' => 30.0,
      'HorizontalPull' => 35.0,
      'VerticalPush' => 20.0,
      'VerticalPull' => 0.0,
      'Lunge' => 16.0,
      _ => 10.0,
    };
    final mult = experience == 0 ? 0.7 : experience == 2 ? 1.3 : 1.0;
    return (base * mult / 2.5).round() * 2.5;
  }

  ({int sets, int min, int max, double rir, int rest}) _prescription(
    int goal,
    bool compound,
    int experience,
  ) {
    return switch (goal) {
      1 => (sets: compound ? 4 : 3, min: 3, max: 5, rir: 2, rest: compound ? 180 : 120),
      2 => (sets: compound ? 4 : 3, min: 5, max: 8, rir: 2, rest: compound ? 150 : 90),
      3 => (sets: 3, min: 8, max: 12, rir: 2, rest: 90),
      4 => (sets: 3, min: 8, max: 15, rir: 3, rest: 75),
      _ => (sets: compound ? 3 : 3, min: 8, max: 12, rir: 2, rest: compound ? 120 : 75),
    };
  }

  String _goalLabel(int goal) => switch (goal) {
        1 => 'Strength',
        2 => 'Strength + Hypertrophy',
        3 => 'Body Recomp',
        4 => 'General Fitness',
        _ => 'Hypertrophy',
      };
}

class _DayPlan {
  const _DayPlan(this.name, this.split, this.patterns);
  final String name;
  final String split;
  final List<String> patterns;
}
