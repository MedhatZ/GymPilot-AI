import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_client.dart';
import '../workout/active_workout_controller.dart';

final homeProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final res = await ref.watch(apiClientProvider).dio.get('/api/home');
    return Map<String, dynamic>.from(res.data as Map);
  } catch (_) {
    return null;
  }
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final active = ref.watch(activeWorkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymCoach AI'),
        actions: [
          IconButton(
            tooltip: 'Program',
            onPressed: () => context.push('/program'),
            icon: const Icon(Icons.calendar_view_week),
          ),
        ],
      ),
      body: home.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (data) {
          final today = data?['todaysWorkout'] as Map?;
          final next = data?['nextWorkout'] as Map?;
          final program = data?['activeProgram'] as Map?;
          final recovery = data?['recovery'] as Map?;
          final exercises = (today?['exercises'] as List?) ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (active.session != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: ListTile(
                    title: const Text('ACTIVE WORKOUT'),
                    subtitle: Text(active.session!.name),
                    trailing: FilledButton(
                      onPressed: () => context.go('/workout'),
                      child: const Text('RESUME'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text("TODAY'S WORKOUT", style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(
                today?['name']?.toString() ?? next?['dayName']?.toString() ?? 'No workout yet',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(program == null
                  ? 'Complete setup to generate a program.'
                  : '${program['name']} · v${program['currentVersionNumber']}'),
              if (next != null) ...[
                const SizedBox(height: 4),
                Text('Day ${((next['dayIndex'] as num?)?.toInt() ?? 0) + 1} · ${next['exerciseCount']} exercises · ~${next['estimatedMinutes']} min'),
              ] else if (today != null) ...[
                Text('${exercises.length} exercises'),
              ],
              if (recovery != null) ...[
                const SizedBox(height: 8),
                Text('Readiness: ${recovery['readinessScore']} (${recovery['label']})'),
              ],
              const SizedBox(height: 8),
              Text(data?['insight']?.toString() ?? '', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/workout'),
                child: Text(active.session != null ? 'RESUME WORKOUT' : 'START WORKOUT'),
              ),
              const SizedBox(height: 20),
              if (data?['lastWorkoutName'] != null)
                Text('Last: ${data!['lastWorkoutName']}'),
              if (data?['recentPr'] != null) Text('Recent PR: ${data!['recentPr']}'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.refresh(homeProvider),
                child: const Text('Refresh'),
              ),
            ],
          );
        },
      ),
    );
  }
}
