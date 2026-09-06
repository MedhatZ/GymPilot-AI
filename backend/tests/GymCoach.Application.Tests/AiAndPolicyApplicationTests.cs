using GymCoach.AI.Clients;
using GymCoach.AI.Contracts;
using GymCoach.AI.Context;
using GymCoach.Domain.Enums;
using GymCoach.TrainingEngine.Decisions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace GymCoach.Application.Tests;

public class FakeAiCoachClientTests
{
    private readonly FakeAiCoachClient _sut = new();

    [Fact]
    public async Task Refuses_nutrition_questions()
    {
        var answer = await _sut.AskAsync("What calorie surplus should I eat?", new TrainingContextDto());
        Assert.True(answer.RefusedNutrition);
    }

    [Fact]
    public async Task Answers_progress_from_context()
    {
        var answer = await _sut.AskAsync("Am I progressing?", new TrainingContextDto
        {
            OverallStrengthTrend = "positive",
            Adherence = 0.9m,
            ProgramExposureCount = 10
        });
        Assert.False(answer.RefusedNutrition);
        Assert.Contains("positive", answer.Answer, StringComparison.OrdinalIgnoreCase);
        Assert.NotEmpty(answer.CitedFacts);
        Assert.Equal(AiProviderSources.TrainingEngine, answer.Source);
    }

    [Fact]
    public void Structured_recommendation_maps_enums()
    {
        var dto = new StructuredRecommendationDto
        {
            Decision = "CONTINUE",
            Scope = "PROGRAM",
            Confidence = 0.9m,
            Reason = "ok",
            Evidence = ["adherence high"]
        };
        Assert.True(dto.TryMap(out var decision, out var scope, out _));
        Assert.Equal(DecisionType.Continue, decision);
        Assert.Equal(DecisionScope.Program, scope);
    }

    [Fact]
    public void Structured_recommendation_rejects_invalid_enum()
    {
        var dto = new StructuredRecommendationDto
        {
            Decision = "EAT_MORE",
            Scope = "PROGRAM",
            Confidence = 0.9m,
            Reason = "nope"
        };
        Assert.False(dto.TryMap(out _, out _, out var error));
        Assert.Contains("Unknown decision", error);
    }

    [Fact]
    public void Structured_recommendation_rejects_set_scope()
    {
        var dto = new StructuredRecommendationDto
        {
            Decision = "CONTINUE",
            Scope = "SET",
            Confidence = 0.9m,
            Reason = "ok"
        };
        Assert.False(dto.TryMap(out _, out _, out var error));
        Assert.Contains("SET", error);
    }
}

public class AiOptionsBindingTests
{
    [Fact]
    public void Binds_OPENAI_API_KEY_and_model_env_aliases()
    {
        Environment.SetEnvironmentVariable("OPENAI_API_KEY", "test-key-from-env");
        Environment.SetEnvironmentVariable("OPENAI_MODEL", "gpt-4o-mini");
        try
        {
            var config = new ConfigurationBuilder()
                .AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["OpenAI:Enabled"] = "true",
                    ["OpenAI:BaseUrl"] = "https://api.openai.com/v1"
                })
                .Build();
            var opts = new AiOptions();
            GymCoach.AI.AiServiceCollectionExtensions.BindAiOptions(opts, config);
            Assert.True(opts.Enabled);
            Assert.Equal("test-key-from-env", opts.ApiKey);
            Assert.Equal("gpt-4o-mini", opts.Model);
            Assert.True(opts.IsLiveConfigured);
        }
        finally
        {
            Environment.SetEnvironmentVariable("OPENAI_API_KEY", null);
            Environment.SetEnvironmentVariable("OPENAI_MODEL", null);
        }
    }

    [Fact]
    public void Disabled_when_OpenAI_Enabled_false_even_with_key()
    {
        var config = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["OpenAI:Enabled"] = "false",
                ["OpenAI:ApiKey"] = "secret",
                ["OpenAI:Model"] = "gpt-4o-mini",
                ["Ai:Enabled"] = "false"
            })
            .Build();
        var opts = new AiOptions();
        GymCoach.AI.AiServiceCollectionExtensions.BindAiOptions(opts, config);
        Assert.False(opts.Enabled);
        Assert.False(opts.IsLiveConfigured);
    }
}

public class OpenAiProviderFallbackTests
{
    [Fact]
    public async Task Live_client_falls_back_on_http_failure()
    {
        var handler = new StubHandler(_ => new HttpResponseMessage(System.Net.HttpStatusCode.InternalServerError)
        {
            Content = new StringContent("boom")
        });
        var http = new HttpClient(handler);
        var opts = Options.Create(new AiOptions
        {
            Enabled = true,
            ApiKey = "k",
            Model = "gpt-4o-mini",
            BaseUrl = "https://example.test/v1",
            MaxRetries = 0,
            TimeoutSeconds = 5
        });
        var status = new AiRuntimeStatus();
        var client = new OpenAiCompatibleCoachClient(
            http, opts, NullLogger<OpenAiCompatibleCoachClient>.Instance, new FakeAiCoachClient(), status);

        var result = await client.AskAsync("Am I progressing?", new TrainingContextDto
        {
            OverallStrengthTrend = "positive",
            ProgramExposureCount = 8,
            Adherence = 0.9m
        });

        Assert.True(result.UsedFallback);
        Assert.Equal(AiProviderSources.TrainingEngine, result.Source);
        Assert.Equal("Error", status.Status);
        Assert.DoesNotContain("k", result.Answer);
    }

