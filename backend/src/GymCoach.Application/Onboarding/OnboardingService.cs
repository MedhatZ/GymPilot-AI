using GymCoach.Application.Abstractions;
using GymCoach.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Application.Onboarding;

public sealed class OnboardingService : IOnboardingService
{
    private readonly IGymCoachDbContext _db;

    public OnboardingService(IGymCoachDbContext db) => _db = db;

    public async Task<AthleteProfileDto?> GetAsync(string userId, CancellationToken ct = default)
    {
        var profile = await _db.AthleteProfiles
            .Include(p => p.Goal)
            .Include(p => p.Limitations)
            .Include(p => p.BaselineLifts)
            .FirstOrDefaultAsync(p => p.UserId == userId, ct);
        return profile is null ? null : Map(profile);
    }

    public async Task<AthleteProfileDto> CompleteAsync(string userId, OnboardingRequest request, CancellationToken ct = default)
    {
        var profile = await _db.AthleteProfiles
            .Include(p => p.Goal)
            .Include(p => p.Limitations)
            .Include(p => p.EquipmentItems)
            .Include(p => p.BaselineLifts)
            .FirstOrDefaultAsync(p => p.UserId == userId, ct);

        if (profile is null)
        {
            profile = new AthleteProfile { UserId = userId };
            _db.AthleteProfiles.Add(profile);
            await _db.SaveChangesAsync(ct);
        }

        profile.DisplayName = request.DisplayName;
        profile.Age = request.Age;
        profile.Sex = request.Sex;
        profile.HeightCm = request.HeightCm;
        profile.BodyWeightKg = request.BodyWeightKg;
        profile.Experience = request.Experience;
        profile.YearsTraining = request.YearsTraining;
        profile.TrainingDaysPerWeek = request.TrainingDaysPerWeek;
        profile.PreferredSessionMinutes = request.PreferredSessionMinutes;
        profile.EquipmentSetting = request.EquipmentSetting;
        profile.OnboardingCompleted = true;
        profile.Touch();

        if (profile.Goal is null)
        {
            profile.Goal = new AthleteGoal { AthleteProfileId = profile.Id };
            _db.AthleteGoals.Add(profile.Goal);
        }

        profile.Goal.PrimaryGoal = request.PrimaryGoal;
        profile.Goal.SecondaryGoal = request.SecondaryGoal;
        profile.Goal.Touch();

        _db.AthleteLimitations.RemoveRange(profile.Limitations);
        foreach (var lim in request.Limitations ?? Array.Empty<LimitationDto>())
        {
            _db.AthleteLimitations.Add(new AthleteLimitation
            {
                AthleteProfileId = profile.Id,
                InjuryDescription = lim.InjuryDescription,
                PainArea = lim.PainArea,
                AvoidedExerciseId = lim.AvoidedExerciseId,
                MovementRestriction = lim.MovementRestriction
            });
        }

        _db.AthleteEquipmentItems.RemoveRange(profile.EquipmentItems);
        foreach (var eq in request.EquipmentIds ?? Array.Empty<Guid>())
        {
            _db.AthleteEquipmentItems.Add(new AthleteEquipmentItem
            {
                AthleteProfileId = profile.Id,
                EquipmentId = eq
            });
        }

        _db.AthleteBaselineLifts.RemoveRange(profile.BaselineLifts);
        foreach (var lift in request.BaselineLifts ?? Array.Empty<BaselineLiftDto>())
        {
            _db.AthleteBaselineLifts.Add(new AthleteBaselineLift
            {
                AthleteProfileId = profile.Id,
                ExerciseId = lift.ExerciseId,
                WeightKg = lift.WeightKg,
                Reps = lift.Reps
            });
        }

        await _db.SaveChangesAsync(ct);
        return Map(profile);
    }

    private static AthleteProfileDto Map(AthleteProfile p) => new(
        p.Id,
        p.DisplayName,
        p.OnboardingCompleted,
        p.Age,
        p.Sex,
        p.HeightCm,
        p.BodyWeightKg,
        p.Experience,
        p.YearsTraining,
        p.Goal?.PrimaryGoal,
        p.Goal?.SecondaryGoal,
        p.TrainingDaysPerWeek,
        p.PreferredSessionMinutes,
        p.EquipmentSetting,
        p.Limitations.Select(l => new LimitationDto(
            l.InjuryDescription, l.PainArea, l.AvoidedExerciseId, l.MovementRestriction)).ToList(),
        p.BaselineLifts.Select(b => new BaselineLiftDto(b.ExerciseId, b.WeightKg, b.Reps)).ToList());
}
