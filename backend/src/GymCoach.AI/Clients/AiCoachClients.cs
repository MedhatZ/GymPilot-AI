using System.Diagnostics;
using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using GymCoach.AI.Contracts;
using GymCoach.AI.Providers;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace GymCoach.AI.Clients;

public interface IAiCoachClient
{
    Task<StructuredRecommendationDto> GetRecommendationAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default);

    Task<CoachAnswerDto> AskAsync(
        string question,
        TrainingContextDto context,
        CancellationToken cancellationToken = default);
}

/// <summary>Deterministic fake used when AI is disabled or in tests.</summary>
public sealed class FakeAiCoachClient : IAiCoachClient
{
    public Task<StructuredRecommendationDto> GetRecommendationAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default)
    {
        var decision = context.OverallStrengthTrend.Equals("positive", StringComparison.OrdinalIgnoreCase)
            ? "CONTINUE"
            : context.RecentPlateauSessions >= 3 && context.DeloadAlreadyTried
                ? "PROGRAM_ADJUSTMENT"
                : context.AdequateRecovery ? "CONTINUE" : "DELOAD";

        return Task.FromResult(new StructuredRecommendationDto
        {
            Decision = decision,
            Scope = "PROGRAM",
            Confidence = 0.75m,
            Reason = $"Rule-backed stub recommendation from context (adherence={context.Adherence}).",
            Evidence =
            [
                $"Overall strength trend: {context.OverallStrengthTrend}",
                $"Adherence: {context.Adherence:P0}",
                $"Program exposures: {context.ProgramExposureCount}"
            ],
            Source = AiProviderSources.TrainingEngine
        });
    }

    public Task<CoachAnswerDto> AskAsync(
        string question,
        TrainingContextDto context,
        CancellationToken cancellationToken = default)
    {
        if (ContainsNutrition(question))
        {
            return Task.FromResult(new CoachAnswerDto
            {
                Answer =
                    "Nutrition and meal planning are out of scope for GymCoach AI. I can help with training, recovery readiness, and program decisions.",
                RefusedNutrition = true,
                CitedFacts = Array.Empty<string>(),
                Source = AiProviderSources.TrainingEngine,
                Confidence = 1m,
                DataSufficiency = "SUFFICIENT"
            });
        }

        var facts = BuildFacts(context);
        var sufficiency = context.ProgramExposureCount < 3 ||
                          (context.Exercise != null && context.RecentExposureCount < 2)
            ? "INSUFFICIENT"
            : "SUFFICIENT";

        var answer = sufficiency == "INSUFFICIENT"
            ? "Available training data is limited. Keep logging workouts so I can give a grounded answer. " +
              $"So far: trend={context.OverallStrengthTrend}, exposures={context.ProgramExposureCount}."
            : $"Based on your training context: trend is {context.OverallStrengthTrend}, adherence {context.Adherence:P0}, " +
              $"and {context.ProgramExposureCount} program exposures." +
              (context.OverloadReason is { Length: > 0 } ? $" Load guidance: {context.OverloadReason}" : "") +
              (context.PlateauState is { Length: > 0 } ? $" Plateau state: {context.PlateauState}." : "");

        return Task.FromResult(new CoachAnswerDto
        {
            Answer = answer,
            RefusedNutrition = false,
            CitedFacts = facts,
            ReferencedMetrics = facts,
            Source = AiProviderSources.TrainingEngine,
            Confidence = sufficiency == "INSUFFICIENT" ? 0.4m : 0.75m,
            DataSufficiency = sufficiency
        });
    }

    internal static bool ContainsNutrition(string question)
    {
        var q = question.ToLowerInvariant();
        string[] banned =
        [
            "calorie", "calories", "macro", "protein intake", "meal plan", "diet", "nutrition", "food log",
            "carb"
        ];
        return banned.Any(q.Contains);
    }

    internal static List<string> BuildFacts(TrainingContextDto context)
    {
        var facts = new List<string>
        {
            $"Overall strength trend: {context.OverallStrengthTrend}",
            $"Adherence: {context.Adherence:P0}",
            $"Program exposures: {context.ProgramExposureCount}",
            $"Recent plateau markers: {context.RecentPlateauSessions}"
        };
        if (!string.IsNullOrWhiteSpace(context.Exercise))
            facts.Add($"Focus exercise: {context.Exercise} (exposures={context.RecentExposureCount})");
        if (context.SuggestedLoadKg.HasValue)
            facts.Add($"Suggested load: {context.SuggestedLoadKg} kg");
        if (!string.IsNullOrWhiteSpace(context.OverloadReason))
            facts.Add($"Overload reason: {context.OverloadReason}");
        return facts;
    }
}

