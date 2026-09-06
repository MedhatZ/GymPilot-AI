# OpenAI setup (GymCoach AI)

Secrets stay on the **backend only**. Flutter never embeds an API key and never calls OpenAI directly.

## Environment variables

Preferred:

```text
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o-mini
```

Also supported (ASP.NET Core `__` nesting):

```text
OpenAI__Enabled=true
OpenAI__ApiKey=...
OpenAI__Model=gpt-4o-mini
OpenAI__BaseUrl=https://api.openai.com/v1
OpenAI__TimeoutSeconds=30
OpenAI__MaxRetries=2
```

Alternate `Ai__*` keys and AgentRouter-compatible `BaseUrl` are also bound. See `.env.example`.

On Render.com, set the same `OpenAI__*` variables as secrets — see [`render-deployment.md`](render-deployment.md).

Default model for personal use: **`gpt-4o-mini`** (change via config, not code).

## PowerShell (local)

```powershell
cd "d:\upwork\GymPilot AI\backend"
$env:OpenAI__Enabled = "true"
$env:OpenAI__ApiKey = $env:OPENAI_API_KEY   # set OPENAI_API_KEY first
$env:OpenAI__Model = "gpt-4o-mini"
$env:OpenAI__BaseUrl = "https://api.openai.com/v1"
dotnet run --project src/GymCoach.Api
```

Or with user-secrets (recommended so the key is not in the shell history):

```powershell
cd "d:\upwork\GymPilot AI\backend"
dotnet user-secrets set "OpenAI:Enabled" "true" --project src/GymCoach.Api
dotnet user-secrets set "OpenAI:ApiKey" "YOUR_KEY" --project src/GymCoach.Api
dotnet user-secrets set "OpenAI:Model" "gpt-4o-mini" --project src/GymCoach.Api
dotnet user-secrets set "OpenAI:BaseUrl" "https://api.openai.com/v1" --project src/GymCoach.Api
dotnet run --project src/GymCoach.Api
```

## bash

```bash
cd backend
export OPENAI_API_KEY="YOUR_KEY"
export OPENAI_MODEL="gpt-4o-mini"
export OpenAI__Enabled=true
export OpenAI__BaseUrl="https://api.openai.com/v1"
dotnet run --project src/GymCoach.Api
```

## Verify without exposing secrets

```bash
curl -s http://localhost:5080/api/personal/status
```

Expect `aiConfigured`, `aiStatus` (`Connected` | `NotConfigured` | `Error`), `aiCoach`, `aiModel` — **no** `apiKey` field.

## Sample Coach request

```bash
# after personal bootstrap + JWT
curl -s -X POST http://localhost:5080/api/coach/ask \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"question":"Am I progressing?","exerciseId":null}'
```

Example response (OpenAI live):

```json
{
  "answer": "Your overall strength trend is positive with solid adherence…",
  "refusedNutrition": false,
  "citedFacts": ["Overall strength trend: positive", "..."],
  "source": "OPENAI",
  "confidence": 0.85,
  "dataSufficiency": "SUFFICIENT"
}
```

On failure / not configured:

```json
{
  "answer": "Based on your training context: trend is positive…",
  "source": "TRAINING_ENGINE",
  "confidence": 0.75,
  "dataSufficiency": "SUFFICIENT"
}
```

## Fallback behavior

Timeouts, network errors, rate limits, invalid keys, and invalid structured JSON all fall back to the training-engine provider. The app remains fully usable with `OpenAI:Enabled=false`.

## Testing

Automated tests use a fake `HttpMessageHandler` — they never call the real OpenAI API. See `AiAndPolicyApplicationTests`.
