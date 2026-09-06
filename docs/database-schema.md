# GymCoach AI — Database Schema

PostgreSQL via EF Core. UUIDs for primary keys. All timestamps UTC. Soft status fields preferred over hard deletes for historical training data.

## Conventions

- `Id` UUID PK
- `CreatedAtUtc`, `UpdatedAtUtc`
- `xmin` / rowversion where optimistic concurrency is required (sessions, sync)
- Unique `(UserId, ClientId)` on workout entities for idempotent sync

## Tables (logical)

### auth / profile
- `AspNetUsers` (+ Identity tables)
- `athlete_profiles`
- `athlete_goals`
- `athlete_limitations`
- `athlete_equipment_items`
- `athlete_baseline_lifts`

### catalog
- `muscle_groups`
- `equipment`
- `exercises`
- `exercise_muscle_groups`

### programs
- `programs` — Status, StartDateUtc, EndDateUtc NULL, CurrentVersionId
- `program_versions`
- `program_days`
- `program_exercises`

### workouts
- `workout_sessions` — ClientId UNIQUE per user
- `workout_exercises` — ClientId UNIQUE per user
- `workout_sets` — ClientId UNIQUE per user

### metrics
- `exercise_metrics`
- `personal_records`
- `recovery_metrics`

### wearable
- `wearable_connections`
- `wearable_daily_metrics`
- `sleep_metrics`

### ai / decisions
- `ai_analyses`
- `ai_recommendations`
- `program_decisions` — full audit: input snapshot JSON, rule result, AI output, policy result, final decision

### sync
- `idempotency_records` — Key, UserId, ResponseHash, CreatedAtUtc

## Indexes (key)

- `workout_sessions (athlete_id, started_at_utc DESC)`
- `workout_sets (workout_exercise_id, set_number)`
- `personal_records (athlete_id, exercise_id, record_type)`
- `program_decisions (athlete_id, created_at_utc DESC)`
- `exercises (is_active, name)`

## Migration policy

- Every schema change = EF migration
- Seed exercise library via migration or `IDataSeeder` at startup (dev/prod controlled)
