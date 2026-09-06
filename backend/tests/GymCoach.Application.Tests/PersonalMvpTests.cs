using GymCoach.Application.Personal;
using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Decisions;
using GymCoach.TrainingEngine.Options;
using GymCoach.TrainingEngine.Overload;

namespace GymCoach.Application.Tests;

public class PersonalModeOptionsTests
{
    [Fact]
    public void Personal_mode_defaults_enabled()
    {
        var options = new PersonalModeOptions();
        Assert.True(options.Enabled);
        Assert.Contains("gymcoach.local", options.DefaultEmail);
    }
}

public class ProgressiveLoadReasonTests
{
    [Fact]
    public void Overload_recommendation_includes_reason()
    {
        var engine = new ProgressiveOverloadEngine();
        var result = engine.Recommend(
            new ExercisePrescription
            {
                TargetSets = 3,
                MinReps = 6,
                MaxReps = 8,
                CurrentLoadKg = 80,
                LoadIncrementKg = 2.5m
            },
            Enumerable.Range(0, 3)
                .Select(_ => new WorkingSetPerformance { WeightKg = 80, Reps = 8, Rir = 2 })
                .ToList());

        Assert.Equal(DecisionType.ProgressLoad, result.Decision);
        Assert.False(string.IsNullOrWhiteSpace(result.Reason));
        Assert.Equal(82.5m, result.SuggestedLoadKg);
    }
}

public class ProgramContinuePolicyTests
{
    [Fact]
    public void Positive_progression_stays_continue_not_new_program()
    {
        var rules = new ProgramDecisionEngine();
        var policy = new TrainingPolicyValidator(rules);
        var input = new ProgramDecisionInput
        {
            OverallStrengthTrend = TrendDirection.Positive,
            Adherence = 0.95m,
            ProgramExposureCount = 40,
            AdequateRecovery = true,
            DeloadAlreadyTried = true,
            PriorMinorAdjustmentsTried = true,
            Exercises =
            [
                new ExerciseTrendSummary
                {
                    ExerciseId = Guid.NewGuid(),
                    IsKeyLift = true,
                    PlateauState = PlateauState.Normal,
                    StrengthTrend = TrendDirection.Positive,
                    ExposureCount = 12
                }
            ]
        };

        var decision = rules.Decide(input);
        Assert.Equal(DecisionType.Continue, decision.Decision);

        var (result, finalDecision, _) =
            policy.Validate(DecisionType.NewProgram, DecisionScope.Program, input, 0.99m);
        Assert.Equal(PolicyValidationResult.Rejected, result);
        Assert.Equal(DecisionType.Continue, finalDecision);
    }

    [Fact]
    public void Single_exercise_plateau_does_not_replace_program()
    {
        var rules = new ProgramDecisionEngine();
        var exId = Guid.NewGuid();
        var decision = rules.Decide(new ProgramDecisionInput
        {
            OverallStrengthTrend = TrendDirection.Stable,
            Adherence = 0.9m,
            ProgramExposureCount = 20,
            Exercises =
            [
                new ExerciseTrendSummary
                {
                    ExerciseId = exId,
                    IsKeyLift = true,
                    PlateauState = PlateauState.ConfirmedPlateau,
                    StrengthTrend = TrendDirection.Stable,
                    ExposureCount = 8
                },
                new ExerciseTrendSummary
                {
                    ExerciseId = Guid.NewGuid(),
                    IsKeyLift = true,
                    PlateauState = PlateauState.Normal,
                    StrengthTrend = TrendDirection.Positive,
                    ExposureCount = 8
                }
            ]
        });

        Assert.NotEqual(DecisionType.NewProgram, decision.Decision);
        Assert.Equal(DecisionScope.Exercise, decision.Scope);
        Assert.Equal(exId, decision.ExerciseId);
    }
}
