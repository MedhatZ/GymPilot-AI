namespace GymCoach.Application.Personal;

public sealed class PersonalModeOptions
{
    public const string SectionName = "PersonalMode";
    public bool Enabled { get; set; } = true;
    public string DefaultEmail { get; set; } = "personal@gymcoach.local";
    public string DefaultDisplayName { get; set; } = "Athlete";
    public string DefaultPassword { get; set; } = "PersonalMode1!";
}

public interface IPersonalModeAccessor
{
    bool IsEnabled { get; }
    PersonalModeOptions Options { get; }
}

public sealed class PersonalModeAccessor : IPersonalModeAccessor
{
    public PersonalModeAccessor(Microsoft.Extensions.Options.IOptions<PersonalModeOptions> options)
    {
        Options = options.Value;
    }

    public bool IsEnabled => Options.Enabled;
    public PersonalModeOptions Options { get; }
}
