using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Options;

namespace GymCoach.TrainingEngine.Decisions;

public sealed class ExerciseTrendSummary
{
    public Guid ExerciseId { get; init; }
    public bool IsKeyLift { get; init; }
    public PlateauState PlateauState { get; init; }
    public TrendDirection StrengthTrend { get; init; }
    public int ExposureCount { get; init; }
    public decimal E1rmTrendPercent { get; init; }
}

public sealed class ProgramDecisionInput
{
    public int ProgramExposureCount { get; init; }
    public decimal Adherence { get; init; }
    public TrendDirection OverallStrengthTrend { get; init; }
    public bool AdequateRecovery { get; init; } = true;
    public bool PriorMinorAdjustmentsTried { get; init; }
    public bool DeloadAlreadyTried { get; init; }
    public IReadOnlyList<ExerciseTrendSummary> Exercises { get; init; } = Array.Empty<ExerciseTrendSummary>();
    public bool AccumulatedFatigueLikely { get; init; }
}

public interface IProgramDecisionEngine
{
    ProgramDecisionSuggestion Decide(ProgramDecisionInput input, TrainingPolicyOptions? policy = null);
}

public sealed class ProgramDecisionEngine : IProgramDecisionEngine
{
    public ProgramDecisionSuggestion Decide(ProgramDecisionInput input, TrainingPolicyOptions? policy = null)
    {
        policy ??= new TrainingPolicyOptions();

        if (input.OverallStrengthTrend == TrendDirection.Positive &&
            input.Exercises.All(e => e.PlateauState is PlateauState.Normal or PlateauState.Monitoring))
        {
            return new ProgramDecisionSuggestion
            {
                Decision = DecisionType.Continue,
                Scope = DecisionScope.Program,
                Reason = "Overall strength progression remains positive.",
                Confidence = 0.92m
            };
        }

        var decliningKeys = input.Exercises.Count(e =>
            e.IsKeyLift && e.StrengthTrend == TrendDirection.Declining);
        if (input.AccumulatedFatigueLikely ||
            decliningKeys >= policy.MinKeyLiftsDecliningForGlobalFatigue)
        {
            return new ProgramDecisionSuggestion
            {
                Decision = DecisionType.Deload,
                Scope = DecisionScope.Program,
                Reason = "Multiple key lifts declining with fatigue signals; recommend deload, not a new program.",
                Confidence = 0.88m
            };
        }

        var confirmed = input.Exercises.Where(e => e.PlateauState == PlateauState.ConfirmedPlateau).ToList();
        if (confirmed.Count == 1)
        {
            return new ProgramDecisionSuggestion
            {
                Decision = DecisionType.ChangeRepRange,
                Scope = DecisionScope.Exercise,
                ExerciseId = confirmed[0].ExerciseId,
                Reason = "Single-exercise plateau; adjust that exercise only.",
                Confidence = 0.84m
            };
        }

        if (confirmed.Count >= policy.MinKeyLiftsDecliningForGlobalFatigue &&
            input.Adherence >= policy.MinAdherenceForNewProgram &&
            input.AdequateRecovery &&
            input.PriorMinorAdjustmentsTried &&
            input.DeloadAlreadyTried &&
            input.ProgramExposureCount >= policy.MinProgramExposuresBeforeNewProgram)
        {
            return new ProgramDecisionSuggestion
            {
                Decision = DecisionType.ProgramAdjustment,
                Scope = DecisionScope.Program,
                Reason =
                    "Persistent multi-exercise plateaus after adjustments and deload; consider program adjustment.",
                Confidence = 0.8m
            };
        }

        if (confirmed.Count >= 2)
        {
            return new ProgramDecisionSuggestion
            {
                Decision = DecisionType.ReduceVolume,
                Scope = DecisionScope.Program,
                Reason = "Several plateaus present; reduce volume before replacing the program.",
                Confidence = 0.78m
            };
        }

        return new ProgramDecisionSuggestion
        {
            Decision = DecisionType.Continue,
            Scope = DecisionScope.Program,
            Reason = "Evidence does not justify a structural program change.",
            Confidence = 0.7m
        };
    }
}

public interface ITrainingPolicyValidator
{
    (PolicyValidationResult Result, DecisionType FinalDecision, string Notes) Validate(
        DecisionType proposed,
        DecisionScope scope,
        ProgramDecisionInput context,
        decimal confidence,
        TrainingPolicyOptions? policy = null);
}

public sealed class TrainingPolicyValidator : ITrainingPolicyValidator
{
    private readonly IProgramDecisionEngine _rules;

    public TrainingPolicyValidator(IProgramDecisionEngine rules)
    {
        _rules = rules;
    }

    public (PolicyValidationResult Result, DecisionType FinalDecision, string Notes) Validate(
        DecisionType proposed,
        DecisionScope scope,
        ProgramDecisionInput context,
        decimal confidence,
        TrainingPolicyOptions? policy = null)
    {
        policy ??= new TrainingPolicyOptions();
        var deterministic = _rules.Decide(context, policy);

        if (proposed == DecisionType.NewProgram)
        {
            if (context.OverallStrengthTrend == TrendDirection.Positive)
            {
                return (PolicyValidationResult.Rejected, DecisionType.Continue,
                    "Rejected NEW_PROGRAM: overall progression is positive.");
            }

            if (context.ProgramExposureCount < policy.MinProgramExposuresBeforeNewProgram)
            {
                return (PolicyValidationResult.Downgraded, DecisionType.Continue,
                    "Downgraded NEW_PROGRAM: insufficient exposures on current program version.");
            }

            if (!context.AdequateRecovery || context.Adherence < policy.MinAdherenceForNewProgram)
            {
                return (PolicyValidationResult.Downgraded, DecisionType.Deload,
                    "Downgraded NEW_PROGRAM: recovery/adherence insufficient; prefer deload/adjust.");
            }

            if (!context.DeloadAlreadyTried)
            {
                return (PolicyValidationResult.Downgraded, DecisionType.Deload,
                    "Downgraded NEW_PROGRAM: deload not yet tried.");
            }

            if (confidence < policy.NewProgramMinConfidence)
            {
                return (PolicyValidationResult.Downgraded, DecisionType.ProgramAdjustment,
                    "Downgraded NEW_PROGRAM: confidence below threshold.");
            }
        }

        if (proposed == DecisionType.NewProgram &&
            deterministic.Decision is DecisionType.Continue or DecisionType.Deload or DecisionType.ProgramAdjustment)
        {
            return (PolicyValidationResult.Downgraded, deterministic.Decision,
                $"Downgraded NEW_PROGRAM to {deterministic.Decision} per deterministic policy.");
        }

        if (scope == DecisionScope.Program &&
            proposed == DecisionType.ReplaceExercise)
        {
            return (PolicyValidationResult.Downgraded, DecisionType.ReplaceExercise,
                "Replace exercise should be exercise-scoped; keeping decision with note.");
        }

        return (PolicyValidationResult.Approved, proposed, "Approved.");
    }
}
