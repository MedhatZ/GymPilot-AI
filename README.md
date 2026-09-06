# GymCoach AI

AI-powered adaptive strength and hypertrophy coach (Flutter + ASP.NET Core).

**Not a nutrition app.** Programs do not expire on a calendar — changes are evidence-triggered only.

## Repository layout

- `docs/` — architecture and design
- `backend/` — ASP.NET Core modular solution
- `mobile/gymcoach/` — Flutter client
- `docker/docker-compose.yml` — PostgreSQL 16

## Personal Mode (default)

`PersonalMode:Enabled=true` skips login/register. The app calls `POST /api/auth/personal-bootstrap` and enters setup once if the profile is incomplete.

Auth (register/login/refresh) remains available when Personal Mode is disabled.

```bash
cd backend
dotnet restore
dotnet build
dotnet test
dotnet run --project src/GymCoach.Api
```

Default configuration uses **in-memory EF** (`Database:UseInMemory=true`) so the API runs without Docker.

To use PostgreSQL:

1. Start Postgres: `docker compose -f docker/docker-compose.yml up -d` (requires Docker)
2. Set `Database:UseInMemory` to `false` in `appsettings.json` or environment
3. Apply schema via `EnsureCreated` on startup (seed) or add EF migrations when ready

Swagger: `/swagger` in Development. Health: `/health`.

### Auth

JWT access + refresh tokens. Configure `Jwt:SigningKey` via environment in production — never commit real secrets.

### AI

`Ai:Enabled=false` by default. Fake AI client is used for tests and local coaching stubs. Set `Ai:ApiKey` only via env/user-secrets when enabling live models.

### Huawei Health

Wearable integration is abstracted on mobile (`WearableHealthProvider`). Real Huawei Health Kit requires developer console credentials and is gated.

## Flutter quick start

```bash
cd mobile/gymcoach
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

API base URL defaults to Android emulator loopback `http://10.0.2.2:5xxx` — adjust in `ApiClient`.

## Documentation

See `docs/architecture.md` and related design docs for domain, training engine, AI guardrails, offline sync, and Huawei boundaries.
