using GymCoach.Application.Abstractions;
using GymCoach.Domain.Entities;
using GymCoach.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using ProgramEntity = GymCoach.Domain.Entities.Program;

namespace GymCoach.Application.Programs;

public sealed record ProgramSummaryDto(
    Guid Id,
    string Name,
    string Status,
    DateTime StartDateUtc,
    DateTime? EndDateUtc,
    int CurrentVersionNumber,
    IReadOnlyList<ProgramDayDto> Days);

public sealed record ProgramDayDto(Guid Id, int DayIndex, string Name, string Split, IReadOnlyList<ProgramExerciseDto> Exercises);
public sealed record ProgramExerciseDto(
    Guid Id, Guid ExerciseId, string ExerciseName, int Order, int Sets, int MinReps, int MaxReps,
    decimal? StartingLoadKg, int RestSeconds, decimal? TargetRir, string? Notes);

public interface IProgramGenerationService
{
    Task<ProgramSummaryDto> GenerateInitialAsync(string userId, CancellationToken ct = default);
    Task<ProgramSummaryDto?> GetActiveAsync(string userId, CancellationToken ct = default);
}

public sealed class ProgramGenerationService : IProgramGenerationService
{
    private readonly IGymCoachDbContext _db;

    public ProgramGenerationService(IGymCoachDbContext db) => _db = db;

    public async Task<ProgramSummaryDto?> GetActiveAsync(string userId, CancellationToken ct = default)
    {
        var profile = await RequireProfile(userId, ct);
        var program = await _db.Programs.AsNoTracking()
            .Include(p => p.CurrentVersion)!.ThenInclude(v => v!.Days).ThenInclude(d => d.Exercises).ThenInclude(e => e.Exercise)
            .FirstOrDefaultAsync(p => p.AthleteProfileId == profile.Id && p.Status == ProgramStatus.Active, ct);
        return program is null ? null : await MapAsync(program, ct);
    }

    public async Task<ProgramSummaryDto> GenerateInitialAsync(string userId, CancellationToken ct = default)
    {
        var profile = await _db.AthleteProfiles
            .Include(p => p.Goal)
            .Include(p => p.Limitations)
            .Include(p => p.BaselineLifts)
            .FirstOrDefaultAsync(p => p.UserId == userId, ct)
            ?? throw new InvalidOperationException("Complete onboarding first.");

        var existing = await _db.Programs
            .Where(p => p.AthleteProfileId == profile.Id && p.Status == ProgramStatus.Active)
            .ToListAsync(ct);
        foreach (var p in existing)
        {
            p.Status = ProgramStatus.Replaced;
            p.EndDateUtc = DateTime.UtcNow;
            p.Touch();
        }

        var daysPerWeek = Math.Clamp(profile.TrainingDaysPerWeek, 2, 6);
        var goal = profile.Goal?.PrimaryGoal ?? TrainingGoal.Hypertrophy;
        var splitPlan = ChooseSplit(daysPerWeek);
        var exercises = await _db.Exercises.Where(e => e.IsActive).Include(e => e.MuscleGroups).ToListAsync(ct);
        var avoided = profile.Limitations.Where(l => l.AvoidedExerciseId.HasValue).Select(l => l.AvoidedExerciseId!.Value).ToHashSet();
        exercises = exercises.Where(e => !avoided.Contains(e.Id)).ToList();

        var program = new ProgramEntity
        {
            AthleteProfileId = profile.Id,
            Name = "GymCoach Program v1",
            Status = ProgramStatus.Active,
            StartDateUtc = DateTime.UtcNow,
            EndDateUtc = null
        };
        _db.Programs.Add(program);
        await _db.SaveChangesAsync(ct);

        var version = new ProgramVersion
        {
            ProgramId = program.Id,
            VersionNumber = 1,
            Trigger = "InitialGeneration",
            Reason = "Baseline GymCoach Program v1 from athlete profile and goals. Continues while you progress; no calendar expiration.",
            IsDeload = false
        };
        _db.ProgramVersions.Add(version);
        await _db.SaveChangesAsync(ct);

        for (var i = 0; i < splitPlan.Count; i++)
        {
            var (name, split, patterns) = splitPlan[i];
            var day = new ProgramDay
            {
                ProgramVersionId = version.Id,
                DayIndex = i,
                Name = name,
                Split = split
            };
            _db.ProgramDays.Add(day);
            await _db.SaveChangesAsync(ct);

            var dayExercises = PickExercises(exercises, patterns, goal, profile.PreferredSessionMinutes, i);
            var order = 0;
            foreach (var ex in dayExercises)
            {
                var baseline = profile.BaselineLifts.FirstOrDefault(b => b.ExerciseId == ex.Id);
                var (sets, minR, maxR, rir, rest) = PrescriptionFor(goal, ex.IsCompound, profile.Experience);
                _db.ProgramExercises.Add(new ProgramExercise
                {
                    ProgramDayId = day.Id,
                    ExerciseId = ex.Id,
                    Order = order++,
                    Sets = sets,
                    MinReps = minR,
                    MaxReps = maxR,
                    StartingLoadKg = baseline?.WeightKg,
                    RestSeconds = rest,
                    TargetRir = rir,
                    Notes = null
                });
            }
        }

        await _db.SaveChangesAsync(ct);
        program.CurrentVersionId = version.Id;
        program.Touch();
        await _db.SaveChangesAsync(ct);

        return (await GetActiveAsync(userId, ct))!;
    }

