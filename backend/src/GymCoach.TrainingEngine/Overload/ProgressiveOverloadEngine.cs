using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Options;

namespace GymCoach.TrainingEngine.Overload;

public interface IProgressiveOverloadEngine
{
    OverloadRecommendation Recommend(
        ExercisePrescription prescription,
        IReadOnlyList<WorkingSetPerformance> workingSets,
        TrainingPolicyOptions? policy = null);
}

public sealed class ProgressiveOverloadEngine : IProgressiveOverloadEngine
{
    public OverloadRecommendation Recommend(
        ExercisePrescription prescription,
        IReadOnlyList<WorkingSetPerformance> workingSets,
        TrainingPolicyOptions? policy = null)
    {
        policy ??= new TrainingPolicyOptions();
        if (workingSets.Count == 0)
        {
            return new OverloadRecommendation
            {
                SuggestedLoadKg = prescription.CurrentLoadKg,
                SuggestedReps = prescription.MinReps,
                Reason = "No working sets logged; keep current prescription.",
                Confidence = 0.5m,
                Decision = DecisionType.Continue
            };
        }

        var allAtOrAboveMax = workingSets.All(s => s.Reps >= prescription.MaxReps);
        var anyBelowMin = workingSets.Any(s => s.Reps < prescription.MinReps);
        var avgRir = workingSets.Where(s => s.Rir.HasValue).Select(s => s.Rir!.Value).DefaultIfEmpty().Average();
        var hasRir = workingSets.Any(s => s.Rir.HasValue);
        var rirOk = !hasRir || (decimal)avgRir >= policy.MinRirToProgressLoad;
        var completedAllSets = workingSets.Count >= prescription.TargetSets;

        if (completedAllSets && allAtOrAboveMax && rirOk)
        {
            var next = prescription.CurrentLoadKg + prescription.LoadIncrementKg;
            return new OverloadRecommendation
            {
                SuggestedLoadKg = next,
                SuggestedReps = prescription.MinReps,
                Reason =
                    $"All {prescription.TargetSets} working sets hit {prescription.MaxReps}+ reps with sufficient RIR; increase load by {prescription.LoadIncrementKg} kg.",
                Confidence = 0.9m,
                Decision = DecisionType.ProgressLoad
            };
        }

        if (anyBelowMin)
        {
            return new OverloadRecommendation
            {
                SuggestedLoadKg = prescription.CurrentLoadKg,
                SuggestedReps = prescription.MinReps,
                Reason = "One or more sets missed the minimum rep target; keep load and focus on completing the range.",
                Confidence = 0.85m,
                Decision = DecisionType.Continue
            };
        }

        var canProgressReps = workingSets.All(s => s.Reps < prescription.MaxReps) &&
                              workingSets.Average(s => s.Reps) >= prescription.MinReps;
        if (canProgressReps)
        {
            var nextReps = Math.Min(prescription.MaxReps,
                (int)Math.Ceiling(workingSets.Average(s => s.Reps)) + 1);
            return new OverloadRecommendation
            {
                SuggestedLoadKg = prescription.CurrentLoadKg,
                SuggestedReps = nextReps,
                Reason = "Within rep range; progress reps before increasing load.",
                Confidence = 0.8m,
                Decision = DecisionType.ProgressReps
            };
        }

        return new OverloadRecommendation
        {
            SuggestedLoadKg = prescription.CurrentLoadKg,
            SuggestedReps = prescription.MinReps,
            Reason = "Progress is incomplete for a load increase; continue current prescription.",
            Confidence = 0.75m,
            Decision = DecisionType.Continue
        };
    }
}
