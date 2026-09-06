using GymCoach.Application.Auth;
using GymCoach.Application.Personal;
using GymCoach.Infrastructure.Auth;
using GymCoach.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;

namespace GymCoach.Infrastructure.Auth;

public interface IPersonalBootstrapService
{
    Task<AuthResponse> EnsurePersonalSessionAsync(CancellationToken ct = default);
}

/// <summary>
/// Creates/finds the single personal athlete and issues JWT without showing login UI.
/// Auth architecture remains intact for non-personal deployments.
/// </summary>
public sealed class PersonalBootstrapService : IPersonalBootstrapService
{
    private readonly UserManager<AppUser> _users;
    private readonly ITokenService _tokens;
    private readonly RefreshTokenStore _refreshStore;
    private readonly PersonalModeOptions _personal;
    private readonly JwtOptions _jwt;

    public PersonalBootstrapService(
        UserManager<AppUser> users,
        ITokenService tokens,
        RefreshTokenStore refreshStore,
        IOptions<PersonalModeOptions> personal,
        IOptions<JwtOptions> jwt)
    {
        _users = users;
        _tokens = tokens;
        _refreshStore = refreshStore;
        _personal = personal.Value;
        _jwt = jwt.Value;
    }

    public async Task<AuthResponse> EnsurePersonalSessionAsync(CancellationToken ct = default)
    {
        if (!_personal.Enabled)
            throw new InvalidOperationException("PersonalMode is disabled.");

        var user = await _users.FindByEmailAsync(_personal.DefaultEmail);
        if (user is null)
        {
            user = new AppUser
            {
                UserName = _personal.DefaultEmail,
                Email = _personal.DefaultEmail,
                EmailConfirmed = true
            };
            var created = await _users.CreateAsync(user, _personal.DefaultPassword);
            if (!created.Succeeded)
                throw new InvalidOperationException(string.Join("; ", created.Errors.Select(e => e.Description)));
        }

        var (access, exp) = _tokens.CreateAccessToken(user);
        var refresh = _tokens.CreateRefreshToken();
        _refreshStore.Save(user.Id, refresh, DateTime.UtcNow.AddDays(_jwt.RefreshTokenDays));
        return new AuthResponse(access, refresh, exp, user.Id, user.Email ?? _personal.DefaultEmail);
    }
}
