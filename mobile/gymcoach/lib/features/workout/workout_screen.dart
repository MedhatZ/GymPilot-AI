import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/personal_mode_service.dart';
import '../../data/local/app_database.dart';
import '../../data/local/database_provider.dart';
import 'active_workout_controller.dart';
import 'rest_timer_controller.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  double _weight = 60;
  int _reps = 8;
  int? _rir = 2;
  var _warmup = false;
  var _energy = 1;
  var _soreness = 0;
  var _motivation = 1;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeWorkoutProvider);
    final timer = ref.watch(restTimerProvider);
    final increment = ref.watch(appConfigProvider).defaultWeightIncrementKg;

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Quick readiness (optional)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _chipRow('Energy', ['Low', 'Normal', 'High'], _energy, (v) => setState(() => _energy = v)),
            _chipRow('Soreness', ['Low', 'Moderate', 'High'], _soreness, (v) => setState(() => _soreness = v)),
            _chipRow('Motivation', ['Low', 'Normal', 'High'], _motivation, (v) => setState(() => _motivation = v)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.read(activeWorkoutProvider.notifier).startFromRecommended(readiness: {
                'energy': _energy,
                'soreness': _soreness,
                'motivation': _motivation,
              }),
              child: const Text('START WORKOUT'),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 12),
              Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
      );
    }

    final ex = state.currentExercise;
    if (ex != null && _weight == 60 && ex.suggestedWeight != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _weight = ex.suggestedWeight!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(state.session!.name),
        actions: [
          TextButton(
            onPressed: () => _finish(context),
            child: const Text('FINISH'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.exercises.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final e = state.exercises[i];
                final selected = i == state.currentExerciseIndex;
                return ChoiceChip(
                  label: Text(e.exerciseName),
                  selected: selected,
                  onSelected: (_) {
                    ref.read(activeWorkoutProvider.notifier).selectExercise(i);
                    setState(() {
                      _weight = e.suggestedWeight ?? _weight;
                      _reps = e.minReps;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (ex != null) ...[
            Text(ex.exerciseName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            if (ex.substitutedFromName != null)
              Text('Substituted from ${ex.substitutedFromName}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('Target ${ex.targetSets} × ${ex.minReps}-${ex.maxReps}'),
            Text('Suggested: ${ex.suggestedWeight?.toStringAsFixed(1) ?? '—'} kg'),
            if (ex.previousPerformanceJson != null)
              Builder(builder: (_) {
                try {
                  final m = jsonDecode(ex.previousPerformanceJson!) as Map;
                  return Text('Why: ${m['reason'] ?? ''}', style: Theme.of(context).textTheme.bodyMedium);
                } catch (_) {
                  return const SizedBox.shrink();
                }
              }),
            const SizedBox(height: 12),
            if (timer.isRunning || timer.isPaused) _RestTimerCard(timer: timer, restSeconds: ex.restSeconds),
            const SizedBox(height: 12),
            Text('Weight', style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                _incBtn('-5', () => setState(() => _weight = (_weight - 5).clamp(0, 999))),
                _incBtn('-$increment', () => setState(() => _weight = (_weight - increment).clamp(0, 999))),
                Expanded(
                  child: Text(
                    '${_weight.toStringAsFixed(_weight % 1 == 0 ? 0 : 1)} kg',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                _incBtn('+$increment', () => setState(() => _weight += increment)),
                _incBtn('+5', () => setState(() => _weight += 5)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Reps', style: Theme.of(context).textTheme.titleMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(onPressed: () => setState(() => _reps = (_reps - 1).clamp(1, 50)), icon: const Icon(Icons.remove)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('$_reps', style: Theme.of(context).textTheme.headlineMedium),
                ),
                IconButton.filledTonal(onPressed: () => setState(() => _reps++), icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 8),
            Text('RIR (optional)', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children: [
                for (final v in [0, 1, 2, 3, 4])
                  ChoiceChip(
                    label: Text(v == 4 ? '4+' : '$v'),
                    selected: _rir == v,
                    onSelected: (_) => setState(() => _rir = v),
                  ),
                FilterChip(
                  label: const Text('Skip RIR'),
                  selected: _rir == null,
                  onSelected: (_) => setState(() => _rir = null),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Warm-up set'),
              value: _warmup,
              onChanged: (v) => setState(() => _warmup = v),
            ),
            FilledButton(
              onPressed: () async {
                await ref.read(activeWorkoutProvider.notifier).logSet(
                      weight: _weight,
                      reps: _reps,
                      rir: _rir,
                      warmup: _warmup,
                    );
              },
              child: const Text('LOG SET'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _substitute(context),
                    child: const Text('Replace exercise'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pain(context),
                    child: const Text('Pain / discomfort'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Sets', style: Theme.of(context).textTheme.titleMedium),
            _SetsList(exerciseId: ex.id),
          ],
        ],
      ),
    );
  }

  Widget _chipRow(String label, List<String> labels, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 96, child: Text(label)),
          Expanded(
            child: Wrap(
              spacing: 6,
              children: [
                for (var i = 0; i < labels.length; i++)
                  ChoiceChip(label: Text(labels[i]), selected: value == i, onSelected: (_) => onChanged(i)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _incBtn(String label, VoidCallback onPressed) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(minimumSize: const Size(52, 48), padding: const EdgeInsets.symmetric(horizontal: 8)),
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
      );

  Future<void> _finish(BuildContext context) async {
    var difficulty = 1;
    var pain = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Finish workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How was the workout?'),
              Wrap(spacing: 6, children: [
                for (final e in [(0, 'Very Easy'), (1, 'Good'), (2, 'Hard'), (3, 'Very Hard')])
                  ChoiceChip(
                    label: Text(e.$2),
                    selected: difficulty == e.$1,
                    onSelected: (_) => setLocal(() => difficulty = e.$1),
                  ),
              ]),
              const SizedBox(height: 12),
              const Text('Any pain?'),
              Row(children: [
                ChoiceChip(label: const Text('No'), selected: !pain, onSelected: (_) => setLocal(() => pain = false)),
                const SizedBox(width: 8),
                ChoiceChip(label: const Text('Yes'), selected: pain, onSelected: (_) => setLocal(() => pain = true)),
              ]),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Finish')),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final id = await ref.read(activeWorkoutProvider.notifier).finish(difficulty: difficulty, pain: pain);
    if (id != null && context.mounted) context.push('/summary/$id');
  }

  Future<void> _substitute(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace for this session'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Alternative exercise')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Replace')),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(activeWorkoutProvider.notifier).substituteExercise(name);
    }
  }

  Future<void> _pain(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pain noted for this session (not medical advice). You can continue.')),
    );
  }
}

class _RestTimerCard extends ConsumerWidget {
  const _RestTimerCard({required this.timer, required this.restSeconds});
  final RestTimerController timer;
  final int restSeconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            timer.isPaused ? 'Paused ${timer.remainingSeconds}s' : 'Rest ${timer.remainingSeconds}s',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              if (!timer.isPaused)
                FilledButton.tonal(onPressed: timer.pause, child: const Text('Pause'))
              else
                FilledButton.tonal(onPressed: timer.resume, child: const Text('Resume')),
              FilledButton.tonal(onPressed: () => timer.addSeconds(30), child: const Text('+30s')),
              FilledButton.tonal(onPressed: () => timer.reset(restSeconds), child: const Text('Reset')),
              FilledButton.tonal(onPressed: timer.skip, child: const Text('Skip')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SetsList extends ConsumerWidget {
  const _SetsList({required this.exerciseId});
  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    return StreamBuilder<List<WorkoutSet>>(
      stream: db.watchSets(exerciseId),
      builder: (context, snap) {
        final sets = snap.data ?? [];
        if (sets.isEmpty) return const Text('No sets yet');
        return Column(
          children: sets.map((s) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(s.isWarmup ? Icons.whatshot_outlined : Icons.check_circle, color: s.isWarmup ? Colors.orange : Colors.green),
              title: Text('${s.weight} kg × ${s.reps}${s.rir != null ? ' @ RIR ${s.rir}' : ''}'),
              subtitle: Text(s.isWarmup ? 'Warm-up' : 'Working · #${s.setNumber}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => ref.read(activeWorkoutProvider.notifier).deleteSet(s.id),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
