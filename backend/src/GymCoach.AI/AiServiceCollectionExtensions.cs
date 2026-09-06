using GymCoach.AI.Clients;
using GymCoach.AI.Context;
using GymCoach.AI.Providers;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace GymCoach.AI;

public static class AiServiceCollectionExtensions
{
    public static IServiceCollection AddGymCoachAi(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<AiOptions>(opts => BindAiOptions(opts, configuration));
        services.AddSingleton<ITrainingContextBuilder, TrainingContextBuilder>();
        services.AddSingleton<FakeAiCoachClient>();
        services.AddSingleton<TrainingEngineOnlyAiProvider>();
        services.AddSingleton<IAiRuntimeStatus, AiRuntimeStatus>();
        services.AddHttpClient<OpenAiCompatibleCoachClient>((sp, client) =>
        {
            var opts = sp.GetRequiredService<Microsoft.Extensions.Options.IOptions<AiOptions>>().Value;
            client.Timeout = TimeSpan.FromSeconds(Math.Max(5, opts.TimeoutSeconds));
        });
        services.AddTransient<OpenAiTrainingProvider>();

        var probe = new AiOptions();
        BindAiOptions(probe, configuration);

        if (probe.IsLiveConfigured)
        {
            services.AddTransient<IAiCoachClient>(sp => sp.GetRequiredService<OpenAiCompatibleCoachClient>());
            services.AddTransient<ITrainingAiProvider>(sp => sp.GetRequiredService<OpenAiTrainingProvider>());
        }
        else
        {
            services.AddSingleton<IAiCoachClient>(sp => sp.GetRequiredService<FakeAiCoachClient>());
            services.AddSingleton<ITrainingAiProvider>(sp => sp.GetRequiredService<TrainingEngineOnlyAiProvider>());
        }

        return services;
    }

    /// <summary>
    /// Supports Ai:*, OpenAI:*, OPENAI_API_KEY, OPENAI_MODEL, and OpenAI__* env vars.
    /// Never persists secrets — bind only at runtime.
    /// </summary>
    public static void BindAiOptions(AiOptions opts, IConfiguration configuration)
    {
        configuration.GetSection(AiOptions.SectionName).Bind(opts);

        var openAi = configuration.GetSection(AiOptions.OpenAiSectionName);
        if (openAi.Exists())
        {
            var modelId = openAi["modelId"] ?? openAi["ModelId"] ?? openAi["Model"];
            var endpoint = openAi["endpoint"] ?? openAi["Endpoint"] ?? openAi["BaseUrl"];
            var apiKey = openAi["apikey"] ?? openAi["ApiKey"] ?? openAi["apiKey"];
            var enabled = openAi["Enabled"];
            var timeout = openAi["TimeoutSeconds"];
            var retries = openAi["MaxRetries"];

            if (!string.IsNullOrWhiteSpace(modelId)) opts.Model = modelId;
            if (!string.IsNullOrWhiteSpace(endpoint)) opts.BaseUrl = endpoint.TrimEnd('/');
            if (!string.IsNullOrWhiteSpace(apiKey)) opts.ApiKey = apiKey;
            if (bool.TryParse(enabled, out var openAiEnabled)) opts.Enabled = openAiEnabled;
            if (int.TryParse(timeout, out var t)) opts.TimeoutSeconds = t;
            if (int.TryParse(retries, out var r)) opts.MaxRetries = r;
        }

        // Flat env aliases commonly used in local/dev docs
        var envKey = Environment.GetEnvironmentVariable("OPENAI_API_KEY");
        if (!string.IsNullOrWhiteSpace(envKey)) opts.ApiKey = envKey;

        var envModel = Environment.GetEnvironmentVariable("OPENAI_MODEL");
        if (!string.IsNullOrWhiteSpace(envModel)) opts.Model = envModel;

        var aiEnabled = configuration.GetSection(AiOptions.SectionName)["Enabled"];
        if (bool.TryParse(aiEnabled, out var enabledFlag))
            opts.Enabled = enabledFlag;
        else if (!string.IsNullOrWhiteSpace(opts.ApiKey) &&
                 configuration.GetSection(AiOptions.OpenAiSectionName)["Enabled"] is null)
            opts.Enabled = true;
    }
}