    private static List<(string Name, ProgramDaySplit Split, MovementPattern[] Patterns)> ChooseSplit(int days) =>
        days switch
        {
            <= 3 =>
            [
                ("Full Body A", ProgramDaySplit.FullBody, [MovementPattern.Squat, MovementPattern.HorizontalPush, MovementPattern.HorizontalPull, MovementPattern.Hinge]),
                ("Full Body B", ProgramDaySplit.FullBody, [MovementPattern.Hinge, MovementPattern.VerticalPush, MovementPattern.VerticalPull, MovementPattern.Lunge]),
                ("Full Body C", ProgramDaySplit.FullBody, [MovementPattern.Squat, MovementPattern.HorizontalPush, MovementPattern.HorizontalPull, MovementPattern.Core])
            ],
            4 =>
            [
                ("Upper A", ProgramDaySplit.Upper, [MovementPattern.HorizontalPush, MovementPattern.HorizontalPull, MovementPattern.VerticalPush]),
                ("Lower A", ProgramDaySplit.Lower, [MovementPattern.Squat, MovementPattern.Hinge, MovementPattern.Lunge]),
                ("Upper B", ProgramDaySplit.Upper, [MovementPattern.VerticalPull, MovementPattern.HorizontalPush, MovementPattern.HorizontalPull]),
                ("Lower B", ProgramDaySplit.Lower, [MovementPattern.Hinge, MovementPattern.Squat, MovementPattern.Core])
            ],
            _ =>
            [
                ("Push", ProgramDaySplit.Push, [MovementPattern.HorizontalPush, MovementPattern.VerticalPush]),
                ("Pull", ProgramDaySplit.Pull, [MovementPattern.HorizontalPull, MovementPattern.VerticalPull]),
                ("Legs", ProgramDaySplit.Legs, [MovementPattern.Squat, MovementPattern.Hinge, MovementPattern.Lunge]),
                ("Push B", ProgramDaySplit.Push, [MovementPattern.HorizontalPush, MovementPattern.VerticalPush]),
                ("Pull B", ProgramDaySplit.Pull, [MovementPattern.HorizontalPull, MovementPattern.VerticalPull]),
                ("Legs B", ProgramDaySplit.Legs, [MovementPattern.Squat, MovementPattern.Hinge, MovementPattern.Core])
            ]
        };

    private static List<Exercise> PickExercises(
        List<Exercise> catalog,
        MovementPattern[] patterns,
        TrainingGoal goal,
        int sessionMinutes,
        int seed)
    {
        var targetCount = sessionMinutes >= 75 ? 6 : sessionMinutes >= 45 ? 5 : 4;
        var picked = new List<Exercise>();
        foreach (var pattern in patterns)
        {
            var candidate = catalog
                .Where(e => e.MovementPattern == pattern && !picked.Contains(e))
                .OrderByDescending(e => e.IsCompound)
                .ThenBy(e => e.Name)
                .Skip(seed % 2)
                .FirstOrDefault();
            if (candidate != null) picked.Add(candidate);
            if (picked.Count >= targetCount) break;
        }

        while (picked.Count < Math.Min(targetCount, catalog.Count))
        {
            var next = catalog.FirstOrDefault(e => !picked.Contains(e) && e.IsCompound)
                       ?? catalog.FirstOrDefault(e => !picked.Contains(e));
            if (next is null) break;
            picked.Add(next);
        }

        return picked;
    }

    private static (int Sets, int Min, int Max, decimal Rir, int RestSeconds) PrescriptionFor(
        TrainingGoal goal, bool compound, TrainingExperience experience)
    {
        return goal switch
        {
            TrainingGoal.Strength => (compound ? 4 : 3, 3, 5, 2m, compound ? 180 : 120),
            TrainingGoal.StrengthHypertrophy => (compound ? 4 : 3, 5, 8, 2m, compound ? 150 : 90),
            TrainingGoal.Hypertrophy => (compound ? 3 : 3, 8, 12, 2m, compound ? 120 : 75),
            TrainingGoal.BodyRecomp => (3, 8, 12, 2m, 90),
            _ => (3, 8, 15, 3m, 75)
        };
    }

    private async Task<AthleteProfile> RequireProfile(string userId, CancellationToken ct) =>
        await _db.AthleteProfiles.FirstOrDefaultAsync(p => p.UserId == userId, ct)
        ?? throw new InvalidOperationException("Athlete profile not found.");

    private async Task<ProgramSummaryDto> MapAsync(ProgramEntity program, CancellationToken ct)
    {
        var version = program.CurrentVersion ?? await _db.ProgramVersions
            .Include(v => v.Days).ThenInclude(d => d.Exercises).ThenInclude(e => e.Exercise)
            .FirstAsync(v => v.Id == program.CurrentVersionId, ct);

        return new ProgramSummaryDto(
            program.Id,
            program.Name,
            program.Status.ToString(),
            program.StartDateUtc,
            program.EndDateUtc,
            version.VersionNumber,
            version.Days.OrderBy(d => d.DayIndex).Select(d => new ProgramDayDto(
                d.Id,
                d.DayIndex,
                d.Name,
                d.Split.ToString(),
                d.Exercises.OrderBy(e => e.Order).Select(e => new ProgramExerciseDto(
                    e.Id,
                    e.ExerciseId,
                    e.Exercise?.Name ?? "",
                    e.Order,
                    e.Sets,
                    e.MinReps,
                    e.MaxReps,
                    e.StartingLoadKg,
                    e.RestSeconds,
                    e.TargetRir,
                    e.Notes)).ToList())).ToList());
    }
}
