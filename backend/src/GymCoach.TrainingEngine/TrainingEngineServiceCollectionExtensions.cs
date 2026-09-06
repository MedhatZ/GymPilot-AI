using GymCoach.TrainingEngine.Decisions;
using GymCoach.TrainingEngine.Metrics;
using GymCoach.TrainingEngine.Options;
using GymCoach.TrainingEngine.Overload;
using GymCoach.TrainingEngine.Plateau;
using GymCoach.TrainingEngine.Recovery;
using Microsoft.Extensions.DependencyInjection;

namespace GymCoach.TrainingEngine;

public static class TrainingEngineServiceCollectionExtensions
{
    public static IServiceCollection AddGymCoachTrainingEngine(this IServiceCollection services)
    {
        services.AddSingleton<IEstimatedOneRepMaxCalculator, EpleyOneRepMaxCalculator>();
        services.AddSingleton<ITrainingMetricsEngine, TrainingMetricsEngine>();
        services.AddSingleton<IProgressiveOverloadEngine, ProgressiveOverloadEngine>();
        services.AddSingleton<IPlateauDetectionEngine, PlateauDetectionEngine>();
        services.AddSingleton<IProgramDecisionEngine, ProgramDecisionEngine>();
        services.AddSingleton<ITrainingPolicyValidator, TrainingPolicyValidator>();
        services.AddSingleton<IRecoveryModel, RecoveryModel>();
        services.AddSingleton<IPersonalRecordDetector, PersonalRecordDetector>();
        services.AddOptions<TrainingPolicyOptions>();
        return services;
    }
}
