namespace GymCoach.TrainingEngine.Metrics;

public interface IEstimatedOneRepMaxCalculator
{
    decimal Calculate(decimal weightKg, int reps);
}

/// <summary>Epley formula: weight * (1 + reps/30). Isolated for future replacement.</summary>
public sealed class EpleyOneRepMaxCalculator : IEstimatedOneRepMaxCalculator
{
    public decimal Calculate(decimal weightKg, int reps)
    {
        if (weightKg < 0) throw new ArgumentOutOfRangeException(nameof(weightKg));
        if (reps <= 0) throw new ArgumentOutOfRangeException(nameof(reps));
        if (reps == 1) return weightKg;
        return Math.Round(weightKg * (1m + reps / 30m), 2, MidpointRounding.AwayFromZero);
    }
}

public sealed class SetMetricInput
{
    public Guid ExerciseId { get; init; }
    public decimal WeightKg { get; init; }
    public int Reps { get; init; }
    public decimal? Rir { get; init; }
    public bool IsWorkingSet { get; init; } = true;
    public IReadOnlyList<Guid> PrimaryMuscleGroupIds { get; init; } = Array.Empty<Guid>();
}

public sealed class SessionMetricsResult
{
    public decimal TotalVolume { get; init; }
    public IReadOnlyDictionary<Guid, decimal> VolumeByExercise { get; init; } =
        new Dictionary<Guid, decimal>();
    public IReadOnlyDictionary<Guid, decimal> VolumeByMuscleGroup { get; init; } =
        new Dictionary<Guid, decimal>();
    public IReadOnlyDictionary<Guid, decimal> EstimatedOneRmByExercise { get; init; } =
        new Dictionary<Guid, decimal>();
    public decimal? AverageRir { get; init; }
    public int WorkingSetCount { get; init; }
}

public interface ITrainingMetricsEngine
{
    SessionMetricsResult CalculateSessionMetrics(IEnumerable<SetMetricInput> sets);
    decimal CalculateVolume(decimal weightKg, int reps);
}

public sealed class TrainingMetricsEngine : ITrainingMetricsEngine
{
    private readonly IEstimatedOneRepMaxCalculator _oneRm;

    public TrainingMetricsEngine(IEstimatedOneRepMaxCalculator oneRm)
    {
        _oneRm = oneRm;
    }

    public decimal CalculateVolume(decimal weightKg, int reps) => weightKg * reps;

    public SessionMetricsResult CalculateSessionMetrics(IEnumerable<SetMetricInput> sets)
    {
        var working = sets.Where(s => s.IsWorkingSet).ToList();
        var volumeByExercise = new Dictionary<Guid, decimal>();
        var volumeByMuscle = new Dictionary<Guid, decimal>();
        var e1rmByExercise = new Dictionary<Guid, decimal>();
        decimal total = 0;
        var rirs = new List<decimal>();

        foreach (var set in working)
        {
            var vol = CalculateVolume(set.WeightKg, set.Reps);
            total += vol;
            volumeByExercise[set.ExerciseId] = volumeByExercise.GetValueOrDefault(set.ExerciseId) + vol;
            foreach (var mg in set.PrimaryMuscleGroupIds)
                volumeByMuscle[mg] = volumeByMuscle.GetValueOrDefault(mg) + vol;

            var e1rm = _oneRm.Calculate(set.WeightKg, set.Reps);
            if (!e1rmByExercise.TryGetValue(set.ExerciseId, out var existing) || e1rm > existing)
                e1rmByExercise[set.ExerciseId] = e1rm;

            if (set.Rir.HasValue) rirs.Add(set.Rir.Value);
        }

        return new SessionMetricsResult
        {
            TotalVolume = total,
            VolumeByExercise = volumeByExercise,
            VolumeByMuscleGroup = volumeByMuscle,
            EstimatedOneRmByExercise = e1rmByExercise,
            AverageRir = rirs.Count == 0 ? null : Math.Round(rirs.Average(), 2),
            WorkingSetCount = working.Count
        };
    }
}
