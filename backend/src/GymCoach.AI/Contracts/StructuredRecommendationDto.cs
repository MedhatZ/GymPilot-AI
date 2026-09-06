using System.Text.Json.Serialization;
using GymCoach.Domain.Enums;

namespace GymCoach.AI.Contracts;

public static class AiProviderSources
{
    public const string OpenAi = "OPENAI";
    public const string TrainingEngine = "TRAINING_ENGINE";
}

public sealed class StructuredRecommendationDto
{
    [JsonPropertyName("decision")]
    public string Decision { get; set; } = "CONTINUE";

    [JsonPropertyName("scope")]
    public string Scope { get; set; } = "PROGRAM";

    [JsonPropertyName("confidence")]
    public decimal Confidence { get; set; }

    [JsonPropertyName("reason")]
    public string Reason { get; set; } = string.Empty;

    [JsonPropertyName("evidence")]
    public List<string> Evidence { get; set; } = new();

    [JsonPropertyName("exerciseId")]
    public Guid? ExerciseId { get; set; }

    [JsonPropertyName("replacementExerciseId")]
    public Guid? ReplacementExerciseId { get; set; }

    [JsonPropertyName("changes")]
    public List<object> Changes { get; set; } = new();

    /// <summary>Not from the model — set by provider layer.</summary>
    [JsonIgnore]
    public string Source { get; set; } = AiProviderSources.TrainingEngine;

    [JsonIgnore]
    public bool UsedFallback { get; set; }

    public bool TryMap(out DecisionType decision, out DecisionScope scope, out string error)
    {
        decision = DecisionType.Continue;
        scope = DecisionScope.Program;
        error = string.Empty;

        if (!TryParseDecision(Decision, out decision))
        {
            error = $"Unknown decision '{Decision}'.";
            return false;
        }

        if (!TryParseScope(Scope, out scope))
        {
            error = $"Unknown scope '{Scope}'.";
            return false;
        }

        // Structured program analysis should not use SET scope.
        if (scope == DecisionScope.Set)
        {
            error = "Scope SET is not valid for structured program analysis.";
            return false;
        }

        if (Confidence is < 0 or > 1)
        {
            error = "Confidence must be between 0 and 1.";
            return false;
        }

        if (string.IsNullOrWhiteSpace(Reason))
        {
            error = "Reason is required.";
            return false;
        }

        return true;
    }

    public static bool TryParseDecision(string value, out DecisionType decision)
    {
        decision = DecisionType.Continue;
        var normalized = Normalize(value);
        return Enum.TryParse(normalized, true, out decision);
    }

    public static bool TryParseScope(string value, out DecisionScope scope)
    {
        scope = DecisionScope.Program;
        var normalized = Normalize(value);
        return Enum.TryParse(normalized, true, out scope);
    }

    private static string Normalize(string value) =>
        value.Replace("_", "", StringComparison.Ordinal).Replace("-", "", StringComparison.Ordinal);
}

public sealed class TrainingContextDto
{
    public string? Exercise { get; set; }
    public Guid? ExerciseId { get; set; }
    public int RecentExposureCount { get; set; }
    public decimal Estimated1RmTrendPercent { get; set; }
    public int RecentPlateauSessions { get; set; }
    public decimal? AverageRir { get; set; }
    public int WeeklyMuscleSets { get; set; }
    public decimal Adherence { get; set; }
    public string SleepTrend { get; set; } = "unknown";
    public string RestingHeartRateTrend { get; set; } = "unknown";
    public string OverallStrengthTrend { get; set; } = "stable";
    public int ProgramExposureCount { get; set; }
    public bool AdequateRecovery { get; set; } = true;
    public bool PriorMinorAdjustmentsTried { get; set; }
    public bool DeloadAlreadyTried { get; set; }
    public string? ProgramName { get; set; }
    public int? ProgramVersion { get; set; }
    public string? ProgramStatus { get; set; }
    public string? PlateauState { get; set; }
    public string? OverloadReason { get; set; }
    public decimal? SuggestedLoadKg { get; set; }
    public string? PrescriptionSummary { get; set; }
    public List<string> RecentExposures { get; set; } = new();
    public List<string> KeyLiftSummaries { get; set; } = new();
    public List<string> PersonalRecords { get; set; } = new();
    public string ContextFingerprint { get; set; } = string.Empty;
}

public sealed class CoachAnswerDto
{
    public string Answer { get; set; } = string.Empty;
    public bool RefusedNutrition { get; set; }
    public IReadOnlyList<string> CitedFacts { get; set; } = Array.Empty<string>();
    public string Source { get; set; } = AiProviderSources.TrainingEngine;
    public decimal Confidence { get; set; } = 0.7m;
    public string DataSufficiency { get; set; } = "SUFFICIENT";
    public bool UsedFallback { get; set; }
    public IReadOnlyList<string> ReferencedMetrics { get; set; } = Array.Empty<string>();
}
