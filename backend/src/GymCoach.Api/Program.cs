using System.Security.Claims;
using System.Text;
using GymCoach.Application.Auth;
using GymCoach.Application.Coach;
using GymCoach.Application.DependencyInjection;
using GymCoach.Application.Exercises;
using GymCoach.Application.Onboarding;
using GymCoach.Application.Personal;
using GymCoach.Application.Programs;
using GymCoach.Application.Progress;
using GymCoach.Application.Sync;
using GymCoach.Application.Workouts;
using GymCoach.Infrastructure.Auth;
using GymCoach.Infrastructure.DependencyInjection;
using GymCoach.Infrastructure.Seeding;
using GymCoach.TrainingEngine.Options;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// Render (and Docker) set PORT dynamically. Local `dotnet run` keeps launchSettings (5080).
var listenPort = Environment.GetEnvironmentVariable("PORT");
if (!string.IsNullOrWhiteSpace(listenPort))
{
    builder.WebHost.UseUrls($"http://0.0.0.0:{listenPort}");
}

builder.Services.AddProblemDetails();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.Configure<TrainingPolicyOptions>(
    builder.Configuration.GetSection(TrainingPolicyOptions.SectionName));
builder.Services.AddGymCoachInfrastructure(builder.Configuration);
builder.Services.AddGymCoachApplication();

var jwt = builder.Configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>() ?? new JwtOptions();
if (!builder.Environment.IsDevelopment() &&
    (string.IsNullOrWhiteSpace(jwt.SigningKey) ||
     jwt.SigningKey.StartsWith("DEV_ONLY", StringComparison.Ordinal)))
{
    throw new InvalidOperationException(
        "Jwt__SigningKey must be set to a long random secret in Production (environment variable).");
}

builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwt.Issuer,
            ValidAudience = jwt.Audience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt.SigningKey))
        };
    });
builder.Services.AddAuthorization();
builder.Services.ConfigureApplicationCookie(options =>
{
    options.Events.OnRedirectToLogin = ctx =>
    {
        ctx.Response.StatusCode = StatusCodes.Status401Unauthorized;
        return Task.CompletedTask;
    };
    options.Events.OnRedirectToAccessDenied = ctx =>
    {
        ctx.Response.StatusCode = StatusCodes.Status403Forbidden;
        return Task.CompletedTask;
    };
});

var app = builder.Build();

app.UseExceptionHandler();
app.UseStatusCodePages();
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthentication();
app.UseAuthorization();

await ExerciseLibrarySeeder.SeedAsync(app.Services);

string UserId(ClaimsPrincipal user) =>
    user.FindFirstValue(ClaimTypes.NameIdentifier) ?? user.FindFirstValue("sub")
    ?? throw new UnauthorizedAccessException();

app.MapPost("/api/auth/register", async (RegisterRequest req, IAuthService auth, CancellationToken ct) =>
{
    try
    {
        var result = await auth.RegisterAsync(req, ct);
        return Results.Ok(result);
    }
    catch (InvalidOperationException ex)
    {
        // Duplicate email / password policy → 400 (not opaque 500)
        return Results.BadRequest(new { error = ex.Message });
    }
});

app.MapPost("/api/auth/login", async (LoginRequest req, IAuthService auth, CancellationToken ct) =>
{
    try
    {
        return Results.Ok(await auth.LoginAsync(req, ct));
    }
    catch (UnauthorizedAccessException)
    {
        return Results.Unauthorized();
    }
});

app.MapPost("/api/auth/refresh", async (RefreshRequest req, IAuthService auth, CancellationToken ct) =>
    Results.Ok(await auth.RefreshAsync(req, ct)));

app.MapPost("/api/auth/personal-bootstrap", async (IPersonalBootstrapService personal, IPersonalModeAccessor mode, CancellationToken ct) =>
{
    if (!mode.IsEnabled) return Results.NotFound();
    return Results.Ok(await personal.EnsurePersonalSessionAsync(ct));
});

app.MapGet("/api/personal/status", (
    IPersonalModeAccessor mode,
    Microsoft.Extensions.Options.IOptions<GymCoach.AI.Clients.AiOptions> ai,
    GymCoach.AI.Clients.IAiRuntimeStatus aiStatus) =>
{
    var configured = ai.Value.IsLiveConfigured;
    if (!configured) aiStatus.MarkNotConfigured();
    var status = configured
        ? (aiStatus.Status == "Error" ? "Error" : "Connected")
        : "NotConfigured";
    var coachLabel = configured && status == "Connected"
        ? "OpenAI Connected"
        : "Training Engine Only";
    return Results.Ok(new
    {
        enabled = mode.IsEnabled,
        email = mode.Options.DefaultEmail,
        aiConfigured = configured,
        aiStatus = status,
        aiCoach = coachLabel,
        aiModel = string.IsNullOrWhiteSpace(ai.Value.Model) ? null : ai.Value.Model,
        aiEndpoint = configured ? ai.Value.BaseUrl : null
        // never return ApiKey
    });
});

app.MapPost("/api/onboarding", async (OnboardingRequest req, ClaimsPrincipal user, IOnboardingService svc, CancellationToken ct) =>
    Results.Ok(await svc.CompleteAsync(UserId(user), req, ct))).RequireAuthorization();

app.MapGet("/api/onboarding/me", async (ClaimsPrincipal user, IOnboardingService svc, CancellationToken ct) =>
{
    var profile = await svc.GetAsync(UserId(user), ct);
    return profile is null ? Results.NotFound() : Results.Ok(profile);
}).RequireAuthorization();

