using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Decisions;
using GymCoach.TrainingEngine.Metrics;
using GymCoach.TrainingEngine.Options;
using GymCoach.TrainingEngine.Overload;
using GymCoach.TrainingEngine.Plateau;
using GymCoach.TrainingEngine.Recovery;

namespace GymCoach.TrainingEngine.Tests;

public class EpleyOneRepMaxCalculatorTests
{
    private readonly EpleyOneRepMaxCalculator _sut = new();

    [Fact]
    public void Single_rep_returns_weight() => Assert.Equal(100m, _sut.Calculate(100, 1));

    [Fact]
    public void Multi_rep_uses_epley() => Assert.Equal(133.33m, _sut.Calculate(100, 10));
}

public class ProgressiveOverloadEngineTests
{
    private readonly ProgressiveOverloadEngine _sut = new();

    [Fact]
    public void Progresses_load_when_all_sets_hit_max_reps()
    {
        var prescription = new ExercisePrescription
        {
            TargetSets = 3,
            MinReps = 6,
            MaxReps = 8,
            CurrentLoadKg = 80,
            LoadIncrementKg = 2.5m
        };
        var sets = Enumerable.Range(0, 3)
            .Select(_ => new WorkingSetPerformance { WeightKg = 80, Reps = 8, Rir = 2 })
            .ToList();

        var result = _sut.Recommend(prescription, sets);
        Assert.Equal(DecisionType.ProgressLoad, result.Decision);
        Assert.Equal(82.5m, result.SuggestedLoadKg);
    }

    [Fact]
    public void Holds_load_when_reps_miss_minimum()
    {
        var prescription = new ExercisePrescription
        {
            TargetSets = 3,
            MinReps = 6,
            MaxReps = 8,
            CurrentLoadKg = 80,
            LoadIncrementKg = 2.5m
        };
        var sets = new List<WorkingSetPerformance>
        {
            new() { WeightKg = 80, Reps = 5, Rir = 0 },
            new() { WeightKg = 80, Reps = 6, Rir = 1 },
            new() { WeightKg = 80, Reps = 6, Rir = 1 }
        };

        var result = _sut.Recommend(prescription, sets);
        Assert.Equal(DecisionType.Continue, result.Decision);
        Assert.Equal(80m, result.SuggestedLoadKg);
    }
}

public class PlateauDetectionEngineTests
{
    private readonly PlateauDetectionEngine _sut = new();

    [Fact]
    public void Single_exposure_is_not_a_plateau()
    {
        var result = _sut.Assess([new ExposurePerformance { EstimatedOneRm = 100, TopWeightKg = 80, TopReps = 5 }]);
        Assert.Equal(PlateauState.Normal, result.State);
    }

    [Fact]
    public void Flat_multi_exposure_can_confirm_plateau()
    {
        var exposures = Enumerable.Range(0, 6)
            .Select(_ => new ExposurePerformance { EstimatedOneRm = 100, TopWeightKg = 80, TopReps = 5 })
            .ToList();
        var result = _sut.Assess(exposures);
        Assert.True(result.State is PlateauState.PossiblePlateau or PlateauState.ConfirmedPlateau or PlateauState.Monitoring);
    }
}

public class ProgramDecisionAndPolicyTests
{
    private readonly ProgramDecisionEngine _rules = new();
    private readonly TrainingPolicyValidator _policy;

    public ProgramDecisionAndPolicyTests() => _policy = new TrainingPolicyValidator(_rules);

    [Fact]
    public void Positive_progress_continues()
    {
        var decision = _rules.Decide(new ProgramDecisionInput
        {
            OverallStrengthTrend = TrendDirection.Positive,
            Adherence = 0.95m,
            ProgramExposureCount = 20,
            Exercises =
            [
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
        Assert.Equal(DecisionType.Continue, decision.Decision);
    }

    [Fact]
    public void Policy_rejects_new_program_when_progress_positive()
    {
        var input = new ProgramDecisionInput
        {
            OverallStrengthTrend = TrendDirection.Positive,
            Adherence = 0.95m,
            ProgramExposureCount = 20,
            AdequateRecovery = true,
            DeloadAlreadyTried = true,
            PriorMinorAdjustmentsTried = true
        };
        var (result, final, _) = _policy.Validate(DecisionType.NewProgram, DecisionScope.Program, input, 0.9m);
        Assert.Equal(PolicyValidationResult.Rejected, result);
        Assert.Equal(DecisionType.Continue, final);
    }

    [Fact]
    public void Policy_downgrades_new_program_when_young()
    {
        var input = new ProgramDecisionInput
        {
            OverallStrengthTrend = TrendDirection.Stable,
            Adherence = 0.95m,
            ProgramExposureCount = 3,
            AdequateRecovery = true
        };
        var (result, final, _) = _policy.Validate(DecisionType.NewProgram, DecisionScope.Program, input, 0.9m);
        Assert.Equal(PolicyValidationResult.Downgraded, result);
        Assert.NotEqual(DecisionType.NewProgram, final);
    }
}

public class PersonalRecordDetectorTests
{
    [Fact]
    public void Detects_weight_pr()
    {
        var sut = new PersonalRecordDetector();
        var id = Guid.NewGuid();
        var prs = sut.Detect(id, [(80, 5, 93)], 85, 5, 99);
        Assert.Contains(prs, p => p.Type == PersonalRecordType.Weight);
        Assert.Contains(prs, p => p.Type == PersonalRecordType.EstimatedOneRepMax);
    }
}

public class MetricsEngineTests
{
    [Fact]
    public void Calculates_volume_and_e1rm()
    {
        var sut = new TrainingMetricsEngine(new EpleyOneRepMaxCalculator());
        var ex = Guid.NewGuid();
        var result = sut.CalculateSessionMetrics(
        [
            new SetMetricInput { ExerciseId = ex, WeightKg = 100, Reps = 5, IsWorkingSet = true },
            new SetMetricInput { ExerciseId = ex, WeightKg = 60, Reps = 10, IsWorkingSet = false }
        ]);
        Assert.Equal(500m, result.TotalVolume);
        Assert.Equal(1, result.WorkingSetCount);
        Assert.True(result.EstimatedOneRmByExercise[ex] > 100);
    }
}
