# Deploy GymCoach API to Render.com

The ASP.NET Core API lives in `backend/` and ships with a multi-stage `Dockerfile` targeting .NET 9.

Repository: https://github.com/MedhatZ/GymPilot-AI

## What Render needs

| Setting | Value |
|---------|--------|
| Root Directory | `backend` |
| Environment | Docker |
| Dockerfile Path | `./Dockerfile` (relative to Root Directory) |
| Health Check Path | `/health` |

Render injects `PORT` at runtime. The API listens on `http://0.0.0.0:${PORT}` when `PORT` is set (see `Program.cs`). Do **not** hard-code `5080` on Render.

Swagger stays **disabled** in Production (Development only).

## Required environment variables

Set these in the Render service **Environment** tab:

| Variable | Required | Example / notes |
|----------|----------|-----------------|
| `ASPNETCORE_ENVIRONMENT` | Recommended | `Production` (also set in the image) |
| `Jwt__SigningKey` | **Yes** | Long random secret (≥32 chars). App refuses the `DEV_ONLY_*` placeholder in Production. |
| `Database__UseInMemory` | Recommended | `true` for a zero-Postgres MVP on Render (ephemeral; resets on restart/redeploy). |
| `OpenAI__Enabled` | Optional | `true` to enable live coaching |
| `OpenAI__ApiKey` | If OpenAI on | Never commit; Render secret only |
| `OpenAI__Model` | Optional | e.g. `gpt-4o-mini` |
| `OpenAI__BaseUrl` | Optional | default `https://api.openai.com/v1` |

Optional / advanced:

| Variable | Notes |
|----------|--------|
| `OPENAI_API_KEY` / `OPENAI_MODEL` | Flat aliases also supported by the AI binder |
| `Database__UseInMemory=false` | Requires a reachable Postgres URL |
| `ConnectionStrings__Default` | Npgsql connection string when not using in-memory |
| `Jwt__Issuer` / `Jwt__Audience` | Defaults: `GymCoach` / `GymCoachMobile` |
| `PersonalMode__Enabled` | Defaults to enabled from config |

**Do not commit secrets.** Keep real keys only in Render (or local user-secrets / `.env` that is gitignored).

## Render setup steps

1. Push this repo to GitHub (already: `MedhatZ/GymPilot-AI`).
2. In Render: **New → Web Service** → connect the repo.
3. Set **Root Directory** to `backend`.
4. Runtime: **Docker**.
5. Add the environment variables above (`Jwt__SigningKey` at minimum; `Database__UseInMemory=true` for simplest deploy).
6. Deploy. Health check: `GET /health` → `{ "status": "healthy", "product": "GymCoach AI" }`.

Public URL example: `https://<your-service>.onrender.com/health`

## Local Docker verification

From `backend/`:

```bash
docker build -t gymcoach-api .

docker run --rm -p 5080:8080 ^
  -e PORT=8080 ^
  -e ASPNETCORE_ENVIRONMENT=Production ^
  -e Database__UseInMemory=true ^
  -e Jwt__SigningKey=LOCAL_DOCKER_TEST_SIGNING_KEY_AT_LEAST_32_CHARS ^
  gymcoach-api
```

(On bash/macOS/Linux, use `\` line continuations instead of `^`.)

Then:

```bash
curl http://localhost:5080/health
```

Container listens on **8080** inside the network namespace (`PORT=8080`). Host maps **5080→8080** for convenience; local `dotnet run` without Docker still uses launchSettings **5080** and is unchanged.

## Notes

- In-memory EF is fine for smoke / Personal Mode demos on Render; data is **not** durable across restarts.
- For durable Postgres later: provision a database, set `Database__UseInMemory=false` and `ConnectionStrings__Default`, then redeploy.
- OpenAI is off unless `OpenAI__Enabled=true` and a real `OpenAI__ApiKey` are provided.
- Refresh tokens are stored in-process; expect re-login after instance restart.
