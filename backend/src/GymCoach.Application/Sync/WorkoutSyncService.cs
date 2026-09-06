using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using GymCoach.Application.Abstractions;
using GymCoach.Application.Workouts;
using GymCoach.Domain.Entities;
using GymCoach.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace GymCoach.Application.Sync;

public sealed record SyncWorkoutBatchRequest(IReadOnlyList<SyncWorkoutSessionDto> Sessions);
public sealed record SyncWorkoutSessionDto(
    Guid ClientId,
    Guid? ProgramDayId,
    DateTime StartedAtUtc,
    DateTime? CompletedAtUtc,
    WorkoutDifficulty? Difficulty,
    bool PainReported,
    string? PainLocation,
    Guid? PainExerciseId,
    string? Notes,
    IReadOnlyList<SyncWorkoutExerciseDto> Exercises);

public sealed record SyncWorkoutExerciseDto(
    Guid ClientId,
    Guid ExerciseId,
    int Order,
    IReadOnlyList<SyncWorkoutSetDto> Sets);

public sealed record SyncWorkoutSetDto(
    Guid ClientId,
    int SetNumber,
    decimal WeightKg,
    int Reps,
    decimal? Rir,
    SetType SetType,
    DateTime CompletedAtUtc,
    string? Note);

public sealed record SyncWorkoutBatchResponse(IReadOnlyList<Guid> UpsertedSessionClientIds, int UpsertedSetCount);

public interface IWorkoutSyncService
{
    Task<SyncWorkoutBatchResponse> UpsertBatchAsync(
        string userId,
        SyncWorkoutBatchRequest request,
        string? idempotencyKey,
        CancellationToken ct = default);
}

public sealed class WorkoutSyncService : IWorkoutSyncService
{
    private readonly IGymCoachDbContext _db;
    private readonly IWorkoutService _workouts;

    public WorkoutSyncService(IGymCoachDbContext db, IWorkoutService workouts)
    {
        _db = db;
        _workouts = workouts;
    }

    public async Task<SyncWorkoutBatchResponse> UpsertBatchAsync(
        string userId,
        SyncWorkoutBatchRequest request,
        string? idempotencyKey,
        CancellationToken ct = default)
    {
        if (!string.IsNullOrWhiteSpace(idempotencyKey))
        {
            var hash = Hash(JsonSerializer.Serialize(request));
            var existing = await _db.IdempotencyRecords
                .FirstOrDefaultAsync(r => r.UserId == userId && r.Key == idempotencyKey, ct);
            if (existing != null && existing.RequestHash == hash)
            {
                var cached = JsonSerializer.Deserialize<SyncWorkoutBatchResponse>(existing.ResponseBody);
                if (cached != null) return cached;
            }
        }

        var profile = await _db.AthleteProfiles.FirstOrDefaultAsync(p => p.UserId == userId, ct)
                      ?? throw new InvalidOperationException("Athlete profile not found.");

        var upsertedSessions = new List<Guid>();
        var setCount = 0;

        foreach (var sessionDto in request.Sessions)
        {
            await _workouts.StartAsync(userId, new StartWorkoutRequest(
                sessionDto.ProgramDayId, sessionDto.ClientId, sessionDto.StartedAtUtc), ct);

            foreach (var ex in sessionDto.Exercises)
            {
                foreach (var set in ex.Sets)
                {
                    await _workouts.LogSetAsync(userId, sessionDto.ClientId, new LogSetRequest(
                        ex.ClientId,
                        set.ClientId,
                        ex.ExerciseId,
                        ex.Order,
                        set.SetNumber,
                        set.WeightKg,
                        set.Reps,
                        set.Rir,
                        set.SetType,
                        set.Note,
                        set.CompletedAtUtc), ct);
                    setCount++;
                }
            }

            if (sessionDto.CompletedAtUtc.HasValue && sessionDto.Difficulty.HasValue)
            {
                await _workouts.CompleteAsync(userId, new CompleteWorkoutRequest(
                    sessionDto.ClientId,
                    sessionDto.Difficulty.Value,
                    sessionDto.PainReported,
                    sessionDto.PainLocation,
                    sessionDto.PainExerciseId,
                    sessionDto.Notes,
                    sessionDto.CompletedAtUtc.Value), ct);
            }

            upsertedSessions.Add(sessionDto.ClientId);
        }

        var response = new SyncWorkoutBatchResponse(upsertedSessions, setCount);

        if (!string.IsNullOrWhiteSpace(idempotencyKey))
        {
            _db.IdempotencyRecords.Add(new IdempotencyRecord
            {
                UserId = userId,
                Key = idempotencyKey,
                RequestHash = Hash(JsonSerializer.Serialize(request)),
                StatusCode = 200,
                ResponseBody = JsonSerializer.Serialize(response)
            });
            await _db.SaveChangesAsync(ct);
        }

        return response;
    }

    private static string Hash(string input)
    {
        var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(input));
        return Convert.ToHexString(bytes);
    }
}
