using GymCoach.Domain.Common;
using GymCoach.Domain.Enums;

namespace GymCoach.Domain.Entities;

public class AthleteProfile : AuditableEntity
{
    public string UserId { get; set; } = string.Empty;
    public string DisplayName { get; set; } = string.Empty;
    public int Age { get; set; }
    public BiologicalSex Sex { get; set; }
    public decimal HeightCm { get; set; }
    public decimal BodyWeightKg { get; set; }
    public TrainingExperience Experience { get; set; }
    public decimal YearsTraining { get; set; }
    public bool OnboardingCompleted { get; set; }
    public EquipmentSetting EquipmentSetting { get; set; } = EquipmentSetting.FullGym;
    public int TrainingDaysPerWeek { get; set; } = 3;
    public int PreferredSessionMinutes { get; set; } = 60;

    public AthleteGoal? Goal { get; set; }
    public ICollection<AthleteLimitation> Limitations { get; set; } = new List<AthleteLimitation>();
    public ICollection<AthleteEquipmentItem> EquipmentItems { get; set; } = new List<AthleteEquipmentItem>();
    public ICollection<AthleteBaselineLift> BaselineLifts { get; set; } = new List<AthleteBaselineLift>();
}

public class AthleteGoal : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public AthleteProfile? AthleteProfile { get; set; }
    public TrainingGoal PrimaryGoal { get; set; }
    public TrainingGoal? SecondaryGoal { get; set; }
}

public class AthleteLimitation : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public AthleteProfile? AthleteProfile { get; set; }
    public string? InjuryDescription { get; set; }
    public string? PainArea { get; set; }
    public Guid? AvoidedExerciseId { get; set; }
    public string? MovementRestriction { get; set; }
}

public class AthleteEquipmentItem : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public AthleteProfile? AthleteProfile { get; set; }
    public Guid EquipmentId { get; set; }
    public Equipment? Equipment { get; set; }
}

public class AthleteBaselineLift : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public AthleteProfile? AthleteProfile { get; set; }
    public Guid ExerciseId { get; set; }
    public Exercise? Exercise { get; set; }
    public decimal WeightKg { get; set; }
    public int Reps { get; set; }
}
