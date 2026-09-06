using GymCoach.Application.Abstractions;
using GymCoach.Application.Programs;
using GymCoach.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Application.Workouts;

public sealed record NextWorkoutDto(
    Guid ProgramDayId,
    string DayName,
    string Split,
    int DayIndex,
    int ExerciseCount,
    int EstimatedMinutes,
    string ProgramName,
    int ProgramVersion,
    string Recommendation);

public interface INextWorkoutService
{
    Task<NextWorkoutDto?> GetRecommendedAsync(string userId, CancellationToken ct = default);
}

/// <summary>
/// Advances by program day sequence from the last completed session's ProgramDayId.
/// Skipped calendar days do not break sequence.
/// </summary>
public sealed class NextWorkoutService : INextWorkoutService
{
    private readonly IGymCoachDbContext _db;
    private readonly IProgramGenerationService _programs;

    public NextWorkoutService(IGymCoachDbContext db, IProgramGenerationService programs)
    {
        _db = db;
        _programs = programs;
    }

    public async Task<NextWorkoutDto?> GetRecommendedAsync(string userId, CancellationToken ct = default)
    {
        var program = await _programs.GetActiveAsync(userId, ct);
        if (program is null || program.Days.Count == 0) return null;

        var days = program.Days.OrderBy(d => d.DayIndex).ToList();
        var profile = await _db.AthleteProfiles.AsNoTracking()
            .FirstOrDefaultAsync(p => p.UserId == userId, ct);
        if (profile is null) return null;

        var last = await _db.WorkoutSessions.AsNoTracking()
            .Where(s => s.AthleteProfileId == profile.Id &&
                        s.CompletedAtUtc != null &&
                        s.ProgramId == program.Id)
            .OrderByDescending(s => s.CompletedAtUtc)
            .FirstOrDefaultAsync(ct);

        ProgramDayDto nextDay;
        if (last?.ProgramDayId is Guid lastDayId)
        {
            var idx = days.FindIndex(d => d.Id == lastDayId);
            nextDay = idx < 0 ? days[0] : days[(idx + 1) % days.Count];
        }
        else
        {
            nextDay = days[0];
        }

        var est = Math.Max(30, nextDay.Exercises.Count * 8 + 10);
        return new NextWorkoutDto(
            nextDay.Id,
            nextDay.Name,
            nextDay.Split,
            nextDay.DayIndex,
            nextDay.Exercises.Count,
            est,
            program.Name,
            program.CurrentVersionNumber,
            $"Recommended next session: {nextDay.Name}. Sequence continues even if you skipped a calendar day.");
    }
}

public sealed record WorkoutSummaryDto(
    Guid SessionClientId,
    TimeSpan Duration,
    int ExerciseCount,
    int WorkingSetCount,
    decimal TotalWorkingVolume,
    IReadOnlyList<string> PersonalRecords,
    IReadOnlyList<ExerciseComparisonDto> Comparisons,
    string? Insight,
    WorkoutDifficulty? Difficulty);

public sealed record ExerciseComparisonDto(
    Guid ExerciseId,
    string ExerciseName,
    decimal? PreviousBestE1rm,
    decimal? CurrentBestE1rm,
    decimal? ChangePercent);

public interface IWorkoutSummaryService
{
    Task<WorkoutSummaryDto?> GetAsync(string userId, Guid sessionClientId, CancellationToken ct = default);
}
