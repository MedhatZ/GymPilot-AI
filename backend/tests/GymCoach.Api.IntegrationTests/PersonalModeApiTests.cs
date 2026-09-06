using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;

namespace GymCoach.Api.IntegrationTests;

public class PersonalModeApiTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public PersonalModeApiTests(WebApplicationFactory<Program> factory) => _factory = factory;

    [Fact]
    public async Task Personal_bootstrap_issues_token_without_login_ui()
    {
        var client = _factory.CreateClient();
        var response = await client.PostAsync("/api/auth/personal-bootstrap", null);
        response.EnsureSuccessStatusCode();
        var auth = await response.Content.ReadFromJsonAsync<AuthDto>();
        Assert.False(string.IsNullOrWhiteSpace(auth?.AccessToken));
    }

    [Fact]
    public async Task Next_workout_follows_sequence_and_program_end_date_stays_null()
    {
        var client = _factory.CreateClient();
        var boot = await client.PostAsync("/api/auth/personal-bootstrap", null);
        boot.EnsureSuccessStatusCode();
        var auth = await boot.Content.ReadFromJsonAsync<AuthDto>();
        client.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", auth!.AccessToken);

        await client.PostAsJsonAsync("/api/onboarding", new
        {
            displayName = "Personal",
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

        var programRes = await client.PostAsync("/api/programs/generate", null);
        programRes.EnsureSuccessStatusCode();
        var programJson = await programRes.Content.ReadAsStringAsync();
        Assert.Contains("\"endDateUtc\":null", programJson, StringComparison.OrdinalIgnoreCase);

        var next = await client.GetAsync("/api/workouts/next");
        next.EnsureSuccessStatusCode();
        var nextBody = await next.Content.ReadAsStringAsync();
        Assert.Contains("programDayId", nextBody, StringComparison.OrdinalIgnoreCase);
    }

    private sealed class AuthDto
    {
        public string AccessToken { get; set; } = "";
        public string RefreshToken { get; set; } = "";
    }
}
