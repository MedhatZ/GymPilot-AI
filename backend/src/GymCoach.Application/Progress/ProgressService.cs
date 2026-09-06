using GymCoach.Application.Abstractions;
using GymCoach.Application.Programs;
using GymCoach.Application.Workouts;
using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Metrics;
using GymCoach.TrainingEngine.Recovery;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Application.Progress;

public sealed record ProgressOverviewDto(
    IReadOnlyList<ExerciseProgressDto> Exercises,
    IReadOnlyList<PersonalRecordDto> RecentPrs,
    RecoveryDto? Recovery);

public sealed record ExerciseProgressDto(
    Guid ExerciseId,
    string Name,
    decimal? BestWeight,
    decimal? BestE1rm,
    int SessionCount,
    IReadOnlyList<decimal> RecentE1rmPoints);

public sealed record PersonalRecordDto(Guid ExerciseId, string ExerciseName, string Type, decimal Value, DateTime AchievedAtUtc);
public sealed record RecoveryDto(decimal ReadinessScore, string Label, string Summary);
public sealed record HomeDto(
    ProgramSummaryDto? ActiveProgram,
    ProgramDayDto? TodaysWorkout,
    NextWorkoutDto? NextWorkout,
    RecoveryDto? Recovery,
    string Insight,
    string NextAction,
    string? LastWorkoutName,
    DateTime? LastWorkoutAtUtc,
    string? RecentPr);

public interface IProgressService
{
    Task<ProgressOverviewDto> GetOverviewAsync(string userId, CancellationToken ct = default);
    Task<ExerciseProgressDto?> GetExerciseAsync(string userId, Guid exerciseId, CancellationToken ct = default);
}

public interface IHomeService
{
    Task<HomeDto> GetAsync(string userId, CancellationToken ct = default);
}

public sealed class ProgressService : IProgressService
{
    private readonly IGymCoachDbContext _db;
    private readonly IEstimatedOneRepMaxCalculator _oneRm;
    private readonly IRecoveryModel _recovery;

    public ProgressService(IGymCoachDbContext db, IEstimatedOneRepMaxCalculator oneRm, IRecoveryModel recovery)
    {
        _db = db;
        _oneRm = oneRm;
        _recovery = recovery;
    }

    public async Task<ProgressOverviewDto> GetOverviewAsync(string userId, CancellationToken ct = default)
    {
        var profile = await _db.AthleteProfiles.FirstOrDefaultAsync(p => p.UserId == userId, ct)
                      ?? throw new InvalidOperationException("Athlete profile not found.");

        var exerciseIds = await _db.WorkoutExercises.AsNoTracking()
            .Where(e => e.WorkoutSession!.AthleteProfileId == profile.Id)
            .Select(e => e.ExerciseId)
            .Distinct()
            .ToListAsync(ct);

        var exercises = new List<ExerciseProgressDto>();
        foreach (var id in exerciseIds)
        {
            var detail = await GetExerciseAsync(userId, id, ct);
            if (detail != null) exercises.Add(detail);
        }

        var prs = await _db.PersonalRecords.AsNoTracking()
            .Where(p => p.AthleteProfileId == profile.Id)
            .OrderByDescending(p => p.AchievedAtUtc)
            .Take(20)
            .Join(_db.Exercises, p => p.ExerciseId, e => e.Id, (p, e) =>
                new PersonalRecordDto(p.ExerciseId, e.Name, p.RecordType.ToString(), p.Value, p.AchievedAtUtc))
            .ToListAsync(ct);

        var recoveryEntity = await _db.RecoveryMetrics.AsNoTracking()
            .Where(r => r.AthleteProfileId == profile.Id)
            .OrderByDescending(r => r.AsOfUtc)
            .FirstOrDefaultAsync(ct);

        RecoveryDto? recoveryDto = null;
        if (recoveryEntity != null)
        {
            recoveryDto = new RecoveryDto(recoveryEntity.ReadinessScore, recoveryEntity.TrendLabel, recoveryEntity.Notes ?? "");
        }
        else
        {
            var assessed = _recovery.Assess(new RecoveryInput { HasWearableData = false, SessionsLast7Days = 0 });
            recoveryDto = new RecoveryDto(assessed.ReadinessScore, assessed.Label, assessed.Summary);
        }

        return new ProgressOverviewDto(exercises, prs, recoveryDto);
    }

