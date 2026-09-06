using GymCoach.AI.Contracts;

namespace GymCoach.AI.Providers;

/// <summary>
/// Training AI provider abstraction. OpenAI never gets DB access — only prepared context DTOs.
/// </summary>
public interface ITrainingAiProvider
{
    string ProviderName { get; }
    bool IsLive { get; }

    Task<StructuredRecommendationDto> AnalyzeTrainingAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default);

    Task<CoachAnswerDto> AskCoachAsync(
        string question,
        TrainingContextDto context,
        CancellationToken cancellationToken = default);

    Task<StructuredRecommendationDto> EvaluateProgramAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default);
}

public sealed class TrainingEngineOnlyAiProvider : ITrainingAiProvider
{
    private readonly GymCoach.AI.Clients.FakeAiCoachClient _fake;

    public TrainingEngineOnlyAiProvider(GymCoach.AI.Clients.FakeAiCoachClient fake) => _fake = fake;

    public string ProviderName => AiProviderSources.TrainingEngine;
    public bool IsLive => false;

    public async Task<StructuredRecommendationDto> AnalyzeTrainingAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default)
    {
        var result = await _fake.GetRecommendationAsync(context, cancellationToken);
        result.Source = AiProviderSources.TrainingEngine;
        result.Evidence =
        [
            $"Overall strength trend: {context.OverallStrengthTrend}",
            $"Adherence: {context.Adherence:P0}",
            $"Program exposures: {context.ProgramExposureCount}"
        ];
        return result;
    }

    public async Task<CoachAnswerDto> AskCoachAsync(
        string question,
        TrainingContextDto context,
        CancellationToken cancellationToken = default)
    {
        var result = await _fake.AskAsync(question, context, cancellationToken);
        result.Source = AiProviderSources.TrainingEngine;
        result.ReferencedMetrics = result.CitedFacts;
        result.DataSufficiency = context.ProgramExposureCount < 3 ? "INSUFFICIENT" : "SUFFICIENT";
        return result;
    }

    public Task<StructuredRecommendationDto> EvaluateProgramAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default) =>
        AnalyzeTrainingAsync(context, cancellationToken);
}
