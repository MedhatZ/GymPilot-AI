# GymCoach AI — Architecture

## Product

GymCoach AI is an AI-powered adaptive strength and hypertrophy coach (Flutter + ASP.NET Core). It is **not** a nutrition app.

**Critical rule:** Training programs do **not** expire on a calendar. Program changes are evidence-triggered only. `Program.EndDate` is normally `null`.

## Monorepo layout

```text
/
  docs/
  backend/
    GymCoach.sln
    src/
      GymCoach.Api
      GymCoach.Application
      GymCoach.Domain
      GymCoach.Infrastructure
      GymCoach.TrainingEngine
      GymCoach.AI
    tests/
  mobile/gymcoach/
  docker/docker-compose.yml
```

## Layer responsibilities

| Project | Responsibility |
|---------|----------------|
| **Domain** | Entities, enums, value objects. No EF/IO. |
| **TrainingEngine** | Deterministic metrics, overload, plateau, deload, program decisions. |
| **AI** | Context builder + structured LLM client. Never writes DB. |
| **Application** | Use cases; applies only policy-approved commands. |
| **Infrastructure** | EF Core, Identity/JWT, persistence, external adapters. |
| **Api** | HTTP, auth, ProblemDetails, idempotency, OpenAPI. |

## Data flow (training decisions)

```text
Database
  → Deterministic Metrics Engine
  → Training Context Builder
  → (optional) AI Analysis
  → Structured Recommendation
  → Training Policy Validator
  → Approved Domain Command
  → Database + ProgramDecision audit
```

## Mobile architecture

- **Riverpod** state, **GoRouter** navigation, **Dio** HTTP
- **Drift** offline-first workout persistence + sync outbox
- **flutter_secure_storage** for tokens
- **WearableHealthProvider** abstraction (Huawei first; Null provider always available)

## Stack decisions

| Concern | Choice |
|---------|--------|
| .NET | .NET 8+ (SDK 9 compatible targeting net8.0 / net9.0 as available) |
| ORM | EF Core + PostgreSQL |
| Auth | Identity + JWT access/refresh (`ITokenService`) |
| Validation | FluentValidation |
| 1RM | Epley via `IEstimatedOneRepMaxCalculator` |
| AI | OpenAI-compatible behind `IAiCoachClient` (fake in tests) |

## Non-goals

- Meal plans, calories, macros, food logging, diet advice
- Calendar-based program rotation (4/6/8/12 week cycles)
- AI direct database access or unvalidated writes

## Security

- User-scoped queries only
- Secrets via environment / user-secrets — never committed
- Wearable scopes: least privilege
- Tokens in secure storage on device
