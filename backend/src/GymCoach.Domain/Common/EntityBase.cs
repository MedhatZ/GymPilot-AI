namespace GymCoach.Domain.Common;

public abstract class EntityBase
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAtUtc { get; set; } = DateTime.UtcNow;
}

public abstract class AuditableEntity : EntityBase
{
    public void Touch() => UpdatedAtUtc = DateTime.UtcNow;
}
