using GymCoach.Application.Abstractions;
using GymCoach.Application.Coach;
using GymCoach.Domain.Entities;
using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Metrics;
using GymCoach.TrainingEngine.Options;
using GymCoach.TrainingEngine.Overload;
using GymCoach.TrainingEngine.Recovery;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace GymCoach.Application.Workouts;

public sealed record StartWorkoutRequest(Guid? ProgramDayId, Guid ClientId, DateTime? StartedAtUtc);
public sealed record LogSetRequest(
    Guid WorkoutExerciseClientId,
    Guid SetClientId,
    Guid ExerciseId,
    int Order,
    int SetNumber,
    decimal WeightKg,
    int Reps,
    decimal? Rir,
    SetType SetType,
    string? Note,
    DateTime CompletedAtUtc);
public sealed record CompleteWorkoutRequest(
    Guid SessionClientId,
    WorkoutDifficulty Difficulty,
    bool PainReported,
    string? PainLocation,
    Guid? PainExerciseId,
    string? Notes,
    DateTime CompletedAtUtc);

public sealed record WorkoutSessionDto(
    Guid Id,
    Guid ClientId,
    DateTime StartedAtUtc,
    DateTime? CompletedAtUtc,
    decimal TotalVolume,
    IReadOnlyList<string> PersonalRecords,
    IReadOnlyList<WorkoutExerciseDto> Exercises);

public sealed record WorkoutExerciseDto(Guid ClientId, Guid ExerciseId, string Name, int Order, IReadOnlyList<WorkoutSetDto> Sets);
public sealed record WorkoutSetDto(Guid ClientId, int SetNumber, decimal WeightKg, int Reps, decimal? Rir, SetType SetType);

public interface IWorkoutService
{
    Task<WorkoutSessionDto> StartAsync(string userId, StartWorkoutRequest request, CancellationToken ct = default);
    Task<WorkoutSetDto> LogSetAsync(string userId, Guid sessionClientId, LogSetRequest request, CancellationToken ct = default);
    Task<WorkoutSessionDto> CompleteAsync(string userId, CompleteWorkoutRequest request, CancellationToken ct = default);
    Task<OverloadRecommendation?> SuggestNextAsync(string userId, Guid exerciseId, CancellationToken ct = default);
}

public sealed class WorkoutService : IWorkoutService
{
    private readonly IGymCoachDbContext _db;
    private readonly ITrainingMetricsEngine _metrics;
    private readonly IEstimatedOneRepMaxCalculator _oneRm;
    private readonly IPersonalRecordDetector _prs;
    private readonly IProgressiveOverloadEngine _overload;
    private readonly ICoachService _coach;
    private readonly ILogger<WorkoutService> _logger;

    public WorkoutService(
        IGymCoachDbContext db,
        ITrainingMetricsEngine metrics,
        IEstimatedOneRepMaxCalculator oneRm,
        IPersonalRecordDetector prs,
        IProgressiveOverloadEngine overload,
        ICoachService coach,
        ILogger<WorkoutService> logger)
    {
        _db = db;
        _metrics = metrics;
        _oneRm = oneRm;
        _prs = prs;
        _overload = overload;
        _coach = coach;
        _logger = logger;
    }

    public async Task<WorkoutSessionDto> StartAsync(string userId, StartWorkoutRequest request, CancellationToken ct = default)
    {
        var profile = await RequireProfile(userId, ct);
        var existing = await _db.WorkoutSessions
            .Include(s => s.Exercises).ThenInclude(e => e.Sets)
            .FirstOrDefaultAsync(s => s.AthleteProfileId == profile.Id && s.ClientId == request.ClientId, ct);
        if (existing != null) return await MapSession(existing, ct);

        var program = await _db.Programs.FirstOrDefaultAsync(
            p => p.AthleteProfileId == profile.Id && p.Status == ProgramStatus.Active, ct);

        var session = new WorkoutSession
        {
            AthleteProfileId = profile.Id,
            ClientId = request.ClientId,
            ProgramId = program?.Id,
            ProgramDayId = request.ProgramDayId,
            StartedAtUtc = request.StartedAtUtc ?? DateTime.UtcNow
        };
        _db.WorkoutSessions.Add(session);
        await _db.SaveChangesAsync(ct);
        return await MapSession(session, ct);
    }

