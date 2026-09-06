using GymCoach.Domain.Enums;

namespace GymCoach.TrainingEngine.Recovery;

public sealed class RecoveryInput
{
    public decimal? SleepHoursLastNight { get; init; }
    public TrendDirection SleepTrend { get; init; } = TrendDirection.Stable;
    public int? RestingHeartRate { get; init; }
    public TrendDirection RestingHrTrend { get; init; } = TrendDirection.Stable;
    public int? StressScore { get; init; }
    public decimal RecentTrainingLoadIndex { get; init; }
    public int SessionsLast7Days { get; init; }
    public WorkoutDifficulty? LastSessionDifficulty { get; init; }
    public decimal? AverageRecentRir { get; init; }
    public bool HasWearableData { get; init; }
}

public sealed class RecoveryAssessment
{
    public decimal ReadinessScore { get; init; }
    public string Label { get; init; } = "moderate";
    public string Summary { get; init; } = string.Empty;
    public bool FatigueLikely { get; init; }
}

public interface IRecoveryModel
{
    RecoveryAssessment Assess(RecoveryInput input);
}

public sealed class RecoveryModel : IRecoveryModel
{
    public RecoveryAssessment Assess(RecoveryInput input)
    {
        decimal score = 70;

        if (input.HasWearableData)
        {
            if (input.SleepHoursLastNight is >= 7 and <= 9) score += 10;
            else if (input.SleepHoursLastNight < 6) score -= 15;

            if (input.RestingHrTrend == TrendDirection.Positive) score -= 8; // rising RHR = worse
            if (input.SleepTrend == TrendDirection.Declining) score -= 8;
            if (input.StressScore is > 70) score -= 10;
        }

        if (input.SessionsLast7Days >= 6) score -= 8;
        if (input.RecentTrainingLoadIndex > 1.2m) score -= 10;
        if (input.LastSessionDifficulty is WorkoutDifficulty.VeryHard) score -= 5;
        if (input.AverageRecentRir is < 1) score -= 5;

        score = Math.Clamp(score, 0, 100);
        var fatigue = score < 45 ||
                      (input.RestingHrTrend == TrendDirection.Positive &&
                       input.SleepTrend == TrendDirection.Declining &&
                       input.RecentTrainingLoadIndex > 1.1m);

        var label = score switch
        {
            >= 75 => "high",
            >= 55 => "moderate",
            _ => "low"
        };

        return new RecoveryAssessment
        {
            ReadinessScore = score,
            Label = label,
            FatigueLikely = fatigue,
            Summary = input.HasWearableData
                ? $"Readiness {score:0} ({label}) using training + wearable signals."
                : $"Readiness {score:0} ({label}) from training-only signals (wearable unavailable)."
        };
    }
}

public sealed class PersonalRecordCandidate
{
    public Guid ExerciseId { get; init; }
    public PersonalRecordType Type { get; init; }
    public decimal Value { get; init; }
}

public interface IPersonalRecordDetector
{
    IReadOnlyList<PersonalRecordCandidate> Detect(
        Guid exerciseId,
        IEnumerable<(decimal Weight, int Reps, decimal E1rm)> historicalWorkingSets,
        decimal newWeight,
        int newReps,
        decimal newE1rm);
}

public sealed class PersonalRecordDetector : IPersonalRecordDetector
{
    public IReadOnlyList<PersonalRecordCandidate> Detect(
        Guid exerciseId,
        IEnumerable<(decimal Weight, int Reps, decimal E1rm)> historicalWorkingSets,
        decimal newWeight,
        int newReps,
        decimal newE1rm)
    {
        var hist = historicalWorkingSets.ToList();
        var results = new List<PersonalRecordCandidate>();
        var bestWeight = hist.Count == 0 ? 0 : hist.Max(h => h.Weight);
        var bestRepsAtWeight = hist.Where(h => h.Weight == newWeight).Select(h => h.Reps).DefaultIfEmpty(0).Max();
        var bestE1rm = hist.Count == 0 ? 0 : hist.Max(h => h.E1rm);

        if (newWeight > bestWeight)
        {
            results.Add(new PersonalRecordCandidate
            {
                ExerciseId = exerciseId,
                Type = PersonalRecordType.Weight,
                Value = newWeight
            });
        }

        if (newWeight >= bestWeight && newReps > bestRepsAtWeight)
        {
            results.Add(new PersonalRecordCandidate
            {
                ExerciseId = exerciseId,
                Type = PersonalRecordType.Reps,
                Value = newReps
            });
        }

        if (newE1rm > bestE1rm)
        {
            results.Add(new PersonalRecordCandidate
            {
                ExerciseId = exerciseId,
                Type = PersonalRecordType.EstimatedOneRepMax,
                Value = newE1rm
            });
        }

        return results;
    }
}
