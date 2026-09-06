# Standalone Personal Mode

## Goal

When `AppConfig.personalMode = true` (default), GymCoach AI runs as a **fully on-device** personal app. Core training features do **not** require the ASP.NET backend or network access.

## Architecture switch

Screens talk to repository interfaces. Providers pick the implementation:

| Mode | Provider selection |
|------|--------------------|
| PersonalMode | `Local*Repository` (Drift + local training math) |
| CloudMode (`personalMode: false`) | `Api*Repository` (+ local fallbacks where useful) |

Key files:

- `lib/data/repositories/repository_contracts.dart`
- `lib/data/repositories/repository_providers.dart`
- `lib/data/repositories/local/*`
- `lib/data/repositories/api/*`
- `lib/training/local_program_generator.dart`
- `lib/training/local_training_math.dart`
- `lib/training/exercise_catalog.dart`

Widgets should **not** scatter `if (personalMode)` for business logic — they depend on repositories.

## Local source of truth (Drift `gymcoach_v3`)

- Athlete profile + `onboardingCompleted`
- Programs / program days / program exercises (`endDateUtc` normally null)
- Workout sessions / exercises / sets
- Local personal records
- Sync outbox (unused for flush in Personal Mode)

## What runs fully offline

1. Bootstrap (no `personal-bootstrap`)
2. Quick setup / onboarding
3. Initial program generation (deterministic rules)
4. Home / next workout (sequence by last completed day)
5. Start / log / resume / finish workouts
6. e1RM, progressive overload suggestions, PR detection
7. Progress overview
8. Coach Q&A via local Training Engine explanations

## What still may use internet

| Feature | Behavior in Personal Mode |
|---------|---------------------------|
| OpenAI Coach | Not called; local Training Engine answers |
| Backend API (`10.0.2.2` etc.) | Not required; unused for core flows |
| Huawei Health | Out of scope / stub |
| Cloud sync flush | No-op when Personal Mode is enabled |

OpenAI remains optional for future cloud/personal hybrid; unavailability must never block workouts.

## Acceptance checklist

1. Stop ASP.NET backend
2. Airplane mode on phone
3. Open app → Quick setup → Generate program
4. Start workout → log sets → kill app → reopen → resume
5. Finish → summary + progress
6. No DioException / SocketException shown to the user

## Enabling cloud mode later

Set `AppConfig(personalMode: false, apiBaseUrl: '...')` and keep API repositories intact.
