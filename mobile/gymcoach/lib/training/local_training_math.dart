/// Deterministic local training math — mirrors backend Training Engine intent.
class LocalTrainingMath {
  const LocalTrainingMath();

  /// Epley e1RM.
  double e1rm(double weightKg, int reps) {
    if (reps <= 0) return 0;
    if (reps == 1) return weightKg;
    return weightKg * (1 + reps / 30.0);
  }

  OverloadSuggestion suggestNext({
    required int targetSets,
    required int minReps,
    required int maxReps,
    required double currentLoadKg,
    required double loadIncrementKg,
    required List<WorkingSetSample> lastWorkingSets,
    double minRirToProgress = 1.0,
  }) {
    if (lastWorkingSets.isEmpty) {
      return OverloadSuggestion(
        suggestedLoadKg: currentLoadKg > 0 ? currentLoadKg : null,
        suggestedReps: minReps,
        reason: 'No working sets logged; keep current prescription.',
        decision: 'CONTINUE',
        confidence: 0.5,
      );
    }

    final allAtOrAboveMax = lastWorkingSets.every((s) => s.reps >= maxReps);
    final anyBelowMin = lastWorkingSets.any((s) => s.reps < minReps);
    final withRir = lastWorkingSets.where((s) => s.rir != null).toList();
    final avgRir = withRir.isEmpty
        ? null
        : withRir.map((s) => s.rir!).reduce((a, b) => a + b) / withRir.length;
    final rirOk = avgRir == null || avgRir >= minRirToProgress;
    final completedAllSets = lastWorkingSets.length >= targetSets;

    if (completedAllSets && allAtOrAboveMax && rirOk) {
      final next = currentLoadKg + loadIncrementKg;
      return OverloadSuggestion(
        suggestedLoadKg: next,
        suggestedReps: minReps,
        reason:
            'All $targetSets working sets hit $maxReps+ reps with sufficient RIR; increase load by $loadIncrementKg kg.',
        decision: 'PROGRESS_LOAD',
        confidence: 0.9,
      );
    }

    if (anyBelowMin) {
      return OverloadSuggestion(
        suggestedLoadKg: currentLoadKg,
        suggestedReps: minReps,
        reason: 'One or more sets missed the minimum rep target; keep load.',
        decision: 'CONTINUE',
        confidence: 0.85,
      );
    }

    final avgReps =
        lastWorkingSets.map((s) => s.reps).reduce((a, b) => a + b) / lastWorkingSets.length;
    if (lastWorkingSets.every((s) => s.reps < maxReps) && avgReps >= minReps) {
      final nextReps = (avgReps.ceil() + 1).clamp(minReps, maxReps);
      return OverloadSuggestion(
        suggestedLoadKg: currentLoadKg,
        suggestedReps: nextReps,
        reason: 'Within rep range; progress reps before increasing load.',
        decision: 'PROGRESS_REPS',
        confidence: 0.8,
      );
    }

    return OverloadSuggestion(
      suggestedLoadKg: currentLoadKg,
      suggestedReps: minReps,
      reason: 'Hold prescription; keep logging consistent working sets.',
      decision: 'CONTINUE',
      confidence: 0.7,
    );
  }

  PlateauAssessment assessPlateau(List<double> chronologicalE1rms) {
    final count = chronologicalE1rms.length;
    if (count < 3) {
      return const PlateauAssessment(state: 'Normal', trendPercent: 0, reason: 'Insufficient exposures.');
    }
    final mid = count ~/ 2;
    final first = chronologicalE1rms.take(mid).fold<double>(0, (a, b) => a + b) / mid;
    final second = chronologicalE1rms.skip(mid).fold<double>(0, (a, b) => a + b) / (count - mid);
    final trend = first == 0 ? 0.0 : ((second - first) / first) * 100;
    if (count >= 5 && trend <= 0.5) {
      return PlateauAssessment(
        state: 'PossiblePlateau',
        trendPercent: trend,
        reason: 'e1RM trend is flat or declining across recent exposures.',
      );
    }
    if (trend > 1) {
      return PlateauAssessment(state: 'Normal', trendPercent: trend, reason: 'Strength trend remains positive.');
    }
    return PlateauAssessment(state: 'Monitoring', trendPercent: trend, reason: 'Progress has slowed; continue monitoring.');
  }
}

class WorkingSetSample {
  const WorkingSetSample({required this.weightKg, required this.reps, this.rir});
  final double weightKg;
  final int reps;
  final double? rir;
}

class OverloadSuggestion {
  const OverloadSuggestion({
    required this.suggestedLoadKg,
    required this.suggestedReps,
    required this.reason,
    required this.decision,
    required this.confidence,
  });
  final double? suggestedLoadKg;
  final int suggestedReps;
  final String reason;
  final String decision;
  final double confidence;
}

class PlateauAssessment {
  const PlateauAssessment({
    required this.state,
    required this.trendPercent,
    required this.reason,
  });
  final String state;
  final double trendPercent;
  final String reason;
}
