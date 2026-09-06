/// Shared DTOs used by local and API repositories (UI-facing maps stay compatible).
library;

class OnboardingInput {
  const OnboardingInput({
    required this.displayName,
    required this.age,
    required this.sex,
    required this.heightCm,
    required this.bodyWeightKg,
    required this.experience,
    required this.yearsTraining,
    required this.primaryGoal,
    this.secondaryGoal,
    required this.trainingDaysPerWeek,
    required this.preferredSessionMinutes,
    required this.equipmentSetting,
    this.injuryNotes,
    this.baselineBenchKg,
  });

  final String displayName;
  final int age;
  final int sex;
  final double heightCm;
  final double bodyWeightKg;
  final int experience;
  final double yearsTraining;
  final int primaryGoal;
  final int? secondaryGoal;
  final int trainingDaysPerWeek;
  final int preferredSessionMinutes;
  final int equipmentSetting;
  final String? injuryNotes;
  final double? baselineBenchKg;
}

class GeneratedProgram {
  const GeneratedProgram({
    required this.id,
    required this.name,
    required this.status,
    required this.startDateUtc,
    required this.endDateUtc,
    required this.currentVersionNumber,
    required this.reason,
    required this.days,
  });

  final String id;
  final String name;
  final String status;
  final DateTime startDateUtc;
  final DateTime? endDateUtc;
  final int currentVersionNumber;
  final String? reason;
  final List<GeneratedProgramDay> days;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'status': status,
        'startDateUtc': startDateUtc.toIso8601String(),
        'endDateUtc': endDateUtc,
        'currentVersionNumber': currentVersionNumber,
        'reason': reason,
        'days': days.map((d) => d.toMap()).toList(),
      };
}

class GeneratedProgramDay {
  const GeneratedProgramDay({
    required this.id,
    required this.dayIndex,
    required this.name,
    required this.split,
    required this.exercises,
  });

  final String id;
  final int dayIndex;
  final String name;
  final String split;
  final List<GeneratedProgramExercise> exercises;

  Map<String, dynamic> toMap() => {
        'id': id,
        'dayIndex': dayIndex,
        'name': name,
        'split': split,
        'exercises': exercises.map((e) => e.toMap()).toList(),
      };
}

class GeneratedProgramExercise {
  const GeneratedProgramExercise({
    required this.id,
    required this.catalogExerciseId,
    required this.exerciseName,
    required this.position,
    required this.sets,
    required this.minReps,
    required this.maxReps,
    required this.startingLoadKg,
    required this.restSeconds,
    required this.targetRir,
    required this.isCompound,
    required this.loadIncrementKg,
  });

  final String id;
  final String catalogExerciseId;
  final String exerciseName;
  final int position;
  final int sets;
  final int minReps;
  final int maxReps;
  final double? startingLoadKg;
  final int restSeconds;
  final double? targetRir;
  final bool isCompound;
  final double loadIncrementKg;

  Map<String, dynamic> toMap() => {
        'id': id,
        'exerciseId': catalogExerciseId,
        'exerciseName': exerciseName,
        'order': position,
        'sets': sets,
        'minReps': minReps,
        'maxReps': maxReps,
        'startingLoadKg': startingLoadKg,
        'restSeconds': restSeconds,
        'targetRir': targetRir,
        'isCompound': isCompound,
        'loadIncrementKg': loadIncrementKg,
      };
}

class CoachAnswer {
  const CoachAnswer({
    required this.answer,
    required this.source,
    this.confidence = 0.7,
  });
  final String answer;
  final String source;
  final double confidence;
}
