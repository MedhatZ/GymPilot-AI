import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../gym_models.dart';
import '../repository_contracts.dart';

/// Cloud/API implementations — used when PersonalMode is false.
class ApiOnboardingRepository implements OnboardingRepository {
  ApiOnboardingRepository(this._api);
  final ApiClient _api;

  @override
  Future<bool> isOnboardingComplete() async {
    final me = await _api.dio.get('/api/onboarding/me');
    return me.data['onboardingCompleted'] == true;
  }

  @override
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final me = await _api.dio.get('/api/onboarding/me');
      return Map<String, dynamic>.from(me.data as Map);
    } on DioException {
      return null;
    }
  }

  @override
  Future<void> completeSetup(OnboardingInput input) async {
    await _api.dio.post('/api/onboarding', data: _payload(input));
  }

  @override
  Future<void> updateProfile(OnboardingInput input) => completeSetup(input);

  Map<String, dynamic> _payload(OnboardingInput input) => {
        'displayName': input.displayName,
        'age': input.age,
        'sex': input.sex,
        'heightCm': input.heightCm,
        'bodyWeightKg': input.bodyWeightKg,
        'experience': input.experience,
        'yearsTraining': input.yearsTraining,
        'primaryGoal': input.primaryGoal,
        'secondaryGoal': input.secondaryGoal,
        'trainingDaysPerWeek': input.trainingDaysPerWeek,
        'preferredSessionMinutes': input.preferredSessionMinutes,
        'equipmentSetting': input.equipmentSetting,
        'equipmentIds': <String>[],
        'limitations': input.injuryNotes == null || input.injuryNotes!.isEmpty
            ? <Map>[]
            : [
                {
                  'injuryDescription': input.injuryNotes,
                  'painArea': null,
                  'avoidedExerciseId': null,
                  'movementRestriction': null,
                }
              ],
        'baselineLifts': <Map>[],
      };
}

class ApiProgramRepository implements ProgramRepository {
  ApiProgramRepository(this._api);
  final ApiClient _api;

  @override
  Future<Map<String, dynamic>?> getActiveProgram() async {
    try {
      final res = await _api.dio.get('/api/programs/active');
      return Map<String, dynamic>.from(res.data as Map);
    } on DioException {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> generateInitial(OnboardingInput input) async {
    final res = await _api.dio.post('/api/programs/generate');
    return Map<String, dynamic>.from(res.data as Map);
  }
}

class ApiHomeRepository implements HomeRepository {
  ApiHomeRepository(this._api);
  final ApiClient _api;

  @override
  Future<Map<String, dynamic>> getHome() async {
    final res = await _api.dio.get('/api/home');
    return Map<String, dynamic>.from(res.data as Map);
  }
}

class ApiProgressRepository implements ProgressRepository {
  ApiProgressRepository(this._api);
  final ApiClient _api;

  @override
  Future<Map<String, dynamic>> getOverview() async {
    final res = await _api.dio.get('/api/progress');
    return Map<String, dynamic>.from(res.data as Map);
  }
}

class ApiCoachRepository implements CoachRepository {
  ApiCoachRepository(this._api, this._fallback);
  final ApiClient _api;
  final CoachRepository _fallback;

  @override
  Future<CoachAnswer> ask(String question, {String? exerciseId}) async {
    try {
      final res = await _api.dio.post('/api/coach/ask', data: {
        'question': question,
        'exerciseId': exerciseId,
      });
      final data = Map<String, dynamic>.from(res.data as Map);
      return CoachAnswer(
        answer: data['answer']?.toString() ?? '',
        source: data['source']?.toString() ?? 'OPENAI',
        confidence: (data['confidence'] as num?)?.toDouble() ?? 0.8,
      );
    } catch (_) {
      return _fallback.ask(question, exerciseId: exerciseId);
    }
  }
}

class ApiWorkoutSessionRepository implements WorkoutSessionRepository {
  ApiWorkoutSessionRepository(this._api, this._local);
  final ApiClient _api;
  final WorkoutSessionRepository _local;

  @override
  Future<Map<String, dynamic>?> getNextWorkout() async {
    try {
      final res = await _api.dio.get('/api/workouts/next');
      final data = Map<String, dynamic>.from(res.data as Map);
      final exercises = (data['exercises'] as List?) ?? [];
      if (exercises.isNotEmpty) return data;

      // Backward compatible if older deploy omitted exercises.
      final programDayId = data['programDayId']?.toString();
      if (programDayId == null) return data;
      final programRes = await _api.dio.get('/api/programs/active');
      final program = Map<String, dynamic>.from(programRes.data as Map);
      final days = (program['days'] as List?) ?? [];
      for (final d in days) {
        final day = Map<String, dynamic>.from(d as Map);
        if (day['id']?.toString() == programDayId) {
          data['exercises'] = day['exercises'] ?? [];
          data['dayName'] ??= day['name'];
          data['programName'] ??= program['name'];
          return data;
        }
      }
      return data;
    } catch (_) {
      return _local.getNextWorkout();
    }
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
    try {
      final res = await _api.dio.get('/api/workouts/suggest/$catalogExerciseId');
      return Map<String, dynamic>.from(res.data as Map);
    } catch (_) {
      return _local.suggestLoad(
        catalogExerciseId: catalogExerciseId,
        exerciseName: exerciseName,
        targetSets: targetSets,
        minReps: minReps,
        maxReps: maxReps,
        loadIncrementKg: loadIncrementKg,
        startingLoadKg: startingLoadKg,
      );
    }
  }

  @override
  Future<void> markDayCompleted(String programDayId) =>
      _local.markDayCompleted(programDayId);

  @override
  Future<Map<String, dynamic>> buildSummary(String sessionClientId) async {
    try {
      final res = await _api.dio.get('/api/workouts/$sessionClientId/summary');
      return Map<String, dynamic>.from(res.data as Map);
    } catch (_) {
      return _local.buildSummary(sessionClientId);
    }
  }
}
