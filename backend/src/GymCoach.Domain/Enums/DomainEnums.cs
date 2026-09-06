namespace GymCoach.Domain.Enums;

public enum ProgramStatus
{
    Active = 0,
    Paused = 1,
    Replaced = 2,
    Archived = 3
}

public enum TrainingExperience
{
    Beginner = 0,
    Intermediate = 1,
    Advanced = 2
}

public enum TrainingGoal
{
    Hypertrophy = 0,
    Strength = 1,
    StrengthHypertrophy = 2,
    BodyRecomp = 3,
    GeneralFitness = 4
}

public enum EquipmentSetting
{
    FullGym = 0,
    HomeGym = 1,
    Custom = 2
}

public enum BiologicalSex
{
    Male = 0,
    Female = 1,
    Other = 2,
    PreferNotToSay = 3
}

public enum PlateauState
{
    Normal = 0,
    Monitoring = 1,
    PossiblePlateau = 2,
    ConfirmedPlateau = 3
}

public enum DecisionType
{
    Continue = 0,
    ProgressLoad = 1,
    ProgressReps = 2,
    ReduceLoad = 3,
    ReduceVolume = 4,
    IncreaseVolume = 5,
    ChangeRepRange = 6,
    ReplaceExercise = 7,
    Deload = 8,
    ProgramAdjustment = 9,
    NewProgram = 10
}

public enum DecisionScope
{
    Set = 0,
    Exercise = 1,
    Workout = 2,
    Program = 3
}

public enum WorkoutDifficulty
{
    VeryEasy = 0,
    Good = 1,
    Hard = 2,
    VeryHard = 3
}

public enum SetType
{
    WarmUp = 0,
    Working = 1
}

public enum SyncOperationStatus
{
    Pending = 0,
    InFlight = 1,
    Succeeded = 2,
    Failed = 3,
    DeadLetter = 4
}

public enum ProgramDaySplit
{
    FullBody = 0,
    Upper = 1,
    Lower = 2,
    Push = 3,
    Pull = 4,
    Legs = 5,
    Custom = 6
}

public enum ExerciseCategory
{
    Compound = 0,
    Isolation = 1,
    Olympic = 2,
    Bodyweight = 3,
    Other = 4
}

public enum MovementPattern
{
    HorizontalPush = 0,
    HorizontalPull = 1,
    VerticalPush = 2,
    VerticalPull = 3,
    Squat = 4,
    Hinge = 5,
    Lunge = 6,
    Carry = 7,
    Core = 8,
    Other = 9
}

public enum PersonalRecordType
{
    Weight = 0,
    Reps = 1,
    EstimatedOneRepMax = 2,
    Volume = 3
}

public enum TrendDirection
{
    Declining = -1,
    Stable = 0,
    Positive = 1
}

public enum PolicyValidationResult
{
    Approved = 0,
    Downgraded = 1,
    Rejected = 2
}
