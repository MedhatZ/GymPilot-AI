using GymCoach.Domain.Common;
using GymCoach.Domain.Enums;

namespace GymCoach.Domain.Entities;

public class WorkoutSession : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public AthleteProfile? AthleteProfile { get; set; }
    public Guid ClientId { get; set; }
    public Guid? ProgramId { get; set; }
    public Guid? ProgramDayId { get; set; }
    public DateTime StartedAtUtc { get; set; }
    public DateTime? CompletedAtUtc { get; set; }
    public WorkoutDifficulty? Difficulty { get; set; }
    public bool PainReported { get; set; }
    public string? PainLocation { get; set; }
    public Guid? PainExerciseId { get; set; }
    public string? Notes { get; set; }
    public bool IsCompleted => CompletedAtUtc.HasValue;
    public ICollection<WorkoutExercise> Exercises { get; set; } = new List<WorkoutExercise>();
}

public class WorkoutExercise : AuditableEntity
{
    public Guid WorkoutSessionId { get; set; }
    public WorkoutSession? WorkoutSession { get; set; }
    public Guid ClientId { get; set; }
    public Guid ExerciseId { get; set; }
    public Exercise? Exercise { get; set; }
    public int Order { get; set; }
    public string? RecommendationNote { get; set; }
    public ICollection<WorkoutSet> Sets { get; set; } = new List<WorkoutSet>();
}

public class WorkoutSet : AuditableEntity
{
    public Guid WorkoutExerciseId { get; set; }
    public WorkoutExercise? WorkoutExercise { get; set; }
    public Guid ClientId { get; set; }
    public int SetNumber { get; set; }
    public decimal WeightKg { get; set; }
    public int Reps { get; set; }
    public decimal? Rir { get; set; }
    public DateTime CompletedAtUtc { get; set; }
    public SetType SetType { get; set; } = SetType.Working;
    public string? Note { get; set; }
}
