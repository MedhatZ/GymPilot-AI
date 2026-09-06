import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymcoach/l10n/app_localizations.dart';

import '../../data/repositories/repository_providers.dart';

final programProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return ref.watch(programRepositoryProvider).getActiveProgram();
});

class ProgramScreen extends ConsumerWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final program = ref.watch(programProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.program)),
      body: program.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.couldNotLoadProgram)),
        data: (data) {
          if (data == null) return Center(child: Text(l10n.noActiveProgram));
          final days = (data['days'] as List?) ?? [];
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(data['name']?.toString() ?? l10n.program, style: Theme.of(context).textTheme.headlineSmall),
                Text(l10n.versionStatus(data['currentVersionNumber'] ?? '', data['status'] ?? '')),
                Text(l10n.startedAt(data['startDateUtc'] ?? '')),
                if (data['endDateUtc'] == null) Text(l10n.noEndDate),
                const SizedBox(height: 12),
                Text(l10n.whyThisProgram),
                Text(data['reason']?.toString() ?? l10n.programReasonDefault),
                const SizedBox(height: 16),
                ...days.map((d) {
                  final day = Map<String, dynamic>.from(d as Map);
                  final exercises = (day['exercises'] as List?) ?? [];
                  return ExpansionTile(
                    title: Text(day['name']?.toString() ?? l10n.dayLabel(0)),
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
            ),
          );
        },
      ),
    );
  }
}