/// <summary>
/// OpenAI-compatible chat client with bounded retries and fallback.
/// </summary>
public sealed class OpenAiCompatibleCoachClient : IAiCoachClient
{
    private readonly HttpClient _http;
    private readonly AiOptions _options;
    private readonly ILogger<OpenAiCompatibleCoachClient> _logger;
    private readonly FakeAiCoachClient _fallback;
    private readonly IAiRuntimeStatus _runtimeStatus;
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
    };

    public OpenAiCompatibleCoachClient(
        HttpClient http,
        IOptions<AiOptions> options,
        ILogger<OpenAiCompatibleCoachClient> logger,
        FakeAiCoachClient fallback,
        IAiRuntimeStatus runtimeStatus)
    {
        _http = http;
        _options = options.Value;
        _logger = logger;
        _fallback = fallback;
        _runtimeStatus = runtimeStatus;
        _http.Timeout = TimeSpan.FromSeconds(Math.Max(5, _options.TimeoutSeconds));
        if (!_options.IsLiveConfigured)
            _runtimeStatus.MarkNotConfigured();
    }

    public async Task<StructuredRecommendationDto> GetRecommendationAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default)
    {
        if (!_options.IsLiveConfigured)
        {
            _runtimeStatus.MarkNotConfigured();
            var local = await _fallback.GetRecommendationAsync(context, cancellationToken);
            local.UsedFallback = true;
            return local;
        }

        try
        {
            var user =
                "TRUSTED_TRAINING_CONTEXT_JSON:\n" +
                JsonSerializer.Serialize(context, JsonOptions) +
                "\n\nUNTRUSTED_USER_INSTRUCTION: Produce a conservative structured recommendation from the trusted context only.";
            var (content, usage) = await ChatWithRetryAsync(
                CoachSystemPrompts.Analysis,
                user,
                jsonMode: true,
                operation: "AnalyzeTraining",
                cancellationToken);
            var dto = JsonSerializer.Deserialize<StructuredRecommendationDto>(content, JsonOptions);
            string? mapError = null;
            if (dto is null || !dto.TryMap(out _, out _, out mapError))
            {
                _logger.LogWarning("AI recommendation invalid ({Error}); fallback. Usage={Usage}", mapError ?? "null dto", usage);
                _runtimeStatus.MarkError($"invalid schema: {mapError ?? "null dto"}");
                var local = await _fallback.GetRecommendationAsync(context, cancellationToken);
                local.UsedFallback = true;
                return local;
            }

            _runtimeStatus.MarkConnected();
            dto.Source = AiProviderSources.OpenAi;
            return dto;
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Live AI recommendation failed; fallback.");
            _runtimeStatus.MarkError(ex.GetType().Name);
            var local = await _fallback.GetRecommendationAsync(context, cancellationToken);
            local.UsedFallback = true;
            return local;
        }
    }

    public async Task<CoachAnswerDto> AskAsync(
        string question,
        TrainingContextDto context,
        CancellationToken cancellationToken = default)
    {
        if (FakeAiCoachClient.ContainsNutrition(question))
        {
            return new CoachAnswerDto
            {
                Answer =
                    "Nutrition and meal planning are out of scope for GymCoach AI. I can help with training, recovery readiness, and program decisions.",
                RefusedNutrition = true,
                Source = _options.IsLiveConfigured ? AiProviderSources.OpenAi : AiProviderSources.TrainingEngine,
                Confidence = 1m,
                DataSufficiency = "SUFFICIENT"
            };
        }

        if (!_options.IsLiveConfigured)
        {
            _runtimeStatus.MarkNotConfigured();
            var local = await _fallback.AskAsync(question, context, cancellationToken);
            local.UsedFallback = true;
            return local;
        }

        try
        {
            var user =
                "TRUSTED_TRAINING_CONTEXT_JSON:\n" +
                JsonSerializer.Serialize(context, JsonOptions) +
                "\n\nUNTRUSTED_USER_QUESTION:\n" +
                question +
                "\n\nAnswer using only the trusted context. If insufficient, say so.";
            var (content, _) = await ChatWithRetryAsync(
                CoachSystemPrompts.CoachQa,
                user,
                jsonMode: false,
                operation: "AskCoach",
                cancellationToken);
            var facts = FakeAiCoachClient.BuildFacts(context);
            _runtimeStatus.MarkConnected();
            return new CoachAnswerDto
            {
                Answer = content.Trim(),
                RefusedNutrition = false,
                CitedFacts = facts,
                ReferencedMetrics = facts,
                Source = AiProviderSources.OpenAi,
                Confidence = 0.85m,
                DataSufficiency = context.ProgramExposureCount < 3 ? "INSUFFICIENT" : "SUFFICIENT"
            };
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Live AI coach ask failed; fallback.");
            _runtimeStatus.MarkError(ex.GetType().Name);
            var local = await _fallback.AskAsync(question, context, cancellationToken);
            local.UsedFallback = true;
            return local;
        }
    }

    private async Task<(string Content, string Usage)> ChatWithRetryAsync(
        string system,
        string user,
        bool jsonMode,
        string operation,
        CancellationToken cancellationToken)
    {
        var maxAttempts = Math.Max(1, _options.MaxRetries + 1);
        Exception? last = null;
        for (var attempt = 1; attempt <= maxAttempts; attempt++)
        {
            var sw = Stopwatch.StartNew();
            var requestId = Guid.NewGuid().ToString("N");
            try
            {
                var result = await ChatOnceAsync(system, user, jsonMode, cancellationToken);
                sw.Stop();
                _logger.LogInformation(
                    "OpenAI {Operation} ok RequestId={RequestId} Model={Model} Attempt={Attempt} DurationMs={Duration} Usage={Usage} ContextChars={ContextChars}",
                    operation, requestId, _options.Model, attempt, sw.ElapsedMilliseconds, result.Usage, user.Length);
                return result;
            }
            catch (Exception ex) when (IsTransient(ex) && attempt < maxAttempts)
            {
                last = ex;
                _logger.LogWarning(ex,
                    "OpenAI {Operation} transient failure RequestId={RequestId} Attempt={Attempt}",
                    operation, requestId, attempt);
                await Task.Delay(TimeSpan.FromMilliseconds(200 * attempt), cancellationToken);
            }
            catch (Exception ex)
            {
                sw.Stop();
                _logger.LogWarning(ex,
                    "OpenAI {Operation} failed RequestId={RequestId} Model={Model} Attempt={Attempt} DurationMs={Duration}",
                    operation, requestId, _options.Model, attempt, sw.ElapsedMilliseconds);
                throw;
            }
        }

        throw last ?? new InvalidOperationException("OpenAI request failed.");
    }

    private async Task<(string Content, string Usage)> ChatOnceAsync(
        string system,
        string user,
        bool jsonMode,
        CancellationToken cancellationToken)
    {
        var baseUrl = _options.BaseUrl.TrimEnd('/');
        var request = new ChatCompletionRequest
        {
            Model = _options.Model,
            Messages =
            [
                new ChatMessage("system", system),
                new ChatMessage("user", user)
            ],
            Temperature = 0.2,
            MaxTokens = jsonMode ? 500 : 400
        };

        using var httpRequest = new HttpRequestMessage(HttpMethod.Post, $"{baseUrl}/chat/completions")
        {
            Content = new StringContent(JsonSerializer.Serialize(request, JsonOptions), Encoding.UTF8, "application/json")
        };
        httpRequest.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _options.ApiKey);

        using var response = await _http.SendAsync(httpRequest, cancellationToken);
        var body = await response.Content.ReadAsStringAsync(cancellationToken);
        if (response.StatusCode is HttpStatusCode.Unauthorized or HttpStatusCode.Forbidden)
            throw new InvalidOperationException($"AI auth error {(int)response.StatusCode}");
        if (response.StatusCode == HttpStatusCode.BadRequest)
            throw new InvalidOperationException($"AI bad request: {TrimBody(body)}");
        if (!response.IsSuccessStatusCode)
            throw new HttpRequestException($"AI HTTP {(int)response.StatusCode}: {TrimBody(body)}");

        var parsed = JsonSerializer.Deserialize<ChatCompletionResponse>(body, JsonOptions)
                     ?? throw new InvalidOperationException("Empty AI response.");
        var content = parsed.Choices?.FirstOrDefault()?.Message?.Content;
        if (string.IsNullOrWhiteSpace(content))
            throw new InvalidOperationException("AI returned no content.");
        if (jsonMode) content = ExtractJson(content);

        var usage = parsed.Usage is null
            ? "n/a"
            : $"prompt={parsed.Usage.PromptTokens};completion={parsed.Usage.CompletionTokens};total={parsed.Usage.TotalTokens}";
        return (content, usage);
    }

    private static bool IsTransient(Exception ex) =>
        ex is HttpRequestException or TaskCanceledException ||
        (ex is InvalidOperationException ioe && ioe.Message.Contains("429", StringComparison.Ordinal));

    private static string TrimBody(string body) =>
        body.Length <= 300 ? body : body[..300] + "...";

    private static string ExtractJson(string content)
    {
        var trimmed = content.Trim();
        if (trimmed.StartsWith("```"))
        {
            var start = trimmed.IndexOf('{');
            var end = trimmed.LastIndexOf('}');
            if (start >= 0 && end > start)
                return trimmed[start..(end + 1)];
        }

        return trimmed;
    }

    private sealed class ChatCompletionRequest
    {
        [JsonPropertyName("model")] public string Model { get; set; } = "";
        [JsonPropertyName("messages")] public List<ChatMessage> Messages { get; set; } = new();
        [JsonPropertyName("temperature")] public double Temperature { get; set; }
        [JsonPropertyName("max_tokens")] public int MaxTokens { get; set; }
    }

    private sealed class ChatMessage
    {
        public ChatMessage() { }
        public ChatMessage(string role, string content) { Role = role; Content = content; }
        [JsonPropertyName("role")] public string Role { get; set; } = "";
        [JsonPropertyName("content")] public string Content { get; set; } = "";
    }

    private sealed class ChatCompletionResponse
    {
        [JsonPropertyName("choices")] public List<ChatChoice>? Choices { get; set; }
        [JsonPropertyName("usage")] public UsageInfo? Usage { get; set; }
    }

    private sealed class ChatChoice
    {
        [JsonPropertyName("message")] public ChatMessage? Message { get; set; }
    }

    private sealed class UsageInfo
    {
        [JsonPropertyName("prompt_tokens")] public int PromptTokens { get; set; }
        [JsonPropertyName("completion_tokens")] public int CompletionTokens { get; set; }
        [JsonPropertyName("total_tokens")] public int TotalTokens { get; set; }
    }
}

/// <summary>Live OpenAI provider wrapping the HTTP client.</summary>
public sealed class OpenAiTrainingProvider : ITrainingAiProvider
{
    private readonly OpenAiCompatibleCoachClient _client;
    private readonly AiOptions _options;

    public OpenAiTrainingProvider(OpenAiCompatibleCoachClient client, IOptions<AiOptions> options)
    {
        _client = client;
        _options = options.Value;
    }

    public string ProviderName => AiProviderSources.OpenAi;
    public bool IsLive => _options.IsLiveConfigured;

    public Task<StructuredRecommendationDto> AnalyzeTrainingAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default) =>
        _client.GetRecommendationAsync(context, cancellationToken);

    public Task<CoachAnswerDto> AskCoachAsync(
        string question,
        TrainingContextDto context,
        CancellationToken cancellationToken = default) =>
        _client.AskAsync(question, context, cancellationToken);

    public Task<StructuredRecommendationDto> EvaluateProgramAsync(
        TrainingContextDto context,
        CancellationToken cancellationToken = default) =>
        _client.GetRecommendationAsync(context, cancellationToken);
}
