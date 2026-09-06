# Personal MVP — Gap Analysis

Date: 2026-09-06  
Scope: Turn existing greenfield foundation into a usable single-user Personal MVP. **Do not rebuild architecture.**

## Already exists (keep)

| Area | Notes |
|------|--------|
| Modular ASP.NET backend + Flutter Riverpod/GoRouter/Dio/Drift | Intact |
| Auth (Identity + JWT) | Keep; bypass in Personal Mode only |
| Onboarding API upsert | Reusable for profile edit |
| Program generation, `EndDateUtc` null | Intact |
| Workout start/log/complete + ClientId idempotency | Intact |
| Progressive overload, e1RM, PRs, plateau/decision engines | Intact (plateau under-wired) |
| Fake AI coach | Intact |
| Wearable abstraction + Null provider | Intact |
| Sync batch + Idempotency-Key | Partial but present |
| Engine unit tests + API smoke | Preserve |

## Partial

| Area | Gap |
|------|-----|
| Home `TodaysWorkout` | Session-count modulo; not scoped to last `ProgramDayId` |
| Workout Flutter UI | Logs sets but hardcoded Bench Press; no resume/finish/edit/±/RIR chips |
| Rest timer | Starts after set; no pause/resume/+30/skip; lost on navigation |
| Drift | Schema OK; no active-session query; `completedAt` unused by UI |
| Sync | Outbox incomplete; re-pushes sessions |
| Profile | Sign-out + wearable only; no settings/edit |
| Progress | API-only; thin UX |
| Coach | Free text only; no predefined personal questions |
| Decision evaluate | Stub context; never applied |

## Missing (Personal MVP must add)

1. **PersonalMode** config/service (central, not scattered)
2. Auth bypass / personal bootstrap (keep auth code)
3. Compact first-run setup (5 short steps)
4. Editable full athlete profile in Settings
5. Next-workout by last completed program day + manual day pick
6. Production workout logger (prescription, previous, ± weight, RIR chips, warm-up, edit/delete)
7. Resume active workout after app restart
8. Finish workout → difficulty/pain → summary + PR UX
9. Recommendation “Why?” UX
10. Manual readiness (energy/soreness/motivation)
11. Settings (units, increments, Huawei/AI status, Personal Mode)
12. Dark theme default for gym
13. Tests for personal mode, resume, next workout, EndDate null continue

## Untouched on purpose

- Live Huawei Health Kit / OpenAI
- Nutrition, social, subscriptions, admin, other wearables
- Public SaaS multi-tenant UX
- Calendar-forced program rotation

## Implementation order

A Personal Mode + profile → B Home/next workout → C Workout logger → D Offline resume → E Summary/PRs → F Progress → G Recommendations → H Readiness/Settings → I Tests/polish