    public async Task<WorkoutSetDto> LogSetAsync(string userId, Guid sessionClientId, LogSetRequest request, CancellationToken ct = default)
    {
        var profile = await RequireProfile(userId, ct);
        var session = await _db.WorkoutSessions
            .Include(s => s.Exercises).ThenInclude(e => e.Sets)
            .FirstOrDefaultAsync(s => s.AthleteProfileId == profile.Id && s.ClientId == sessionClientId, ct)
            ?? throw new InvalidOperationException("Workout session not found.");

        var existingSet = session.Exercises.SelectMany(e => e.Sets).FirstOrDefault(s => s.ClientId == request.SetClientId);
        if (existingSet != null)
        {
            return new WorkoutSetDto(existingSet.ClientId, existingSet.SetNumber, existingSet.WeightKg, existingSet.Reps,
                existingSet.Rir, existingSet.SetType);
        }

        var exercise = session.Exercises.FirstOrDefault(e => e.ClientId == request.WorkoutExerciseClientId);
        if (exercise is null)
        {
            exercise = new WorkoutExercise
            {
                WorkoutSessionId = session.Id,
                ClientId = request.WorkoutExerciseClientId,
                ExerciseId = request.ExerciseId,
                Order = request.Order
            };
            _db.WorkoutExercises.Add(exercise);
            await _db.SaveChangesAsync(ct);
        }

        var set = new WorkoutSet
        {
            WorkoutExerciseId = exercise.Id,
            ClientId = request.SetClientId,
            SetNumber = request.SetNumber,
            WeightKg = request.WeightKg,
            Reps = request.Reps,
            Rir = request.Rir,
            SetType = request.SetType,
            Note = request.Note,
            CompletedAtUtc = request.CompletedAtUtc
        };
        _db.WorkoutSets.Add(set);
        await _db.SaveChangesAsync(ct);

        if (request.SetType == SetType.Working)
        {
            var hist = await GetHistory(profile.Id, request.ExerciseId, ct);
            var e1rm = _oneRm.Calculate(request.WeightKg, request.Reps);
            var detected = _prs.Detect(request.ExerciseId, hist, request.WeightKg, request.Reps, e1rm);
            foreach (var pr in detected)
            {
                _db.PersonalRecords.Add(new PersonalRecord
                {
                    AthleteProfileId = profile.Id,
                    ExerciseId = pr.ExerciseId,
                    RecordType = pr.Type,
                    Value = pr.Value,
                    AchievedAtUtc = request.CompletedAtUtc,
                    WorkoutSetId = set.Id
                });
            }

            await _db.SaveChangesAsync(ct);
        }

        return new WorkoutSetDto(set.ClientId, set.SetNumber, set.WeightKg, set.Reps, set.Rir, set.SetType);
    }

    public async Task<WorkoutSessionDto> CompleteAsync(string userId, CompleteWorkoutRequest request, CancellationToken ct = default)
    {
        var profile = await RequireProfile(userId, ct);
        var session = await _db.WorkoutSessions
            .Include(s => s.Exercises).ThenInclude(e => e.Sets)
            .FirstOrDefaultAsync(s => s.AthleteProfileId == profile.Id && s.ClientId == request.SessionClientId, ct)
            ?? throw new InvalidOperationException("Workout session not found.");

        session.CompletedAtUtc = request.CompletedAtUtc;
        session.Difficulty = request.Difficulty;
        session.PainReported = request.PainReported;
        session.PainLocation = request.PainLocation;
        session.PainExerciseId = request.PainExerciseId;
        session.Notes = request.Notes;
        session.Touch();
        await _db.SaveChangesAsync(ct);

        // AI only when deterministic signals warrant it — never after every set.
        try
        {
            await _coach.AnalyzeAfterWorkoutIfNeededAsync(userId, session.Id, ct);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Post-workout AI analysis skipped due to error.");
        }

        return await MapSession(session, ct);
    }

