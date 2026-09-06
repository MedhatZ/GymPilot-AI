using GymCoach.AI.Contracts;
using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Decisions;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace GymCoach.AI.Context;

public interface ITrainingContextBuilder
{
    TrainingContextDto Build(ProgramDecisionInput input, string? exerciseName = null);
    ProgramDecisionInput ToDecisionInput(TrainingContextDto context, IEnumerable<ExerciseTrendSummary>? exercises = null);
}

public sealed class TrainingContextBuilder : ITrainingContextBuilder
{
    public TrainingContextDto Build(ProgramDecisionInput input, string? exerciseName = null)
    {
        var primary = input.Exercises.FirstOrDefault(e => e.IsKeyLift) ?? input.Exercises.FirstOrDefault();
        var dto = new TrainingContextDto
        {
            Exercise = exerciseName,
            ExerciseId = primary?.ExerciseId,
            RecentExposureCount = primary?.ExposureCount ?? input.ProgramExposureCount,
            Estimated1RmTrendPercent = primary?.E1rmTrendPercent ?? 0,
            RecentPlateauSessions = input.Exercises.Count(e =>
                e.PlateauState is PlateauState.PossiblePlateau or PlateauState.ConfirmedPlateau),
            PlateauState = primary?.PlateauState.ToString(),
            Adherence = input.Adherence,
            SleepTrend = input.AdequateRecovery ? "stable" : "declining",
            RestingHeartRateTrend = input.AdequateRecovery ? "stable" : "elevated",
            OverallStrengthTrend = input.OverallStrengthTrend.ToString().ToLowerInvariant(),
            ProgramExposureCount = input.ProgramExposureCount,
            AdequateRecovery = input.AdequateRecovery,
            PriorMinorAdjustmentsTried = input.PriorMinorAdjustmentsTried,
            DeloadAlreadyTried = input.DeloadAlreadyTried,
            KeyLiftSummaries = input.Exercises
                .Where(e => e.IsKeyLift)
                .Select(e => $"{e.ExerciseId}:{e.PlateauState}:{e.StrengthTrend}:e1rmTrend={e.E1rmTrendPercent}%")
                .Take(8)
                .ToList()
        };
        dto.ContextFingerprint = Fingerprint(dto);
        return dto;
    }

    public ProgramDecisionInput ToDecisionInput(
        TrainingContextDto context,
        IEnumerable<ExerciseTrendSummary>? exercises = null)
    {
        var trend = context.OverallStrengthTrend.ToLowerInvariant() switch
        {
            "positive" => TrendDirection.Positive,
            "declining" => TrendDirection.Declining,
            _ => TrendDirection.Stable
        };

        return new ProgramDecisionInput
        {
            ProgramExposureCount = context.ProgramExposureCount,
            Adherence = context.Adherence,
            OverallStrengthTrend = trend,
            AdequateRecovery = context.AdequateRecovery,
            PriorMinorAdjustmentsTried = context.PriorMinorAdjustmentsTried,
            DeloadAlreadyTried = context.DeloadAlreadyTried,
            Exercises = exercises?.ToList() ?? new List<ExerciseTrendSummary>(),
            AccumulatedFatigueLikely = !context.AdequateRecovery && trend != TrendDirection.Positive
        };
    }

    public static string Fingerprint(TrainingContextDto dto)
    {
        var payload = JsonSerializer.Serialize(new
        {
            dto.ExerciseId,
            dto.ProgramExposureCount,
            dto.OverallStrengthTrend,
            dto.Adherence,
            dto.RecentPlateauSessions,
            dto.Estimated1RmTrendPercent,
            dto.SuggestedLoadKg,
            dto.PlateauState,
            Exposures = dto.RecentExposures.Take(6)
        });
        var hash = SHA256.HashData(Encoding.UTF8.GetBytes(payload));
        return Convert.ToHexString(hash)[..16];
    }
}