    [Fact]
    public async Task Live_client_parses_structured_recommendation()
    {
        var payload = """
                      {"id":"1","choices":[{"message":{"role":"assistant","content":"{\"decision\":\"CONTINUE\",\"scope\":\"PROGRAM\",\"confidence\":0.91,\"reason\":\"Progress positive.\",\"evidence\":[\"e1RM up\"],\"changes\":[]}"}}],"usage":{"prompt_tokens":10,"completion_tokens":20,"total_tokens":30}}
                      """;
        var handler = new StubHandler(_ => new HttpResponseMessage(System.Net.HttpStatusCode.OK)
        {
            Content = new StringContent(payload)
        });
        var client = new OpenAiCompatibleCoachClient(
            new HttpClient(handler),
            Options.Create(new AiOptions
            {
                Enabled = true,
                ApiKey = "k",
                Model = "gpt-4o-mini",
                BaseUrl = "https://example.test/v1",
                MaxRetries = 0
            }),
            NullLogger<OpenAiCompatibleCoachClient>.Instance,
            new FakeAiCoachClient(),
            new AiRuntimeStatus());

        var dto = await client.GetRecommendationAsync(new TrainingContextDto
        {
            OverallStrengthTrend = "positive",
            ProgramExposureCount = 10,
            Adherence = 0.95m
        });

        Assert.False(dto.UsedFallback);
        Assert.Equal(AiProviderSources.OpenAi, dto.Source);
        Assert.Equal("CONTINUE", dto.Decision);
        Assert.Contains(dto.Evidence, e => e.Contains("e1RM", StringComparison.OrdinalIgnoreCase));
    }

    private sealed class StubHandler : HttpMessageHandler
    {
        private readonly Func<HttpRequestMessage, HttpResponseMessage> _respond;
        public StubHandler(Func<HttpRequestMessage, HttpResponseMessage> respond) => _respond = respond;
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken) =>
            Task.FromResult(_respond(request));
    }
}

public class TrainingContextBuilderTests
{
    [Fact]
    public void Context_from_decision_input_is_concise_and_fingerprinted()
    {
        var builder = new TrainingContextBuilder();
        var ctx = builder.Build(new ProgramDecisionInput
        {
            ProgramExposureCount = 12,
            Adherence = 0.94m,
            OverallStrengthTrend = TrendDirection.Positive,
            AdequateRecovery = true,
            Exercises =
            [
                new ExerciseTrendSummary
                {
                    ExerciseId = Guid.NewGuid(),
                    IsKeyLift = true,
                    PlateauState = PlateauState.Normal,
                    StrengthTrend = TrendDirection.Positive,
                    ExposureCount = 6,
                    E1rmTrendPercent = 4.3m
                }
            ]
        }, "Bench Press");

        Assert.Equal("Bench Press", ctx.Exercise);
        Assert.Equal("positive", ctx.OverallStrengthTrend);
        Assert.NotEmpty(ctx.ContextFingerprint);
        Assert.DoesNotContain("leg", string.Join(' ', ctx.KeyLiftSummaries), StringComparison.OrdinalIgnoreCase);
    }
}

public class PolicyOverridesAiTests
{
    [Fact]
    public void Policy_rejects_new_program_when_progression_positive()
    {
        var rules = new ProgramDecisionEngine();
        var policy = new TrainingPolicyValidator(rules);
        var input = new ProgramDecisionInput
        {
            ProgramExposureCount = 20,
            Adherence = 0.95m,
            OverallStrengthTrend = TrendDirection.Positive,
            AdequateRecovery = true,
            DeloadAlreadyTried = true,
            PriorMinorAdjustmentsTried = true,
            Exercises =
            [
                new ExerciseTrendSummary
                {
                    ExerciseId = Guid.NewGuid(),
                    IsKeyLift = true,
                    PlateauState = PlateauState.Normal,
                    StrengthTrend = TrendDirection.Positive,
                    ExposureCount = 10,
                    E1rmTrendPercent = 5
                }
            ]
        };

        var (result, final, notes) = policy.Validate(DecisionType.NewProgram, DecisionScope.Program, input, 0.99m);
        Assert.Equal(PolicyValidationResult.Rejected, result);
        Assert.Equal(DecisionType.Continue, final);
        Assert.Contains("positive", notes, StringComparison.OrdinalIgnoreCase);
    }
}
