using GymCoach.Application.Abstractions;
using GymCoach.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Application.Exercises;

public sealed record ExerciseDto(
    Guid Id,
    string Name,
    string Category,
    string MovementPattern,
    bool IsCompound,
    decimal DefaultLoadIncrementKg,
    IReadOnlyList<string> PrimaryMuscles);

public interface IExerciseQueryService
{
    Task<IReadOnlyList<ExerciseDto>> ListAsync(CancellationToken ct = default);
    Task<ExerciseDto?> GetAsync(Guid id, CancellationToken ct = default);
}

public sealed class ExerciseQueryService : IExerciseQueryService
{
    private readonly IGymCoachDbContext _db;

    public ExerciseQueryService(IGymCoachDbContext db) => _db = db;

    public async Task<IReadOnlyList<ExerciseDto>> ListAsync(CancellationToken ct = default)
    {
        var items = await _db.Exercises.AsNoTracking()
            .Where(e => e.IsActive)
            .Include(e => e.MuscleGroups).ThenInclude(m => m.MuscleGroup)
            .OrderBy(e => e.Name)
            .ToListAsync(ct);
        return items.Select(Map).ToList();
    }

    public async Task<ExerciseDto?> GetAsync(Guid id, CancellationToken ct = default)
    {
        var e = await _db.Exercises.AsNoTracking()
            .Include(x => x.MuscleGroups).ThenInclude(m => m.MuscleGroup)
            .FirstOrDefaultAsync(x => x.Id == id, ct);
        return e is null ? null : Map(e);
    }

    private static ExerciseDto Map(Exercise e) => new(
        e.Id,
        e.Name,
        e.Category.ToString(),
        e.MovementPattern.ToString(),
        e.IsCompound,
        e.DefaultLoadIncrementKg,
        e.MuscleGroups.Where(m => m.IsPrimary).Select(m => m.MuscleGroup!.Name).ToList());
}
