using GymCoach.Application.Abstractions;
using GymCoach.Domain.Entities;
using GymCoach.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Infrastructure.Persistence;

public class GymCoachDbContext : IdentityDbContext<AppUser>, IGymCoachDbContext
{
    public GymCoachDbContext(DbContextOptions<GymCoachDbContext> options) : base(options)
    {
    }

    public DbSet<AthleteProfile> AthleteProfiles => Set<AthleteProfile>();
    public DbSet<AthleteGoal> AthleteGoals => Set<AthleteGoal>();
    public DbSet<AthleteLimitation> AthleteLimitations => Set<AthleteLimitation>();
    public DbSet<AthleteEquipmentItem> AthleteEquipmentItems => Set<AthleteEquipmentItem>();
    public DbSet<AthleteBaselineLift> AthleteBaselineLifts => Set<AthleteBaselineLift>();
    public DbSet<MuscleGroup> MuscleGroups => Set<MuscleGroup>();
    public DbSet<Equipment> Equipment => Set<Equipment>();
    public DbSet<Exercise> Exercises => Set<Exercise>();
    public DbSet<ExerciseMuscleGroup> ExerciseMuscleGroups => Set<ExerciseMuscleGroup>();
    public DbSet<Domain.Entities.Program> Programs => Set<Domain.Entities.Program>();
    public DbSet<ProgramVersion> ProgramVersions => Set<ProgramVersion>();
    public DbSet<ProgramDay> ProgramDays => Set<ProgramDay>();
    public DbSet<ProgramExercise> ProgramExercises => Set<ProgramExercise>();
    public DbSet<WorkoutSession> WorkoutSessions => Set<WorkoutSession>();
    public DbSet<WorkoutExercise> WorkoutExercises => Set<WorkoutExercise>();
    public DbSet<WorkoutSet> WorkoutSets => Set<WorkoutSet>();
    public DbSet<PersonalRecord> PersonalRecords => Set<PersonalRecord>();
    public DbSet<ExerciseMetricSnapshot> ExerciseMetricSnapshots => Set<ExerciseMetricSnapshot>();
    public DbSet<RecoveryMetric> RecoveryMetrics => Set<RecoveryMetric>();
    public DbSet<WearableConnection> WearableConnections => Set<WearableConnection>();
    public DbSet<WearableDailyMetric> WearableDailyMetrics => Set<WearableDailyMetric>();
    public DbSet<SleepMetric> SleepMetrics => Set<SleepMetric>();
    public DbSet<AIAnalysis> AIAnalyses => Set<AIAnalysis>();
    public DbSet<AIRecommendation> AIRecommendations => Set<AIRecommendation>();
    public DbSet<ProgramDecision> ProgramDecisions => Set<ProgramDecision>();
    public DbSet<IdempotencyRecord> IdempotencyRecords => Set<IdempotencyRecord>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<AthleteProfile>(e =>
        {
            e.HasIndex(x => x.UserId).IsUnique();
            e.Property(x => x.HeightCm).HasPrecision(6, 2);
            e.Property(x => x.BodyWeightKg).HasPrecision(6, 2);
            e.Property(x => x.YearsTraining).HasPrecision(4, 1);
            e.HasOne(x => x.Goal).WithOne(x => x.AthleteProfile)
                .HasForeignKey<AthleteGoal>(x => x.AthleteProfileId);
        });

        builder.Entity<Exercise>(e =>
        {
            e.HasIndex(x => x.Name);
            e.Property(x => x.DefaultLoadIncrementKg).HasPrecision(6, 2);
        });

        builder.Entity<Domain.Entities.Program>(e =>
        {
            e.ToTable("programs");
            e.HasIndex(x => new { x.AthleteProfileId, x.Status });
            e.HasOne(x => x.CurrentVersion)
                .WithMany()
                .HasForeignKey(x => x.CurrentVersionId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<ProgramVersion>(e =>
        {
            e.HasOne(x => x.PreviousVersion).WithMany().HasForeignKey(x => x.PreviousVersionId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        builder.Entity<ProgramExercise>(e =>
        {
            e.Property(x => x.StartingLoadKg).HasPrecision(8, 2);
            e.Property(x => x.TargetRir).HasPrecision(4, 1);
        });

        builder.Entity<WorkoutSession>(e =>
        {
            e.HasIndex(x => new { x.AthleteProfileId, x.ClientId }).IsUnique();
            e.HasIndex(x => new { x.AthleteProfileId, x.StartedAtUtc });
        });

        builder.Entity<WorkoutExercise>(e =>
        {
            e.HasIndex(x => new { x.ClientId }).IsUnique();
        });

        builder.Entity<WorkoutSet>(e =>
        {
            e.HasIndex(x => x.ClientId).IsUnique();
            e.Property(x => x.WeightKg).HasPrecision(8, 2);
            e.Property(x => x.Rir).HasPrecision(4, 1);
        });

        builder.Entity<AthleteBaselineLift>(e =>
        {
            e.Property(x => x.WeightKg).HasPrecision(8, 2);
        });

        builder.Entity<PersonalRecord>(e =>
        {
            e.HasIndex(x => new { x.AthleteProfileId, x.ExerciseId, x.RecordType });
            e.Property(x => x.Value).HasPrecision(10, 2);
        });

        builder.Entity<ExerciseMetricSnapshot>(e =>
        {
            e.Property(x => x.EstimatedOneRepMax).HasPrecision(10, 2);
            e.Property(x => x.TopSetWeightKg).HasPrecision(8, 2);
            e.Property(x => x.SessionVolume).HasPrecision(12, 2);
            e.Property(x => x.AverageRir).HasPrecision(4, 1);
        });

        builder.Entity<RecoveryMetric>(e =>
        {
            e.Property(x => x.ReadinessScore).HasPrecision(5, 2);
        });

        builder.Entity<WearableDailyMetric>(e =>
        {
            e.HasIndex(x => new { x.AthleteProfileId, x.Date }).IsUnique();
            e.Property(x => x.Spo2Percent).HasPrecision(5, 2);
        });

        builder.Entity<SleepMetric>(e =>
        {
            e.HasIndex(x => new { x.AthleteProfileId, x.Date });
            e.Property(x => x.DurationHours).HasPrecision(4, 2);
        });

        builder.Entity<AIRecommendation>(e =>
        {
            e.Property(x => x.Confidence).HasPrecision(4, 3);
        });

        builder.Entity<IdempotencyRecord>(e =>
        {
            e.HasIndex(x => new { x.UserId, x.Key }).IsUnique();
        });

        builder.Entity<ExerciseMuscleGroup>(e =>
        {
            e.HasIndex(x => new { x.ExerciseId, x.MuscleGroupId }).IsUnique();
        });
    }
}
