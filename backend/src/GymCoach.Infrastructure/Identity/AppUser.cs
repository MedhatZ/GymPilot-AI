using GymCoach.Domain.Entities;
using Microsoft.AspNetCore.Identity;

namespace GymCoach.Infrastructure.Identity;

public class AppUser : IdentityUser
{
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public AthleteProfile? AthleteProfile { get; set; }
}
