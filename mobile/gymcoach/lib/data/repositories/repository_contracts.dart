import '../repositories/gym_models.dart';

abstract class OnboardingRepository {
  Future<bool> isOnboardingComplete();
  Future<Map<String, dynamic>?> getProfile();
  Future<void> completeSetup(OnboardingInput input);
  Future<void> updateProfile(OnboardingInput input);
}

abstract class ProgramRepository {
  Future<Map<String, dynamic>?> getActiveProgram();
  Future<Map<String, dynamic>> generateInitial(OnboardingInput input);
}

abstract class HomeRepository {
  Future<Map<String, dynamic>> getHome();
}

abstract class ProgressRepository {
  Future<Map<String, dynamic>> getOverview();
}

abstract class CoachRepository {
  Future<CoachAnswer> ask(String question, {String? exerciseId});
}

abstract class WorkoutSessionRepository {
  /// Recommended next program day with exercises (maps compatible with existing UI).
  Future<Map<String, dynamic>?> getNextWorkout();
  Future<Map<String, dynamic>?> suggestLoad({
    required String catalogExerciseId,
    required String exerciseName,
    required int targetSets,
    required int minReps,
    required int maxReps,
    required double loadIncrementKg,
    double? startingLoadKg,
  });
  Future<void> markDayCompleted(String programDayId);
  Future<Map<String, dynamic>> buildSummary(String sessionClientId);
}
