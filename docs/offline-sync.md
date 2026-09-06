# GymCoach AI — Offline Sync

## Requirements

User must start/log/finish workouts and view today's sets with **no network**. Sync when connectivity returns.

## Client (Drift)

- Local tables for sessions, exercises, sets with `client_id` UUID
- Immediate save on each set
- Outbox `sync_operations`: operation_type, payload_json, status, attempts, idempotency_key, last_error
- Flush on connectivity; exponential backoff

## Server

- `POST /api/sync/workouts` batch upsert
- Identity: `(userId, clientId)` unique
- Header `Idempotency-Key` supported; store `idempotency_records`
- Retries must not duplicate sets

## Conflict rules (v1)

- **In-progress sessions:** last client write wins for mutable fields
- **Completed sessions:** immutable except additive notes
- Optimistic concurrency via `UpdatedAtUtc` / row version
- v1 assumes **single primary device**; multi-device documented as limitation

## Idempotency

Client generates UUIDs before first save. Server upserts by client id. Operations are safe to retry.

## Failure modes

- Sync failure: keep Pending/Failed in outbox; user continues logging
- Partial batch: per-item results; succeeded items not re-applied as inserts
