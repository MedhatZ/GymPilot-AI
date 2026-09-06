# GymCoach AI — Training Engine

Deterministic engines live in `GymCoach.TrainingEngine`. LLMs must not compute these values.

## Estimated 1RM

Default: **Epley** — `e1RM = weight * (1 + reps/30)` for reps > 1; else weight.  
Behind `IEstimatedOneRepMaxCalculator` so formula can change.

## Metrics Engine

Computes (from structured sets):

- Total / exercise / muscle-group volume
- Estimated 1RM, top set, rep PR, weight PR, e1RM PR
- Average RIR, exercise frequency, adherence, session frequency
- Strength / volume / performance trends
- Recent exposure count

## Progressive Overload

Given prescription (sets, min–max reps, target RIR) and completed working sets:

- All working sets at **max reps** with RIR ≥ policy threshold → suggest load + `DefaultLoadIncrement`
- Below min reps → hold or small reduction
- In range → progress reps before load when appropriate

Output: suggested load, suggested reps, reason, confidence.

## Plateau Detection

FSM: `Normal → Monitoring → PossiblePlateau → ConfirmedPlateau`

Requires **multiple exposures**. One poor session ≠ plateau.  
Considers e1RM trend, weight/rep progression, RIR trend, adherence, recovery (supporting), related lifts.  
Thresholds in `TrainingPolicyOptions` (centralized).

## Local vs global

- **Local:** one exercise stalled → exercise-scoped actions only (rep range, load, volume, variation, replace). Never auto-replace whole program.
- **Global:** several key lifts decline + fatigue signals → deload / load-volume adjust.

## Deload

Temporary reduction of volume and/or intensity on the **same program**. After deload, return toward prior prescriptions. **Does not** auto-create a new program.

## Program Decision Engine

Decision types: Continue, ProgressLoad, ProgressReps, ReduceLoad, ReduceVolume, IncreaseVolume, ChangeRepRange, ReplaceExercise, Deload, ProgramAdjustment, NewProgram.  
Scopes: Set, Exercise, Workout, Program.

**Default: Continue** when progress exists.  
**NewProgram** only after persistent multi-exercise plateaus despite adherence, recovery, overload attempts, minor adjustments, and deload when indicated.

## Policy guardrails

Testable without AI:

- Reject/downgrade NewProgram if overall progression positive or insufficient exposures on current version
- Single low-recovery day ≠ new program
- Single failed session ≠ plateau
- Wearable-only signals never force NewProgram
