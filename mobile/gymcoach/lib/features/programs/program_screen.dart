import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';

final programProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final res = await ref.watch(apiClientProvider).dio.get('/api/programs/active');
    return Map<String, dynamic>.from(res.data as Map);
  } catch (_) {
    return null;
  }
});

class ProgramScreen extends ConsumerWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(programProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Program')),
      body: program.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (data) {
          if (data == null) return const Center(child: Text('No active program'));
          final days = (data['days'] as List?) ?? [];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(data['name']?.toString() ?? 'Program', style: Theme.of(context).textTheme.headlineSmall),
              Text('Version ${data['currentVersionNumber']} · ${data['status']}'),
              Text('Started ${data['startDateUtc']}'),
              if (data['endDateUtc'] == null)
                const Text('No end date — continues while you progress.'),
              const SizedBox(height: 12),
              const Text('Why this program?'),
              const Text('Generated from your profile, goals, schedule, and equipment. Changes are evidence-based, not calendar-based.'),
              const SizedBox(height: 16),
              ...days.map((d) {
                final day = Map<String, dynamic>.from(d as Map);
                final exercises = (day['exercises'] as List?) ?? [];
                return ExpansionTile(
                  title: Text(day['name']?.toString() ?? 'Day'),
                  subtitle: Text(day['split']?.toString() ?? ''),
                  children: exercises.map((e) {
                    final ex = Map<String, dynamic>.from(e as Map);
                    return ListTile(
                      title: Text(ex['exerciseName']?.toString() ?? ''),
                      subtitle: Text(
                        '${ex['sets']} × ${ex['minReps']}-${ex['maxReps']} · rest ${ex['restSeconds']}s'
                        '${ex['targetRir'] != null ? ' · RIR ${ex['targetRir']}' : ''}',
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
