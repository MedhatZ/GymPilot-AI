using GymCoach.Domain.Common;
using GymCoach.Domain.Enums;

namespace GymCoach.Domain.Entities;

public class Program : AuditableEntity
{
    public Guid AthleteProfileId { get; set; }
    public AthleteProfile? AthleteProfile { get; set; }
    public string Name { get; set; } = string.Empty;
    public ProgramStatus Status { get; set; } = ProgramStatus.Active;
    public DateTime StartDateUtc { get; set; } = DateTime.UtcNow;
    /// <summary>Normally null — programs do not expire on a calendar.</summary>
    public DateTime? EndDateUtc { get; set; }
    public Guid? CurrentVersionId { get; set; }
    public ProgramVersion? CurrentVersion { get; set; }
    public ICollection<ProgramVersion> Versions { get; set; } = new List<ProgramVersion>();
}

public class ProgramVersion : AuditableEntity
{
    public Guid ProgramId { get; set; }
    public Program? Program { get; set; }
    public int VersionNumber { get; set; } = 1;
    public string Trigger { get; set; } = "InitialGeneration";
    public string Reason { get; set; } = "Initial program generated from athlete profile.";
    public Guid? PreviousVersionId { get; set; }
    public ProgramVersion? PreviousVersion { get; set; }
    public Guid? AiRecommendationId { get; set; }
    public bool IsDeload { get; set; }
    public ICollection<ProgramDay> Days { get; set; } = new List<ProgramDay>();
}

public class ProgramDay : AuditableEntity
{
    public Guid ProgramVersionId { get; set; }
    public ProgramVersion? ProgramVersion { get; set; }
    public int DayIndex { get; set; }
    public string Name { get; set; } = string.Empty;
    public ProgramDaySplit Split { get; set; }
    public ICollection<ProgramExercise> Exercises { get; set; } = new List<ProgramExercise>();
}

public class ProgramExercise : AuditableEntity
{
    public Guid ProgramDayId { get; set; }
    public ProgramDay? ProgramDay { get; set; }
    public Guid ExerciseId { get; set; }
    public Exercise? Exercise { get; set; }
    public int Order { get; set; }
    public int Sets { get; set; }
    public int MinReps { get; set; }
    public int MaxReps { get; set; }
    public decimal? StartingLoadKg { get; set; }
    public int RestSeconds { get; set; } = 120;
    public decimal? TargetRir { get; set; }
    public string? Notes { get; set; }
}