    public async Task<OverloadRecommendation?> SuggestNextAsync(string userId, Guid exerciseId, CancellationToken ct = default)
    {
        var profile = await RequireProfile(userId, ct);
        var programEx = await _db.ProgramExercises
            .Include(pe => pe.ProgramDay)!.ThenInclude(d => d!.ProgramVersion)!.ThenInclude(v => v!.Program)
            .Include(pe => pe.Exercise)
            .Where(pe => pe.ExerciseId == exerciseId &&
                         pe.ProgramDay!.ProgramVersion!.Program!.AthleteProfileId == profile.Id &&
                         pe.ProgramDay.ProgramVersion.Program.Status == ProgramStatus.Active)
            .OrderByDescending(pe => pe.CreatedAtUtc)
            .FirstOrDefaultAsync(ct);
        if (programEx is null) return null;

        var lastSets = await _db.WorkoutSets
            .Include(s => s.WorkoutExercise)
            .Where(s => s.WorkoutExercise!.ExerciseId == exerciseId &&
                        s.SetType == SetType.Working &&
                        s.WorkoutExercise.WorkoutSession!.AthleteProfileId == profile.Id)
            .OrderByDescending(s => s.CompletedAtUtc)
            .Take(programEx.Sets)
            .ToListAsync(ct);

        var prescription = new ExercisePrescription
        {
            TargetSets = programEx.Sets,
            MinReps = programEx.MinReps,
            MaxReps = programEx.MaxReps,
            TargetRir = programEx.TargetRir,
            CurrentLoadKg = lastSets.FirstOrDefault()?.WeightKg ?? programEx.StartingLoadKg ?? 0,
            LoadIncrementKg = programEx.Exercise?.DefaultLoadIncrementKg ?? 2.5m
        };

        var performances = lastSets.Select(s => new WorkingSetPerformance
        {
            WeightKg = s.WeightKg,
            Reps = s.Reps,
            Rir = s.Rir
        }).Reverse().ToList();

        return _overload.Recommend(prescription, performances);
    }

    private async Task<List<(decimal Weight, int Reps, decimal E1rm)>> GetHistory(
        Guid athleteId, Guid exerciseId, CancellationToken ct)
    {
        var sets = await _db.WorkoutSets.AsNoTracking()
            .Where(s => s.SetType == SetType.Working &&
                        s.WorkoutExercise!.ExerciseId == exerciseId &&
                        s.WorkoutExercise.WorkoutSession!.AthleteProfileId == athleteId)
            .Select(s => new { s.WeightKg, s.Reps })
            .ToListAsync(ct);
        return sets.Select(s => (s.WeightKg, s.Reps, _oneRm.Calculate(s.WeightKg, s.Reps))).ToList();
    }

    private async Task<AthleteProfile> RequireProfile(string userId, CancellationToken ct) =>
        await _db.AthleteProfiles.FirstOrDefaultAsync(p => p.UserId == userId, ct)
        ?? throw new InvalidOperationException("Athlete profile not found.");

    private async Task<WorkoutSessionDto> MapSession(WorkoutSession session, CancellationToken ct)
    {
        await _db.WorkoutExercises.Where(e => e.WorkoutSessionId == session.Id).Include(e => e.Sets).Include(e => e.Exercise)
            .LoadAsync(ct);
        var sets = session.Exercises.SelectMany(e => e.Sets).Where(s => s.SetType == SetType.Working)
            .Select(s => new SetMetricInput
            {
                ExerciseId = session.Exercises.First(e => e.Id == s.WorkoutExerciseId).ExerciseId,
                WeightKg = s.WeightKg,
                Reps = s.Reps,
                Rir = s.Rir,
                IsWorkingSet = true
            });
        var metrics = _metrics.CalculateSessionMetrics(sets);
        var prs = await _db.PersonalRecords.AsNoTracking()
            .Where(p => p.AthleteProfileId == session.AthleteProfileId &&
                        p.AchievedAtUtc >= session.StartedAtUtc)
            .Select(p => $"{p.RecordType}:{p.Value}")
            .ToListAsync(ct);

        return new WorkoutSessionDto(
            session.Id,
            session.ClientId,
            session.StartedAtUtc,
            session.CompletedAtUtc,
            metrics.TotalVolume,
            prs,
            session.Exercises.OrderBy(e => e.Order).Select(e => new WorkoutExerciseDto(
                e.ClientId,
                e.ExerciseId,
                e.Exercise?.Name ?? "",
                e.Order,
                e.Sets.OrderBy(s => s.SetNumber).Select(s =>
                    new WorkoutSetDto(s.ClientId, s.SetNumber, s.WeightKg, s.Reps, s.Rir, s.SetType)).ToList()
            )).ToList());
    }
}
