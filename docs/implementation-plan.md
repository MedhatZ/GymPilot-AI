# GymCoach AI — Implementation Plan

## Phases & completion criteria

| Phase | Deliverable | Done when |
|-------|-------------|-----------|
| 0 | Architecture docs | Docs present under `docs/` |
| 1 | Solution + Flutter scaffold, Docker compose, DI, logging | `dotnet build` + `flutter analyze` |
| 2 | Domain + EF schema + migration | Migration applies |
| 3 | Auth + onboarding | Register/login/refresh; profile save |
| 4 | Exercise library | Seeded; list API |
| 5 | Program generation | Active program, null endDate |
| 6 | Offline workout logger | Full session offline |
| 7 | Sync | Idempotent upsert; no dup sets |
| 8 | Metrics engine | Unit tests green |
| 9 | Progressive overload | Unit tests green |
| 10 | PR + trends | Unit tests green |
| 11 | Plateau + policy | Multi-exposure tests |
| 12 | Decisions + versioning + deload | Version history correct |
| 13 | Wearable abstraction (+ Huawei gated) | Null provider works |
| 14 | Recovery | Graceful without wearable |
| 15 | AI context + structured recs | Fake AI + guardrails |
| 16 | AI Coach | Stubbed Q&A tests |
| 17 | Progress UI | Charts/history |
| 18 | Hardening | Engines covered; audit queryable |

## Credential-gated work

- Huawei Developer / Health Kit / signing → real Huawei provider
- OpenAI API key → live AI (not tests)
- Store signing / cloud deploy → release

## Working rules

- Keep solution compiling; fix tests before advancing
- No secrets in git
- No nutrition features
- LLM is not the business-rules engine
