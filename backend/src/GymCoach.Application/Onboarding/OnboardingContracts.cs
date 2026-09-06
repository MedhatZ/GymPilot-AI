using GymCoach.Domain.Enums;

namespace GymCoach.Application.Onboarding;

public sealed record OnboardingRequest(
    string DisplayName,
    int Age,
    BiologicalSex Sex,
    decimal HeightCm,
    decimal BodyWeightKg,
    TrainingExperience Experience,
    decimal YearsTraining,
    TrainingGoal PrimaryGoal,
    TrainingGoal? SecondaryGoal,
    int TrainingDaysPerWeek,
    int PreferredSessionMinutes,
    EquipmentSetting EquipmentSetting,
    IReadOnlyList<Guid>? EquipmentIds,
    IReadOnlyList<LimitationDto>? Limitations,
    IReadOnlyList<BaselineLiftDto>? BaselineLifts);

public sealed record LimitationDto(string? InjuryDescription, string? PainArea, Guid? AvoidedExerciseId, string? MovementRestriction);
public sealed record BaselineLiftDto(Guid ExerciseId, decimal WeightKg, int Reps);
public sealed record AthleteProfileDto(
    Guid Id,
    string DisplayName,
    bool OnboardingCompleted,
    int Age,
    BiologicalSex Sex,
    decimal HeightCm,
    decimal BodyWeightKg,
    TrainingExperience Experience,
    decimal YearsTraining,
    TrainingGoal? PrimaryGoal,
    TrainingGoal? SecondaryGoal,
    int TrainingDaysPerWeek,
    int PreferredSessionMinutes,
    EquipmentSetting EquipmentSetting,
    IReadOnlyList<LimitationDto> Limitations,
    IReadOnlyList<BaselineLiftDto> BaselineLifts);

public interface IOnboardingService
{
    Task<AthleteProfileDto> CompleteAsync(string userId, OnboardingRequest request, CancellationToken ct = default);
    Task<AthleteProfileDto?> GetAsync(string userId, CancellationToken ct = default);
}
