using GymCoach.Domain.Common;
using GymCoach.Domain.Enums;

namespace GymCoach.Domain.Entities;

public class PersonalRecord : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public Guid ExerciseId { get; set; }
    public PersonalRecordType RecordType { get; set; }
    public decimal Value { get; set; }
    public DateTime AchievedAtUtc { get; set; }
    public Guid? WorkoutSetId { get; set; }
}

public class ExerciseMetricSnapshot : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public Guid ExerciseId { get; set; }
    public DateTime AsOfUtc { get; set; }
    public decimal? EstimatedOneRepMax { get; set; }
    public decimal? TopSetWeightKg { get; set; }
    public int? TopSetReps { get; set; }
    public decimal? SessionVolume { get; set; }
    public decimal? AverageRir { get; set; }
    public int ExposureCount { get; set; }
    public PlateauState PlateauState { get; set; } = PlateauState.Normal;
    public TrendDirection StrengthTrend { get; set; } = TrendDirection.Stable;
}

public class RecoveryMetric : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public DateTime AsOfUtc { get; set; }
    public decimal ReadinessScore { get; set; }
    public string TrendLabel { get; set; } = "unknown";
    public string InputsJson { get; set; } = "{}";
    public string? Notes { get; set; }
}

public class WearableConnection : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public string Provider { get; set; } = "Huawei";
    public bool IsConnected { get; set; }
    public DateTime? LastSyncedAtUtc { get; set; }
    public string? ScopesGranted { get; set; }
}

public class WearableDailyMetric : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public DateOnly Date { get; set; }
    public int? RestingHeartRate { get; set; }
    public int? AverageHeartRate { get; set; }
    public int? StressScore { get; set; }
    public decimal? Spo2Percent { get; set; }
    public int? Steps { get; set; }
    public int? ActiveCalories { get; set; }
    public string Provider { get; set; } = "Huawei";
}

public class SleepMetric : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public DateOnly Date { get; set; }
    public decimal DurationHours { get; set; }
    public string? QualityLabel { get; set; }
    public string Provider { get; set; } = "Huawei";
}

public class AIAnalysis : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public Guid? ProgramId { get; set; }
    public string ContextJson { get; set; } = "{}";
    public string? ModelName { get; set; }
}

public class AIRecommendation : AuditableEntity
{
    public Guid AIAnalysisId { get; set; }
    public AIAnalysis? Analysis { get; set; }
    public DecisionType Decision { get; set; }
    public DecisionScope Scope { get; set; }
    public decimal Confidence { get; set; }
    public string Reason { get; set; } = string.Empty;
    public Guid? ExerciseId { get; set; }
    public Guid? ReplacementExerciseId { get; set; }
    public string ChangesJson { get; set; } = "[]";
    public string RawResponseJson { get; set; } = "{}";
}

public class ProgramDecision : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public Guid? ProgramId { get; set; }
    public Guid? ProgramVersionId { get; set; }
    public DecisionType FinalDecision { get; set; }
    public DecisionScope Scope { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string InputMetricsJson { get; set; } = "{}";
    public string RuleEngineResultJson { get; set; } = "{}";
    public Guid? AiRecommendationId { get; set; }
    public PolicyValidationResult PolicyResult { get; set; }
    public string PolicyNotes { get; set; } = string.Empty;
    public bool WasApplied { get; set; }
}

public class IdempotencyRecord : AuditableEntity
{
    public string UserId { get; set; } = string.Empty;
    public string Key { get; set; } = string.Empty;
    public string RequestHash { get; set; } = string.Empty;
    public int StatusCode { get; set; }
    public string ResponseBody { get; set; } = string.Empty;
}
