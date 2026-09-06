import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/personal_mode_service.dart';
import '../../core/network/api_client.dart';
import '../local/database_provider.dart';
import 'api/api_repositories.dart';
import 'local/local_core_repositories.dart';
import 'local/local_workout_coach_repositories.dart';
import 'repository_contracts.dart';

/// Mode switch: PersonalMode → local Drift services; otherwise API (+ local fallbacks).

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final personal = ref.watch(personalModeServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  if (personal.isEnabled) return LocalOnboardingRepository(db);
  return ApiOnboardingRepository(ref.watch(apiClientProvider));
});

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  final personal = ref.watch(personalModeServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  if (personal.isEnabled) return LocalProgramRepository(db);
  return ApiProgramRepository(ref.watch(apiClientProvider));
});

final workoutSessionRepositoryProvider = Provider<WorkoutSessionRepository>((ref) {
  final personal = ref.watch(personalModeServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  final local = LocalWorkoutSessionRepository(db);
  if (personal.isEnabled) return local;
  return ApiWorkoutSessionRepository(ref.watch(apiClientProvider), local);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final personal = ref.watch(personalModeServiceProvider);
  if (personal.isEnabled) {
    return LocalHomeRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(programRepositoryProvider),
      ref.watch(workoutSessionRepositoryProvider),
    );
  }
  return ApiHomeRepository(ref.watch(apiClientProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final personal = ref.watch(personalModeServiceProvider);
  if (personal.isEnabled) {
    return LocalProgressRepository(ref.watch(appDatabaseProvider));
  }
  return ApiProgressRepository(ref.watch(apiClientProvider));
});

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  final personal = ref.watch(personalModeServiceProvider);
  final local = LocalCoachRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(progressRepositoryProvider),
  );
  if (personal.isEnabled) return local;
  return ApiCoachRepository(ref.watch(apiClientProvider), local);
});
