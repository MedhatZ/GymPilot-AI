using GymCoach.Application.Abstractions;
using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Metrics;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Application.Workouts;

public sealed class WorkoutSummaryService : IWorkoutSummaryService
{
    private readonly IGymCoachDbContext _db;
    private readonly ITrainingMetricsEngine _metrics;
    private readonly IEstimatedOneRepMaxCalculator _oneRm;

    public WorkoutSummaryService(
        IGymCoachDbContext db,
        ITrainingMetricsEngine metrics,
        IEstimatedOneRepMaxCalculator oneRm)
    {
        _db = db;
        _metrics = metrics;
        _oneRm = oneRm;
    }

    public async Task<WorkoutSummaryDto?> GetAsync(string userId, Guid sessionClientId, CancellationToken ct = default)
    {
        var profile = await _db.AthleteProfiles.AsNoTracking()
            .FirstOrDefaultAsync(p => p.UserId == userId, ct);
        if (profile is null) return null;

        var session = await _db.WorkoutSessions
            .AsNoTracking()
            .Include(s => s.Exercises).ThenInclude(e => e.Sets)
            .Include(s => s.Exercises).ThenInclude(e => e.Exercise)
            .FirstOrDefaultAsync(s => s.AthleteProfileId == profile.Id && s.ClientId == sessionClientId, ct);
        if (session is null) return null;

        var end = session.CompletedAtUtc ?? DateTime.UtcNow;
        var duration = end - session.StartedAtUtc;
        var workingSets = session.Exercises.SelectMany(e => e.Sets).Where(s => s.SetType == SetType.Working).ToList();
        var metricInputs = workingSets.Select(s =>
        {
            var ex = session.Exercises.First(e => e.Id == s.WorkoutExerciseId);
            return new SetMetricInput
            {
                ExerciseId = ex.ExerciseId,
                WeightKg = s.WeightKg,
                Reps = s.Reps,
                Rir = s.Rir,
                IsWorkingSet = true
            };
        });
        var metrics = _metrics.CalculateSessionMetrics(metricInputs);

        var prs = await _db.PersonalRecords.AsNoTracking()
            .Where(p => p.AthleteProfileId == profile.Id &&
                        p.AchievedAtUtc >= session.StartedAtUtc &&
                        p.AchievedAtUtc <= end)
            .Join(_db.Exercises, p => p.ExerciseId, e => e.Id,
                (p, e) => $"{e.Name}: {p.RecordType} {p.Value}")
            .ToListAsync(ct);

        var comparisons = new List<ExerciseComparisonDto>();
        foreach (var ex in session.Exercises)
        {
            var currentBest = workingSets
                .Where(s => s.WorkoutExerciseId == ex.Id)
                .Select(s => _oneRm.Calculate(s.WeightKg, s.Reps))
                .DefaultIfEmpty(0)
                .Max();
            if (currentBest <= 0) continue;

            var priorSets = await _db.WorkoutSets.AsNoTracking()
                .Where(s => s.SetType == SetType.Working &&
                            s.WorkoutExercise!.ExerciseId == ex.ExerciseId &&
                            s.WorkoutExercise.WorkoutSession!.AthleteProfileId == profile.Id &&
                            s.WorkoutExercise.WorkoutSessionId != session.Id &&
                            s.WorkoutExercise.WorkoutSession!.CompletedAtUtc != null)
                .Select(s => new { s.WeightKg, s.Reps })
                .ToListAsync(ct);
            var previousBest = priorSets.Count == 0
                ? (decimal?)null
                : priorSets.Max(s => _oneRm.Calculate(s.WeightKg, s.Reps));

            decimal? change = null;
            if (previousBest is > 0)
                change = Math.Round((currentBest - previousBest.Value) / previousBest.Value * 100m, 1);

            comparisons.Add(new ExerciseComparisonDto(
                ex.ExerciseId,
                ex.Exercise?.Name ?? "Exercise",
                previousBest,
                currentBest,
                change));
        }

        var bestGain = comparisons
            .Where(c => c.ChangePercent.HasValue)
            .OrderByDescending(c => c.ChangePercent)
            .FirstOrDefault();

        string? insight = null;
        if (bestGain?.ChangePercent is > 0.5m)
            insight = $"{bestGain.ExerciseName} improved by approximately {bestGain.ChangePercent:0.#}% versus your previous exposure.";
        else if (prs.Count > 0)
            insight = $"New personal record(s): {string.Join(", ", prs.Take(2))}.";
        else if (workingSets.Count > 0)
            insight = "Session logged. Keep progressing within the target rep range.";

        return new WorkoutSummaryDto(
            session.ClientId,
            duration,
            session.Exercises.Count,
            workingSets.Count,
            metrics.TotalVolume,
            prs,
            comparisons,
            insight,
            session.Difficulty);
    }
}
