# GymCoach AI — Domain Model

## Core concepts

### Athlete
Authenticated user with profile, goals, limitations, equipment, and optional baseline strength.

### Program (ongoing, not time-boxed)
An active coaching plan. Status: `Active | Paused | Replaced | Archived`.  
`EndDate` is normally **null**. Lifetime is driven by evidence, not weeks.

### ProgramVersion
Immutable snapshot of prescriptions. Changes create a new version linked via `PreviousVersionId`, with trigger + reason (+ optional AI recommendation id).

### WorkoutSession
A logged training session (planned or free). Contains exercises and sets. Identified by server UUID and client-generated `ClientId` for offline sync.

### Exercise library
Canonical movements with muscles, equipment, movement pattern, default load increment, contraindications.

### Decision
Outcome of the training decision pipeline: type + scope + reason + confidence + audit trail.

## Enums

| Enum | Values |
|------|--------|
| `ProgramStatus` | Active, Paused, Replaced, Archived |
| `TrainingExperience` | Beginner, Intermediate, Advanced |
| `TrainingGoal` | Hypertrophy, Strength, StrengthHypertrophy, BodyRecomp, GeneralFitness |
| `EquipmentSetting` | FullGym, HomeGym, Custom |
| `PlateauState` | Normal, Monitoring, PossiblePlateau, ConfirmedPlateau |
| `DecisionType` | Continue, ProgressLoad, ProgressReps, ReduceLoad, ReduceVolume, IncreaseVolume, ChangeRepRange, ReplaceExercise, Deload, ProgramAdjustment, NewProgram |
| `DecisionScope` | Set, Exercise, Workout, Program |
| `WorkoutDifficulty` | VeryEasy, Good, Hard, VeryHard |
| `SetType` | WarmUp, Working |
| `SyncOperationStatus` | Pending, InFlight, Succeeded, Failed, DeadLetter |
| `ProgramDaySplit` | FullBody, Upper, Lower, Push, Pull, Legs, Custom |

## Aggregates & entities

### Identity & profile
- `User` (Identity)
- `AthleteProfile` — name, age, sex, heightCm, bodyWeightKg, experience, yearsTraining
- `AthleteGoal` — primary + optional secondary `TrainingGoal`
- `AthleteLimitation` — injuries, pain areas, avoided exercise ids, movement restrictions
- `AthleteEquipment` — setting + equipment ids
- `AthleteBaselineLift` — optional recent performance (exercise, weight, reps)

### Catalog
- `Exercise`, `MuscleGroup`, `ExerciseMuscleGroup`, `Equipment`

### Programming
- `Program` — athleteId, name, status, startDate, endDate (nullable), currentVersionId
- `ProgramVersion` — programId, versionNumber, createdAt, trigger, reason, previousVersionId, aiRecommendationId
- `ProgramDay` — versionId, dayIndex, name, split
- `ProgramExercise` — dayId, exerciseId, order, sets, minReps, maxReps, startingLoad, restSeconds, targetRir, notes

### Logging
- `WorkoutSession` — clientId, programDayId?, startedAt, completedAt, difficulty, painReported, notes
- `WorkoutExercise` — sessionId, exerciseId, order, clientId
- `WorkoutSet` — weightKg, reps, rir?, completedAt, setType, note, clientId

### Derived
- `ExerciseMetric`, `PersonalRecord`, `RecoveryMetric`

### Wearable
- `WearableConnection`, `WearableDailyMetric`, `SleepMetric`

### AI & decisions
- `AIAnalysis`, `AIRecommendation`, `ProgramDecision`

### Sync
- `SyncOperation` — client-side outbox mirrored optionally server-side for idempotency keys

## Invariants

1. Only one `Active` program per athlete.
2. Program version prescriptions are append-only (new version on change).
3. Deload adjusts intensity/volume; does **not** create a new program by default.
4. Wearable signals never independently replace a program.
5. Workout logging must succeed without wearable or AI availability.
