using GymCoach.Application.Auth;
using GymCoach.Infrastructure.Auth;
using GymCoach.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;

namespace GymCoach.Infrastructure.Auth;

public sealed class AuthService : IAuthService
{
    private readonly UserManager<AppUser> _users;
    private readonly SignInManager<AppUser> _signIn;
    private readonly ITokenService _tokens;
    private readonly RefreshTokenStore _refreshStore;
    private readonly JwtOptions _jwtOptions;

    public AuthService(
        UserManager<AppUser> users,
        SignInManager<AppUser> signIn,
        ITokenService tokens,
        RefreshTokenStore refreshStore,
        IOptions<JwtOptions> jwtOptions)
    {
        _users = users;
        _signIn = signIn;
        _tokens = tokens;
        _refreshStore = refreshStore;
        _jwtOptions = jwtOptions.Value;
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request, CancellationToken ct = default)
    {
        var user = new AppUser { UserName = request.Email, Email = request.Email };
        var result = await _users.CreateAsync(user, request.Password);
        if (!result.Succeeded)
            throw new InvalidOperationException(string.Join("; ", result.Errors.Select(e => e.Description)));
        return Issue(user);
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request, CancellationToken ct = default)
    {
        var user = await _users.FindByEmailAsync(request.Email)
                   ?? throw new UnauthorizedAccessException("Invalid credentials.");
        var ok = await _signIn.CheckPasswordSignInAsync(user, request.Password, false);
        if (!ok.Succeeded) throw new UnauthorizedAccessException("Invalid credentials.");
        return Issue(user);
    }

    public async Task<AuthResponse> RefreshAsync(RefreshRequest request, CancellationToken ct = default)
    {
        if (!_refreshStore.TryGet(request.RefreshToken, out var userId))
            throw new UnauthorizedAccessException("Invalid refresh token.");
        var principal = _tokens.GetPrincipalFromExpiredToken(request.AccessToken)
                        ?? throw new UnauthorizedAccessException("Invalid access token.");
        var sub = principal.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value
                  ?? principal.FindFirst("sub")?.Value;
        if (sub != userId) throw new UnauthorizedAccessException("Token mismatch.");
        var user = await _users.FindByIdAsync(userId) ?? throw new UnauthorizedAccessException("User not found.");
        _refreshStore.Invalidate(request.RefreshToken);
        return Issue(user);
    }

    private AuthResponse Issue(AppUser user)
    {
        var (access, exp) = _tokens.CreateAccessToken(user);
        var refresh = _tokens.CreateRefreshToken();
        _refreshStore.Save(user.Id, refresh, DateTime.UtcNow.AddDays(_jwtOptions.RefreshTokenDays));
        return new AuthResponse(access, refresh, exp, user.Id, user.Email ?? string.Empty);
    }
}
