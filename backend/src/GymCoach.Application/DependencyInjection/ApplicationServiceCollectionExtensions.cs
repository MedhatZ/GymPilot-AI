using FluentValidation;
using GymCoach.Application.Auth;
using GymCoach.Application.Coach;
using GymCoach.Application.Exercises;
using GymCoach.Application.Onboarding;
using GymCoach.Application.Programs;
using GymCoach.Application.Progress;
using GymCoach.Application.Sync;
using GymCoach.Application.Workouts;
using Microsoft.Extensions.DependencyInjection;

namespace GymCoach.Application.DependencyInjection;

public static class ApplicationServiceCollectionExtensions
{
    public static IServiceCollection AddGymCoachApplication(this IServiceCollection services)
    {
        services.AddValidatorsFromAssemblyContaining<RegisterRequestValidator>();
        services.AddScoped<IOnboardingService, OnboardingService>();
        services.AddScoped<IExerciseQueryService, ExerciseQueryService>();
        services.AddScoped<IProgramGenerationService, ProgramGenerationService>();
        services.AddScoped<IProgramVersioningService, ProgramVersioningService>();
        services.AddScoped<IWorkoutService, WorkoutService>();
        services.AddScoped<INextWorkoutService, NextWorkoutService>();
        services.AddScoped<IWorkoutSummaryService, WorkoutSummaryService>();
        services.AddScoped<IWorkoutSyncService, WorkoutSyncService>();
        services.AddScoped<ICoachService, CoachService>();
        services.AddScoped<IProgressService, ProgressService>();
        services.AddScoped<IHomeService, HomeService>();
        return services;
    }
}
