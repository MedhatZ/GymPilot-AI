using GymCoach.Domain.Common;
using GymCoach.Domain.Enums;

namespace GymCoach.Domain.Entities;

public class MuscleGroup : AuditableEntity
{
    public string Name { get; set; } = string.Empty;
    public string? ParentGroup { get; set; }
    public ICollection<ExerciseMuscleGroup> ExerciseLinks { get; set; } = new List<ExerciseMuscleGroup>();
}

public class Equipment : AuditableEntity
{
    public string Name { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
}

public class Exercise : AuditableEntity
{
    public string Name { get; set; } = string.Empty;
    public ExerciseCategory Category { get; set; }
    public MovementPattern MovementPattern { get; set; }
    public bool IsCompound { get; set; }
    public decimal DefaultLoadIncrementKg { get; set; } = 2.5m;
    public string? ContraindicationNotes { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsCustom { get; set; }
    public string? CreatedByUserId { get; set; }
    public Guid? PrimaryEquipmentId { get; set; }
    public Equipment? PrimaryEquipment { get; set; }
    public string SuitableGoalsCsv { get; set; } = string.Empty;

    public ICollection<ExerciseMuscleGroup> MuscleGroups { get; set; } = new List<ExerciseMuscleGroup>();
}

public class ExerciseMuscleGroup : AuditableEntity
{
    public Guid ExerciseId { get; set; }
    public Exercise? Exercise { get; set; }
    public Guid MuscleGroupId { get; set; }
    public MuscleGroup? MuscleGroup { get; set; }
    public bool IsPrimary { get; set; }
}
