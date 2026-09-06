import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';

final progressProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final res = await ref.watch(apiClientProvider).dio.get('/api/progress');
    return Map<String, dynamic>.from(res.data as Map);
  } catch (_) {
    return null;
  }
});

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Progress'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Exercises'),
            Tab(text: 'History'),
          ]),
        ),
        body: progress.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (data) {
            if (data == null) {
              return const Center(child: Text('Connect to API or keep logging offline to build history.'));
            }
            final exercises = (data['exercises'] as List?) ?? [];
            final prs = (data['recentPrs'] as List?) ?? [];
            final recovery = data['recovery'] as Map?;
            return TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('Sessions tracked: ${exercises.length} lifts'),
                    if (recovery != null) Text('Readiness: ${recovery['readinessScore']} (${recovery['label']})'),
                    const SizedBox(height: 12),
                    Text('Recent PRs', style: Theme.of(context).textTheme.titleMedium),
                    ...prs.map((p) {
                      final m = Map<String, dynamic>.from(p as Map);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${m['exerciseName']} — ${m['type']}'),
                        subtitle: Text('${m['value']}'),
                      );
                    }),
                    const SizedBox(height: 8),
                    const Text('Recommendation: CONTINUE while progression remains positive. No calendar expiration.'),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: exercises.map((e) {
                    final m = Map<String, dynamic>.from(e as Map);
                    final points = (m['recentE1rmPoints'] as List?) ?? [];
                    final trend = points.length >= 2 && (points.last as num) >= (points.first as num)
                        ? '↑ progressing'
                        : points.length >= 2
                            ? '→ monitor'
                            : '—';
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(m['name']?.toString() ?? ''),
                      subtitle: Text('Best ${m['bestWeight'] ?? '-'} kg · e1RM ${m['bestE1rm'] ?? '-'} · $trend'),
                    );
                  }).toList(),
                ),
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('Completed workouts appear after you finish sessions. History is built from real logged work only.'),
                    const SizedBox(height: 12),
                    ...exercises.map((e) {
                      final m = Map<String, dynamic>.from(e as Map);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(m['name']?.toString() ?? ''),
                        subtitle: Text('${m['sessionCount']} sessions'),
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
