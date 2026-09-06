import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/personal_mode_service.dart';
import '../../core/network/api_client.dart';
import '../local/app_database.dart';
import '../local/database_provider.dart';

class SyncService {
  SyncService(this._db, this._api, this._personal);

  final AppDatabase _db;
  final ApiClient _api;
  final PersonalModeService _personal;
  final _uuid = const Uuid();

  Future<void> enqueueSetSync({
    required String sessionClientId,
    required String exerciseClientId,
    required String setClientId,
    required String exerciseName,
    required double weight,
    required int reps,
    required int? rir,
    required bool isWarmup,
  }) async {
    final payload = jsonEncode({
      'sessionClientId': sessionClientId,
      'exerciseClientId': exerciseClientId,
      'setClientId': setClientId,
      'exerciseName': exerciseName,
      'weight': weight,
      'reps': reps,
      'rir': rir,
      'isWarmup': isWarmup,
    });
    await _db.into(_db.syncOperations).insert(SyncOperationsCompanion.insert(
          id: _uuid.v4(),
          entityType: 'workout_set',
          entityId: setClientId,
          operation: 'upsert',
          payload: payload,
          createdAt: DateTime.now().toUtc(),
        ));
  }

  /// Personal Mode: no network flush — Drift is the source of truth.
  Future<int> flush() async {
    if (_personal.isEnabled) return 0;

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return 0;

    final pending = await (_db.select(_db.syncOperations)).get();
    var flushed = 0;
    for (final op in pending) {
      try {
        await (_db.update(_db.syncOperations)..where((t) => t.id.equals(op.id))).write(
          SyncOperationsCompanion(attempts: Value(op.attempts + 1)),
        );
        flushed++;
      } catch (_) {
        await (_db.update(_db.syncOperations)..where((t) => t.id.equals(op.id))).write(
          SyncOperationsCompanion(attempts: Value(op.attempts + 1)),
        );
      }
    }

    final sessions = await _db.select(_db.workoutSessions).get();
    for (final session in sessions) {
      final exercises = await (_db.select(_db.workoutExercises)
            ..where((e) => e.sessionId.equals(session.id)))
          .get();
      final payloadExercises = <Map<String, dynamic>>[];
      for (final ex in exercises) {
        final sets = await (_db.select(_db.workoutSets)..where((s) => s.exerciseId.equals(ex.id))).get();
        payloadExercises.add({
          'clientId': ex.id,
          'exerciseId': '00000000-0000-0000-0000-000000000001',
          'order': ex.position,
          'sets': sets
              .map((s) => {
                    'clientId': s.id,
                    'setNumber': sets.indexOf(s) + 1,
                    'weightKg': s.weight,
                    'reps': s.reps,
                    'rir': s.rir,
                    'setType': s.isWarmup ? 0 : 1,
                    'completedAtUtc': s.loggedAt.toUtc().toIso8601String(),
                    'note': null,
                  })
              .toList(),
        });
      }
      try {
        await _api.dio.post(
          '/api/sync/workouts',
          data: {
            'sessions': [
              {
                'clientId': session.id,
                'programDayId': null,
                'startedAtUtc': session.startedAt.toUtc().toIso8601String(),
                'completedAtUtc': session.completedAt?.toUtc().toIso8601String(),
                'difficulty': 1,
                'painReported': false,
                'painLocation': null,
                'painExerciseId': null,
                'notes': null,
                'exercises': payloadExercises,
              }
            ]
          },
          options: Options(headers: {'Idempotency-Key': session.id}),
        );
      } catch (_) {}
    }
    return flushed;
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider),
    ref.watch(personalModeServiceProvider),
  );
});
