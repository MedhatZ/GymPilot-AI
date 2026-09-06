using GymCoach.Domain.Entities;
using GymCoach.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Application.Abstractions;

public interface IGymCoachDbContext
{
    DbSet<AthleteProfile> AthleteProfiles { get; }
    DbSet<AthleteGoal> AthleteGoals { get; }
    DbSet<AthleteLimitation> AthleteLimitations { get; }
    DbSet<AthleteEquipmentItem> AthleteEquipmentItems { get; }
    DbSet<AthleteBaselineLift> AthleteBaselineLifts { get; }
    DbSet<MuscleGroup> MuscleGroups { get; }
    DbSet<Equipment> Equipment { get; }
    DbSet<Exercise> Exercises { get; }
    DbSet<ExerciseMuscleGroup> ExerciseMuscleGroups { get; }
    DbSet<Domain.Entities.Program> Programs { get; }
    DbSet<ProgramVersion> ProgramVersions { get; }
    DbSet<ProgramDay> ProgramDays { get; }
    DbSet<ProgramExercise> ProgramExercises { get; }
    DbSet<WorkoutSession> WorkoutSessions { get; }
    DbSet<WorkoutExercise> WorkoutExercises { get; }
    DbSet<WorkoutSet> WorkoutSets { get; }
    DbSet<PersonalRecord> PersonalRecords { get; }
    DbSet<ExerciseMetricSnapshot> ExerciseMetricSnapshots { get; }
    DbSet<RecoveryMetric> RecoveryMetrics { get; }
    DbSet<WearableConnection> WearableConnections { get; }
    DbSet<WearableDailyMetric> WearableDailyMetrics { get; }
    DbSet<SleepMetric> SleepMetrics { get; }
    DbSet<AIAnalysis> AIAnalyses { get; }
    DbSet<AIRecommendation> AIRecommendations { get; }
    DbSet<ProgramDecision> ProgramDecisions { get; }
    DbSet<IdempotencyRecord> IdempotencyRecords { get; }
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
