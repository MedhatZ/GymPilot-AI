using GymCoach.Domain.Enums;

namespace GymCoach.TrainingEngine.Options;

public sealed class TrainingPolicyOptions
{
    public const string SectionName = "TrainingPolicy";

    public decimal MinRirToProgressLoad { get; set; } = 1.0m;
    public decimal DefaultBarbellIncrementKg { get; set; } = 2.5m;
    public int MinExposuresForPlateauMonitoring { get; set; } = 3;
    public int MinExposuresForConfirmedPlateau { get; set; } = 5;
    public decimal PlateauE1rmTrendThresholdPercent { get; set; } = -1.0m;
    public int MinStalledExposuresForPossiblePlateau { get; set; } = 3;
    public int MinStalledExposuresForConfirmedPlateau { get; set; } = 5;
    public decimal MinAdherenceForNewProgram { get; set; } = 0.85m;
    public int MinProgramExposuresBeforeNewProgram { get; set; } = 12;
    public int MinKeyLiftsDecliningForGlobalFatigue { get; set; } = 3;
    public decimal DeloadVolumeMultiplier { get; set; } = 0.6m;
    public decimal DeloadLoadMultiplier { get; set; } = 0.9m;
    public decimal NewProgramMinConfidence { get; set; } = 0.8m;
}

public sealed class OverloadRecommendation
{
    public decimal? SuggestedLoadKg { get; init; }
    public int? SuggestedReps { get; init; }
    public string Reason { get; init; } = string.Empty;
    public decimal Confidence { get; init; }
    public DecisionType Decision { get; init; } = DecisionType.Continue;
}

public sealed class WorkingSetPerformance
{
    public decimal WeightKg { get; init; }
    public int Reps { get; init; }
    public decimal? Rir { get; init; }
}

public sealed class ExercisePrescription
{
    public int TargetSets { get; init; }
    public int MinReps { get; init; }
    public int MaxReps { get; init; }
    public decimal? TargetRir { get; init; }
    public decimal CurrentLoadKg { get; init; }
    public decimal LoadIncrementKg { get; init; } = 2.5m;
}

public sealed class PlateauAssessment
{
    public PlateauState State { get; init; }
    public string Reason { get; init; } = string.Empty;
    public int ExposureCount { get; init; }
    public decimal E1rmTrendPercent { get; init; }
}

public sealed class ProgramDecisionSuggestion
{
    public DecisionType Decision { get; init; }
    public DecisionScope Scope { get; init; }
    public string Reason { get; init; } = string.Empty;
    public decimal Confidence { get; init; }
    public Guid? ExerciseId { get; init; }
}
