namespace GymCoach.AI.Clients;

/// <summary>Tracks OpenAI connectivity for Settings without exposing secrets.</summary>
public interface IAiRuntimeStatus
{
    string Status { get; }
    string? LastErrorSummary { get; }
    void MarkNotConfigured();
    void MarkConnected();
    void MarkError(string safeSummary);
}

public sealed class AiRuntimeStatus : IAiRuntimeStatus
{
    private readonly object _gate = new();
    private string _status = "NotConfigured";
    private string? _lastError;

    public string Status
    {
        get { lock (_gate) return _status; }
    }

    public string? LastErrorSummary
    {
        get { lock (_gate) return _lastError; }
    }

    public void MarkNotConfigured()
    {
        lock (_gate)
        {
            _status = "NotConfigured";
            _lastError = null;
        }
    }

    public void MarkConnected()
    {
        lock (_gate)
        {
            _status = "Connected";
            _lastError = null;
        }
    }

    public void MarkError(string safeSummary)
    {
        lock (_gate)
        {
            _status = "Error";
            _lastError = Truncate(safeSummary);
        }
    }

    private static string Truncate(string s) =>
        string.IsNullOrWhiteSpace(s) ? "provider error" :
        s.Length <= 120 ? s : s[..120];
}
