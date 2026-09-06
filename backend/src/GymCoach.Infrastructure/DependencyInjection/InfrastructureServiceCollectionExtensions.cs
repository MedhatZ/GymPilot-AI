using GymCoach.Application.Abstractions;
using GymCoach.Application.Auth;
using GymCoach.Application.Personal;
using GymCoach.AI;
using GymCoach.Infrastructure.Auth;
using GymCoach.Infrastructure.Identity;
using GymCoach.Infrastructure.Persistence;
using GymCoach.TrainingEngine;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace GymCoach.Infrastructure.DependencyInjection;

public static class InfrastructureServiceCollectionExtensions
{
    public static IServiceCollection AddGymCoachInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("Default")
                               ?? "Host=localhost;Port=5432;Database=gymcoach;Username=gymcoach;Password=gymcoach";

        var useInMemory = configuration.GetValue("Database:UseInMemory", true);
        services.AddDbContext<GymCoachDbContext>(options =>
        {
            if (useInMemory)
                options.UseInMemoryDatabase("GymCoach");
            else
                options.UseNpgsql(connectionString);
        });
        services.AddScoped<IGymCoachDbContext>(sp => sp.GetRequiredService<GymCoachDbContext>());

        services
            .AddIdentity<AppUser, IdentityRole>(options =>
            {
                options.Password.RequiredLength = 8;
                options.Password.RequireNonAlphanumeric = false;
                options.User.RequireUniqueEmail = true;
            })
            .AddEntityFrameworkStores<GymCoachDbContext>()
            .AddDefaultTokenProviders();

        services.Configure<JwtOptions>(configuration.GetSection(JwtOptions.SectionName));
        services.Configure<PersonalModeOptions>(configuration.GetSection(PersonalModeOptions.SectionName));
        services.AddSingleton<IPersonalModeAccessor, PersonalModeAccessor>();
        services.AddSingleton<ITokenService, JwtTokenService>();
        services.AddSingleton<RefreshTokenStore>();
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<IPersonalBootstrapService, PersonalBootstrapService>();

        services.AddGymCoachTrainingEngine();
        services.AddGymCoachAi(configuration);

        return services;
    }
}
