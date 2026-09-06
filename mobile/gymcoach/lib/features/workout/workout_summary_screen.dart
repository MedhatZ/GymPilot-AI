import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_client.dart';
import '../../data/local/database_provider.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key, required this.sessionClientId});
  final String sessionClientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _load(ref),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final data = snap.data!;
        final prs = (data['personalRecords'] as List?) ?? [];
        final comparisons = (data['comparisons'] as List?) ?? [];
        return Scaffold(
          appBar: AppBar(title: const Text('Workout summary')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Duration: ${data['durationLabel'] ?? data['duration'] ?? '—'}',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Working sets: ${data['workingSetCount'] ?? '—'}'),
              Text('Exercises: ${data['exerciseCount'] ?? '—'}'),
              Text('Volume: ${data['totalWorkingVolume'] ?? '—'} kg'),
              const SizedBox(height: 16),
              if (prs.isNotEmpty) ...[
                Text('NEW PR', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.amber)),
                ...prs.map((p) => Text('• $p')),
                const SizedBox(height: 16),
              ],
              if (data['insight'] != null)
                Text(data['insight'].toString(), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...comparisons.map((c) {
                final m = Map<String, dynamic>.from(c as Map);
                final change = m['changePercent'];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(m['exerciseName']?.toString() ?? ''),
                  subtitle: Text('e1RM ${m['currentBestE1rm']} (prev ${m['previousBestE1rm'] ?? '—'})'),
                  trailing: change == null ? null : Text('${change > 0 ? '+' : ''}$change%'),
                );
              }),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => context.go('/home'), child: const Text('Done')),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _load(WidgetRef ref) async {
    try {
      final res = await ref.read(apiClientProvider).dio.get('/api/workouts/$sessionClientId/summary');
      final data = Map<String, dynamic>.from(res.data as Map);
      final duration = data['duration']?.toString();
      if (duration != null) data['durationLabel'] = duration;
      return data;
    } catch (_) {
      final db = ref.read(appDatabaseProvider);
      final session = await (db.select(db.workoutSessions)..where((s) => s.id.equals(sessionClientId))).getSingleOrNull();
      final exercises = await db.exercisesForSession(sessionClientId);
      var working = 0;
      var volume = 0.0;
      for (final e in exercises) {
        final sets = await db.setsForExercise(e.id);
        for (final s in sets.where((s) => !s.isWarmup)) {
          working++;
          volume += s.weight * s.reps;
        }
      }
      final mins = session == null
          ? 0
          : (session.completedAt ?? DateTime.now().toUtc()).difference(session.startedAt).inMinutes;
      return {
        'durationLabel': '${mins}m',
        'workingSetCount': working,
        'exerciseCount': exercises.length,
        'totalWorkingVolume': volume,
        'personalRecords': <String>[],
        'comparisons': <Map>[],
        'insight': working > 0 ? 'Session saved offline. Sync when connected.' : null,
      };
    }
  }
}
