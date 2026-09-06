using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;

namespace GymCoach.Api.IntegrationTests;

public class ApiSmokeTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public ApiSmokeTests(WebApplicationFactory<Program> factory) => _factory = factory;

    [Fact]
    public async Task Health_returns_ok()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("/health");
        response.EnsureSuccessStatusCode();
    }

    [Fact]
    public async Task Register_login_onboarding_and_program_flow()
    {
        var client = _factory.CreateClient();
        var email = $"athlete{Guid.NewGuid():N}@test.com";
        var register = await client.PostAsJsonAsync("/api/auth/register", new
        {
            email,
            password = "Password1",
            displayName = "Test Athlete"
        });
        register.EnsureSuccessStatusCode();
        var auth = await register.Content.ReadFromJsonAsync<AuthDto>();
        Assert.NotNull(auth?.AccessToken);
        client.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", auth!.AccessToken);

        var onboarding = await client.PostAsJsonAsync("/api/onboarding", new
        {
            displayName = "Test Athlete",
            age = 28,
            sex = 0,
            heightCm = 180,
            bodyWeightKg = 80,
            experience = 1,
            yearsTraining = 3,
            primaryGoal = 0,
            secondaryGoal = (int?)null,
            trainingDaysPerWeek = 4,
            preferredSessionMinutes = 60,
            equipmentSetting = 0,
            equipmentIds = Array.Empty<Guid>(),
            limitations = Array.Empty<object>(),
            baselineLifts = Array.Empty<object>()
        });
        onboarding.EnsureSuccessStatusCode();

        var program = await client.PostAsync("/api/programs/generate", null);
        program.EnsureSuccessStatusCode();
        var body = await program.Content.ReadAsStringAsync();
        Assert.Contains("EndDateUtc", body, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("null", body, StringComparison.OrdinalIgnoreCase);

        var exercises = await client.GetAsync("/api/exercises");
        exercises.EnsureSuccessStatusCode();

        var status = await client.GetAsync("/api/personal/status");
        status.EnsureSuccessStatusCode();
        var statusBody = await status.Content.ReadAsStringAsync();
        Assert.DoesNotContain("apiKey", statusBody, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("ApiKey", statusBody, StringComparison.Ordinal);
        Assert.Contains("aiStatus", statusBody, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task Coach_ask_works_without_openai_and_status_hides_secrets()
    {
        var client = _factory.CreateClient();
        var boot = await client.PostAsync("/api/auth/personal-bootstrap", null);
        boot.EnsureSuccessStatusCode();
        var auth = await boot.Content.ReadFromJsonAsync<AuthDto>();
        client.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", auth!.AccessToken);

        await client.PostAsJsonAsync("/api/onboarding", new
        {
            displayName = "Coach Tester",
            age = 30,
            sex = 0,
            heightCm = 180,
            bodyWeightKg = 80,
            experience = 1,
            yearsTraining = 3,
            primaryGoal = 0,
            secondaryGoal = (int?)null,
            trainingDaysPerWeek = 4,
            preferredSessionMinutes = 60,
            equipmentSetting = 0,
            equipmentIds = Array.Empty<Guid>(),
            limitations = Array.Empty<object>(),
            baselineLifts = Array.Empty<object>()
        });

        var ask = await client.PostAsJsonAsync("/api/coach/ask", new { question = "Am I progressing?", exerciseId = (Guid?)null });
        ask.EnsureSuccessStatusCode();
        var askBody = await ask.Content.ReadAsStringAsync();
        Assert.Contains("answer", askBody, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("TRAINING_ENGINE", askBody, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("sk-", askBody, StringComparison.OrdinalIgnoreCase);

        var status = await client.GetAsync("/api/personal/status");
        var statusBody = await status.Content.ReadAsStringAsync();
        Assert.DoesNotContain("apiKey", statusBody, StringComparison.OrdinalIgnoreCase);
    }

    private sealed class AuthDto
    {
        public string AccessToken { get; set; } = "";
        public string RefreshToken { get; set; } = "";
        public string UserId { get; set; } = "";
    }
}