app.MapGet("/api/exercises", async (IExerciseQueryService svc, CancellationToken ct) =>
    Results.Ok(await svc.ListAsync(ct))).RequireAuthorization();

app.MapGet("/api/exercises/{id:guid}", async (Guid id, IExerciseQueryService svc, CancellationToken ct) =>
{
    var item = await svc.GetAsync(id, ct);
    return item is null ? Results.NotFound() : Results.Ok(item);
}).RequireAuthorization();

app.MapPost("/api/programs/generate", async (ClaimsPrincipal user, IProgramGenerationService svc, CancellationToken ct) =>
    Results.Ok(await svc.GenerateInitialAsync(UserId(user), ct))).RequireAuthorization();

app.MapGet("/api/programs/active", async (ClaimsPrincipal user, IProgramGenerationService svc, CancellationToken ct) =>
{
    var program = await svc.GetActiveAsync(UserId(user), ct);
    return program is null ? Results.NotFound() : Results.Ok(program);
}).RequireAuthorization();

app.MapPost("/api/programs/deload", async (ClaimsPrincipal user, IProgramVersioningService svc, CancellationToken ct) =>
    Results.Ok(await svc.ApplyDeloadAsync(UserId(user), "Deload applied from recovery/fatigue signals.", ct)))
    .RequireAuthorization();

app.MapPost("/api/workouts/start", async (StartWorkoutRequest req, ClaimsPrincipal user, IWorkoutService svc, CancellationToken ct) =>
    Results.Ok(await svc.StartAsync(UserId(user), req, ct))).RequireAuthorization();

app.MapPost("/api/workouts/{sessionClientId:guid}/sets",
    async (Guid sessionClientId, LogSetRequest req, ClaimsPrincipal user, IWorkoutService svc, CancellationToken ct) =>
        Results.Ok(await svc.LogSetAsync(UserId(user), sessionClientId, req, ct))).RequireAuthorization();

app.MapPost("/api/workouts/complete", async (CompleteWorkoutRequest req, ClaimsPrincipal user, IWorkoutService svc, CancellationToken ct) =>
    Results.Ok(await svc.CompleteAsync(UserId(user), req, ct))).RequireAuthorization();

app.MapGet("/api/workouts/suggest/{exerciseId:guid}",
    async (Guid exerciseId, ClaimsPrincipal user, IWorkoutService svc, CancellationToken ct) =>
        Results.Ok(await svc.SuggestNextAsync(UserId(user), exerciseId, ct))).RequireAuthorization();

app.MapGet("/api/workouts/next", async (ClaimsPrincipal user, INextWorkoutService svc, CancellationToken ct) =>
{
    var next = await svc.GetRecommendedAsync(UserId(user), ct);
    return next is null ? Results.NotFound() : Results.Ok(next);
}).RequireAuthorization();

app.MapGet("/api/workouts/{sessionClientId:guid}/summary",
    async (Guid sessionClientId, ClaimsPrincipal user, IWorkoutSummaryService svc, CancellationToken ct) =>
    {
        var summary = await svc.GetAsync(UserId(user), sessionClientId, ct);
        return summary is null ? Results.NotFound() : Results.Ok(summary);
    }).RequireAuthorization();

app.MapPost("/api/sync/workouts", async (
    SyncWorkoutBatchRequest req,
    ClaimsPrincipal user,
    IWorkoutSyncService sync,
    HttpRequest http,
    CancellationToken ct) =>
{
    http.Headers.TryGetValue("Idempotency-Key", out var key);
    return Results.Ok(await sync.UpsertBatchAsync(UserId(user), req, key.FirstOrDefault(), ct));
}).RequireAuthorization();

app.MapGet("/api/home", async (ClaimsPrincipal user, IHomeService svc, CancellationToken ct) =>
    Results.Ok(await svc.GetAsync(UserId(user), ct))).RequireAuthorization();

app.MapGet("/api/progress", async (ClaimsPrincipal user, IProgressService svc, CancellationToken ct) =>
    Results.Ok(await svc.GetOverviewAsync(UserId(user), ct))).RequireAuthorization();

app.MapGet("/api/progress/exercises/{id:guid}",
    async (Guid id, ClaimsPrincipal user, IProgressService svc, CancellationToken ct) =>
    {
        var item = await svc.GetExerciseAsync(UserId(user), id, ct);
        return item is null ? Results.NotFound() : Results.Ok(item);
    }).RequireAuthorization();

app.MapPost("/api/coach/ask", async (CoachAskRequest req, ClaimsPrincipal user, ICoachService svc, CancellationToken ct) =>
    Results.Ok(await svc.AskAsync(UserId(user), req, ct))).RequireAuthorization();

app.MapPost("/api/coach/evaluate", async (ClaimsPrincipal user, ICoachService svc, CancellationToken ct) =>
    Results.Ok(await svc.EvaluateProgramAsync(UserId(user), ct))).RequireAuthorization();

app.MapGet("/api/coach/decisions", async (ClaimsPrincipal user, ICoachService svc, CancellationToken ct) =>
    Results.Ok(await svc.ListDecisionsAsync(UserId(user), ct))).RequireAuthorization();

app.MapGet("/health", () => Results.Ok(new { status = "healthy", product = "GymCoach AI" }));

app.Run();

public partial class Program;
