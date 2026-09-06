using GymCoach.Domain.Entities;
using GymCoach.Domain.Enums;
using GymCoach.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace GymCoach.Infrastructure.Seeding;

public static class ExerciseLibrarySeeder
{
    public static async Task SeedAsync(IServiceProvider services, CancellationToken ct = default)
    {
        using var scope = services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<GymCoachDbContext>();
        var logger = scope.ServiceProvider.GetRequiredService<ILoggerFactory>().CreateLogger("ExerciseLibrarySeeder");

        await db.Database.EnsureCreatedAsync(ct);

        if (await db.Exercises.AnyAsync(ct))
        {
            logger.LogInformation("Exercise library already seeded.");
            return;
        }

        var muscles = new[]
        {
            new MuscleGroup { Name = "Chest" },
            new MuscleGroup { Name = "Back" },
            new MuscleGroup { Name = "Quads" },
            new MuscleGroup { Name = "Hamstrings" },
            new MuscleGroup { Name = "Glutes" },
            new MuscleGroup { Name = "Shoulders" },
            new MuscleGroup { Name = "Biceps" },
            new MuscleGroup { Name = "Triceps" },
            new MuscleGroup { Name = "Core" },
            new MuscleGroup { Name = "Calves" }
        };
        db.MuscleGroups.AddRange(muscles);

        var equipment = new[]
        {
            new Equipment { Name = "Barbell" },
            new Equipment { Name = "Dumbbell" },
            new Equipment { Name = "Cable" },
            new Equipment { Name = "Machine" },
            new Equipment { Name = "Bodyweight" },
            new Equipment { Name = "Pull-up Bar" }
        };
        db.Equipment.AddRange(equipment);
        await db.SaveChangesAsync(ct);

        MuscleGroup M(string n) => muscles.First(x => x.Name == n);
        Equipment E(string n) => equipment.First(x => x.Name == n);

        var catalog = new List<(string Name, MovementPattern Pattern, bool Compound, string Eq, string Primary, string? Secondary, decimal Inc)>
        {
            ("Back Squat", MovementPattern.Squat, true, "Barbell", "Quads", "Glutes", 2.5m),
            ("Romanian Deadlift", MovementPattern.Hinge, true, "Barbell", "Hamstrings", "Glutes", 2.5m),
            ("Conventional Deadlift", MovementPattern.Hinge, true, "Barbell", "Back", "Hamstrings", 2.5m),
            ("Bench Press", MovementPattern.HorizontalPush, true, "Barbell", "Chest", "Triceps", 2.5m),
            ("Incline Dumbbell Press", MovementPattern.HorizontalPush, true, "Dumbbell", "Chest", "Shoulders", 2.0m),
            ("Barbell Row", MovementPattern.HorizontalPull, true, "Barbell", "Back", "Biceps", 2.5m),
            ("Lat Pulldown", MovementPattern.VerticalPull, true, "Cable", "Back", "Biceps", 2.5m),
            ("Pull-Up", MovementPattern.VerticalPull, true, "Pull-up Bar", "Back", "Biceps", 0m),
            ("Overhead Press", MovementPattern.VerticalPush, true, "Barbell", "Shoulders", "Triceps", 2.5m),
            ("Lateral Raise", MovementPattern.Other, false, "Dumbbell", "Shoulders", null, 1.0m),
            ("Barbell Curl", MovementPattern.Other, false, "Barbell", "Biceps", null, 2.5m),
            ("Triceps Pushdown", MovementPattern.Other, false, "Cable", "Triceps", null, 2.5m),
            ("Leg Press", MovementPattern.Squat, true, "Machine", "Quads", "Glutes", 5.0m),
            ("Leg Curl", MovementPattern.Hinge, false, "Machine", "Hamstrings", null, 2.5m),
            ("Calf Raise", MovementPattern.Other, false, "Machine", "Calves", null, 5.0m),
            ("Plank", MovementPattern.Core, false, "Bodyweight", "Core", null, 0m),
            ("Walking Lunge", MovementPattern.Lunge, true, "Dumbbell", "Quads", "Glutes", 2.0m),
            ("Hip Thrust", MovementPattern.Hinge, true, "Barbell", "Glutes", "Hamstrings", 2.5m),
            ("Cable Fly", MovementPattern.HorizontalPush, false, "Cable", "Chest", null, 2.5m),
            ("Face Pull", MovementPattern.HorizontalPull, false, "Cable", "Shoulders", "Back", 2.5m)
        };

        foreach (var item in catalog)
        {
            var ex = new Exercise
            {
                Name = item.Name,
                Category = item.Compound ? ExerciseCategory.Compound : ExerciseCategory.Isolation,
                MovementPattern = item.Pattern,
                IsCompound = item.Compound,
                DefaultLoadIncrementKg = item.Inc,
                PrimaryEquipmentId = E(item.Eq).Id,
                SuitableGoalsCsv = "Hypertrophy,Strength,StrengthHypertrophy,BodyRecomp,GeneralFitness",
                IsActive = true
            };
            db.Exercises.Add(ex);
            await db.SaveChangesAsync(ct);
            db.ExerciseMuscleGroups.Add(new ExerciseMuscleGroup
            {
                ExerciseId = ex.Id,
                MuscleGroupId = M(item.Primary).Id,
                IsPrimary = true
            });
            if (item.Secondary != null)
            {
                db.ExerciseMuscleGroups.Add(new ExerciseMuscleGroup
                {
                    ExerciseId = ex.Id,
                    MuscleGroupId = M(item.Secondary).Id,
                    IsPrimary = false
                });
            }
        }

        await db.SaveChangesAsync(ct);
        logger.LogInformation("Seeded {Count} exercises.", catalog.Count);
    }
}
