import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymcoach/l10n/app_localizations.dart';

import '../../data/repositories/repository_providers.dart';
import '../workout/active_workout_controller.dart';

final homeProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    return await ref.watch(homeRepositoryProvider).getHome();
  } catch (_) {
    return null;
  }
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final home = ref.watch(homeProvider);
    final active = ref.watch(activeWorkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.program,
            onPressed: () => context.push('/program'),
            icon: const Icon(Icons.calendar_view_week),
          ),
        ],
      ),
      body: home.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.couldNotLoadHome)),
        data: (data) {
          final today = data?['todaysWorkout'] as Map?;
          final next = data?['nextWorkout'] as Map?;
          final program = data?['activeProgram'] as Map?;
          final recovery = data?['recovery'] as Map?;
          final exercises = (today?['exercises'] as List?) ?? [];

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (active.session != null) ...[
                  Card(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    child: ListTile(
                      title: Text(l10n.activeWorkout),
                      subtitle: Text(active.session!.name),
                      trailing: FilledButton(
                        onPressed: () => context.go('/workout'),
                        child: Text(l10n.resume),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(l10n.todaysWorkout, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(
                  today?['name']?.toString() ?? next?['dayName']?.toString() ?? l10n.noWorkoutYet,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(program == null
                    ? l10n.completeSetupForProgram
                    : '${program['name']} · v${program['currentVersionNumber']}'),
                if (next != null) ...[
                  const SizedBox(height: 4),
                  Text(l10n.daySessionMeta(
                    l10n.dayLabel(((next['dayIndex'] as num?)?.toInt() ?? 0) + 1),
                    next['exerciseCount'] ?? 0,
                    next['estimatedMinutes'] ?? 0,
                  )),
                ] else if (today != null) ...[
                  Text(l10n.exercisesCount(exercises.length)),
                ],
                if (recovery != null) ...[
                  const SizedBox(height: 8),
                  Text(l10n.readinessWithScore(
                    recovery['readinessScore'] ?? '—',
                    recovery['label'] ?? '',
                  )),
                ],
                const SizedBox(height: 8),
                Text(data?['insight']?.toString() ?? '', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go('/workout'),
                  child: Text(active.session != null ? l10n.resumeWorkout : l10n.startWorkout),
                ),
                const SizedBox(height: 20),
                if (data?['lastWorkoutName'] != null)
                  Text(l10n.lastWorkout(data!['lastWorkoutName'].toString())),
                if (data?['recentPr'] != null) Text(l10n.recentPr(data!['recentPr'].toString())),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.refresh(homeProvider),
                  child: Text(l10n.refresh),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
