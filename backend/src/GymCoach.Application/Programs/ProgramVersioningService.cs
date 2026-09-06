using GymCoach.Application.Abstractions;
using GymCoach.Domain.Entities;
using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using ProgramEntity = GymCoach.Domain.Entities.Program;

namespace GymCoach.Application.Programs;

public interface IProgramVersioningService
{
    Task<ProgramSummaryDto> ApplyDeloadAsync(string userId, string reason, CancellationToken ct = default);
}

public sealed class ProgramVersioningService : IProgramVersioningService
{
    private readonly IGymCoachDbContext _db;
    private readonly TrainingPolicyOptions _policy;

    public ProgramVersioningService(IGymCoachDbContext db, IOptions<TrainingPolicyOptions> policy)
    {
        _db = db;
        _policy = policy.Value;
    }

    public async Task<ProgramSummaryDto> ApplyDeloadAsync(string userId, string reason, CancellationToken ct = default)
    {
        var profile = await _db.AthleteProfiles.FirstOrDefaultAsync(p => p.UserId == userId, ct)
                      ?? throw new InvalidOperationException("Athlete profile not found.");
        var program = await _db.Programs
            .Include(p => p.CurrentVersion)!.ThenInclude(v => v!.Days).ThenInclude(d => d.Exercises)
            .FirstOrDefaultAsync(p => p.AthleteProfileId == profile.Id && p.Status == ProgramStatus.Active, ct)
            ?? throw new InvalidOperationException("No active program.");

        var current = program.CurrentVersion
                      ?? throw new InvalidOperationException("Program has no current version.");

        var next = new ProgramVersion
        {
            ProgramId = program.Id,
            VersionNumber = current.VersionNumber + 1,
            Trigger = "Deload",
            Reason = reason,
            PreviousVersionId = current.Id,
            IsDeload = true
        };
        _db.ProgramVersions.Add(next);
        await _db.SaveChangesAsync(ct);

        foreach (var day in current.Days.OrderBy(d => d.DayIndex))
        {
            var newDay = new ProgramDay
            {
                ProgramVersionId = next.Id,
                DayIndex = day.DayIndex,
                Name = day.Name + " (Deload)",
                Split = day.Split
            };
            _db.ProgramDays.Add(newDay);
            await _db.SaveChangesAsync(ct);

            foreach (var ex in day.Exercises.OrderBy(e => e.Order))
            {
                _db.ProgramExercises.Add(new ProgramExercise
                {
                    ProgramDayId = newDay.Id,
                    ExerciseId = ex.ExerciseId,
                    Order = ex.Order,
                    Sets = Math.Max(1, (int)Math.Round(ex.Sets * _policy.DeloadVolumeMultiplier)),
                    MinReps = ex.MinReps,
                    MaxReps = ex.MaxReps,
                    StartingLoadKg = ex.StartingLoadKg.HasValue
                        ? Math.Round(ex.StartingLoadKg.Value * _policy.DeloadLoadMultiplier, 1)
                        : null,
                    RestSeconds = ex.RestSeconds,
                    TargetRir = (ex.TargetRir ?? 2) + 1,
                    Notes = "Deload prescription — same program, temporary reduction."
                });
            }
        }

        await _db.SaveChangesAsync(ct);
        program.CurrentVersionId = next.Id;
        program.EndDateUtc = null; // deload must not expire/replace the program
        program.Touch();
        await _db.SaveChangesAsync(ct);

        var gen = new ProgramGenerationService(_db);
        return (await gen.GetActiveAsync(userId, ct))!;
    }
}
