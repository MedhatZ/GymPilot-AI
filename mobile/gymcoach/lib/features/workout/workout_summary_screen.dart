import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymcoach/l10n/app_localizations.dart';

import '../../data/repositories/repository_providers.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key, required this.sessionClientId});
  final String sessionClientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(workoutSessionRepositoryProvider).buildSummary(sessionClientId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final data = snap.data!;
        final prs = (data['personalRecords'] as List?) ?? [];
        final comparisons = (data['comparisons'] as List?) ?? [];
        return Scaffold(
          appBar: AppBar(title: Text(l10n.workoutSummary)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  l10n.durationValue(data['durationLabel'] ?? data['duration'] ?? '—'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(l10n.workingSetsValue(data['workingSetCount'] ?? '—')),
                Text(l10n.exercisesValue(data['exerciseCount'] ?? '—')),
                Text(l10n.volumeValue(data['totalWorkingVolume'] ?? '—')),
                const SizedBox(height: 16),
                if (prs.isNotEmpty) ...[
                  Text(l10n.newPr, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.amber)),
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
                FilledButton(onPressed: () => context.go('/home'), child: Text(l10n.done)),
              ],
            ),
          ),
        );
      },
    );
  }
}
