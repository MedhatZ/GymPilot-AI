using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Options;

namespace GymCoach.TrainingEngine.Plateau;

public sealed class ExposurePerformance
{
    public decimal EstimatedOneRm { get; init; }
    public decimal TopWeightKg { get; init; }
    public int TopReps { get; init; }
    public decimal? AverageRir { get; init; }
}

public interface IPlateauDetectionEngine
{
    PlateauAssessment Assess(
        IReadOnlyList<ExposurePerformance> chronologicalExposures,
        TrainingPolicyOptions? policy = null);
}

public sealed class PlateauDetectionEngine : IPlateauDetectionEngine
{
    public PlateauAssessment Assess(
        IReadOnlyList<ExposurePerformance> chronologicalExposures,
        TrainingPolicyOptions? policy = null)
    {
        policy ??= new TrainingPolicyOptions();
        var count = chronologicalExposures.Count;
        if (count < policy.MinExposuresForPlateauMonitoring)
        {
            return new PlateauAssessment
            {
                State = PlateauState.Normal,
                Reason = "Insufficient exposures to evaluate plateau.",
                ExposureCount = count,
                E1rmTrendPercent = 0
            };
        }

        var firstHalf = chronologicalExposures.Take(count / 2).Average(e => e.EstimatedOneRm);
        var secondHalf = chronologicalExposures.Skip(count / 2).Average(e => e.EstimatedOneRm);
        var trendPct = firstHalf == 0
            ? 0
            : Math.Round((secondHalf - firstHalf) / firstHalf * 100m, 2);

        var recent = chronologicalExposures.TakeLast(policy.MinStalledExposuresForConfirmedPlateau).ToList();
        var stalled = recent.Count >= 2 &&
                      recent.Max(e => e.EstimatedOneRm) - recent.Min(e => e.EstimatedOneRm) <=
                      recent.Average(e => e.EstimatedOneRm) * 0.01m &&
                      trendPct <= policy.PlateauE1rmTrendThresholdPercent;

        var weightStalled = recent.Select(e => e.TopWeightKg).Distinct().Count() == 1;
        var repsNotProgressing = recent.Zip(recent.Skip(1), (a, b) => b.TopReps <= a.TopReps).All(x => x);

        if (count >= policy.MinExposuresForConfirmedPlateau && stalled && weightStalled && repsNotProgressing)
        {
            return new PlateauAssessment
            {
                State = PlateauState.ConfirmedPlateau,
                Reason = "Multiple recent exposures show flat e1RM, weight, and reps.",
                ExposureCount = count,
                E1rmTrendPercent = trendPct
            };
        }

        if (count >= policy.MinStalledExposuresForPossiblePlateau &&
            trendPct <= policy.PlateauE1rmTrendThresholdPercent)
        {
            return new PlateauAssessment
            {
                State = PlateauState.PossiblePlateau,
                Reason = "e1RM trend is flat or declining across recent exposures.",
                ExposureCount = count,
                E1rmTrendPercent = trendPct
            };
        }

        if (trendPct <= 0)
        {
            return new PlateauAssessment
            {
                State = PlateauState.Monitoring,
                Reason = "Progress has slowed; continue monitoring.",
                ExposureCount = count,
                E1rmTrendPercent = trendPct
            };
        }

        return new PlateauAssessment
        {
            State = PlateauState.Normal,
            Reason = "Strength trend remains positive.",
            ExposureCount = count,
            E1rmTrendPercent = trendPct
        };
    }
}
