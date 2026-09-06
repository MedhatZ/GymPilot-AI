import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymcoach/l10n/app_localizations.dart';

import '../../data/repositories/repository_providers.dart';

final progressProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    return await ref.watch(progressRepositoryProvider).getOverview();
  } catch (_) {
    return {
      'exercises': <Map>[],
      'recentPrs': <Map>[],
      'recovery': {'readinessScore': 70, 'label': 'moderate'},
    };
  }
});

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(progressProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.progress),
          bottom: TabBar(tabs: [
            Tab(text: l10n.overview),
            Tab(text: l10n.exercises),
            Tab(text: l10n.history),
          ]),
        ),
        body: progress.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (data) {
            if (data == null) {
              return Center(child: Text(l10n.progressEmpty));
            }
            final exercises = (data['exercises'] as List?) ?? [];
            final prs = (data['recentPrs'] as List?) ?? [];
            final recovery = data['recovery'] as Map?;
            return TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(l10n.sessionsTracked(exercises.length)),
                    if (recovery != null)
                      Text(l10n.readinessWithScore(
                        recovery['readinessScore'] ?? '—',
                        recovery['label'] ?? '',
                      )),
                    const SizedBox(height: 12),
                    Text(l10n.recentPrs, style: Theme.of(context).textTheme.titleMedium),
                    ...prs.map((p) {
                      final m = Map<String, dynamic>.from(p as Map);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${m['exerciseName']} — ${m['type']}'),
                        subtitle: Text('${m['value']}'),
                      );
                    }),
                    const SizedBox(height: 8),
                    Text(l10n.continueRecommendation),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: exercises.map((e) {
                    final m = Map<String, dynamic>.from(e as Map);
                    final points = (m['recentE1rmPoints'] as List?) ?? [];
                    final trend = points.length >= 2 && (points.last as num) >= (points.first as num)
                        ? l10n.progressing
                        : points.length >= 2
                            ? l10n.monitor
                            : '—';
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(m['name']?.toString() ?? ''),
                      subtitle: Text(l10n.bestProgressLine(
                        m['bestWeight'] ?? '-',
                        m['bestE1rm'] ?? '-',
                        trend,
                      )),
                    );
                  }).toList(),
                ),
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(l10n.historyHelp),
                    const SizedBox(height: 12),
                    ...exercises.map((e) {
                      final m = Map<String, dynamic>.from(e as Map);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(m['name']?.toString() ?? ''),
                        subtitle: Text(l10n.sessionsCount((m['sessionCount'] as num?)?.toInt() ?? 0)),
                      );
                    }),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