    public async Task<ExerciseProgressDto?> GetExerciseAsync(string userId, Guid exerciseId, CancellationToken ct = default)
    {
        var profile = await _db.AthleteProfiles.FirstOrDefaultAsync(p => p.UserId == userId, ct);
        if (profile is null) return null;
        var exercise = await _db.Exercises.AsNoTracking().FirstOrDefaultAsync(e => e.Id == exerciseId, ct);
        if (exercise is null) return null;

        var sets = await _db.WorkoutSets.AsNoTracking()
            .Where(s => s.SetType == SetType.Working &&
                        s.WorkoutExercise!.ExerciseId == exerciseId &&
                        s.WorkoutExercise.WorkoutSession!.AthleteProfileId == profile.Id)
            .OrderBy(s => s.CompletedAtUtc)
            .Select(s => new { s.WeightKg, s.Reps, s.CompletedAtUtc })
            .ToListAsync(ct);

        var e1rms = sets.Select(s => _oneRm.Calculate(s.WeightKg, s.Reps)).ToList();
        var sessions = await _db.WorkoutExercises.AsNoTracking()
            .Where(e => e.ExerciseId == exerciseId && e.WorkoutSession!.AthleteProfileId == profile.Id)
            .Select(e => e.WorkoutSessionId)
            .Distinct()
            .CountAsync(ct);

        return new ExerciseProgressDto(
            exerciseId,
            exercise.Name,
            sets.Count == 0 ? null : sets.Max(s => s.WeightKg),
            e1rms.Count == 0 ? null : e1rms.Max(),
            sessions,
            e1rms.TakeLast(12).ToList());
    }
}

public sealed class HomeService : IHomeService
{
    private readonly IGymCoachDbContext _db;
    private readonly IProgramGenerationService _programs;
    private readonly IProgressService _progress;
    private readonly IRecoveryModel _recovery;
    private readonly INextWorkoutService _nextWorkout;

    public HomeService(
        IGymCoachDbContext db,
        IProgramGenerationService programs,
        IProgressService progress,
        IRecoveryModel recovery,
        INextWorkoutService nextWorkout)
    {
        _db = db;
        _programs = programs;
        _progress = progress;
        _recovery = recovery;
        _nextWorkout = nextWorkout;
    }

    public async Task<HomeDto> GetAsync(string userId, CancellationToken ct = default)
    {
        var program = await _programs.GetActiveAsync(userId, ct);
        var next = await _nextWorkout.GetRecommendedAsync(userId, ct);
        ProgramDayDto? today = null;
        if (program != null && next != null)
            today = program.Days.FirstOrDefault(d => d.Id == next.ProgramDayId) ?? program.Days.OrderBy(d => d.DayIndex).FirstOrDefault();

        var overview = await SafeOverview(userId, ct);
        var recovery = overview?.Recovery ?? new RecoveryDto(
            _recovery.Assess(new RecoveryInput()).ReadinessScore,
            "moderate",
            "Training-only readiness estimate.");

        var profile = await _db.AthleteProfiles.AsNoTracking().FirstOrDefaultAsync(p => p.UserId == userId, ct);
        string? lastName = null;
        DateTime? lastAt = null;
        if (profile != null)
        {
            var last = await _db.WorkoutSessions.AsNoTracking()
                .Where(s => s.AthleteProfileId == profile.Id && s.CompletedAtUtc != null)
                .OrderByDescending(s => s.CompletedAtUtc)
                .FirstOrDefaultAsync(ct);
            if (last != null)
            {
                lastAt = last.CompletedAtUtc;
                if (last.ProgramDayId is Guid dayId && program != null)
                    lastName = program.Days.FirstOrDefault(d => d.Id == dayId)?.Name;
                lastName ??= "Workout";
            }
        }

        var recentPr = overview?.RecentPrs.FirstOrDefault();
        var insight = recentPr != null
            ? $"{recentPr.ExerciseName} {recentPr.Type} PR: {recentPr.Value}"
            : next?.Recommendation ?? "Log workouts to unlock progressive insights.";

        // Conservative product message when progression likely positive
        if (overview?.Exercises.Count > 0 && overview.Exercises.Any(e => (e.RecentE1rmPoints.Count >= 2) &&
                e.RecentE1rmPoints.Last() >= e.RecentE1rmPoints.First()))
        {
            var lift = overview.Exercises.First(e => e.RecentE1rmPoints.Count >= 2);
            insight = $"{lift.Name} is progressing. No program change needed.";
        }

        var nextAction = today is null
            ? "Complete setup and generate your program."
            : $"Start {today.Name} when ready.";

        return new HomeDto(
            program,
            today,
            next,
            recovery,
            insight,
            nextAction,
            lastName,
            lastAt,
            recentPr is null ? null : $"{recentPr.ExerciseName} {recentPr.Type}");
    }

    private async Task<ProgressOverviewDto?> SafeOverview(string userId, CancellationToken ct)
    {
        try { return await _progress.GetOverviewAsync(userId, ct); }
        catch { return null; }
    }
}
