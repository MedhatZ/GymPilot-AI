# GymCoach AI — Huawei / Wearable Integration

## Boundary

Core app depends on `WearableHealthProvider`, not Huawei SDKs.

```dart
abstract interface class WearableHealthProvider {
  Future<WearableAuthStatus> connect();
  Future<void> disconnect();
  Future<bool> isAvailable();
  Stream<DailyHealthSnapshot> watchDailyMetrics();
  Future<List<SleepSample>> getSleep(DateRange range);
  Future<List<HeartRateSample>> getHeartRate(DateRange range);
  // stress, SpO2, activity, workouts as available
}
```

Implementations:

- `NullWearableHealthProvider` — always available; no-op
- `HuaweiHealthProvider` — Health Service Kit (requires developer config)
- Future: `AppleHealthProvider`, `HealthConnectProvider`

## Signal priority

1. **Gym performance** (primary)
2. Session feedback (difficulty, pain)
3. Wearable recovery metrics (supporting only)

Wearable failure must **never** block workout logging. Wearable-only signals must **never** independently replace a program.

## Data mapped when authorized

Heart rate, resting HR, sleep duration/quality, stress, SpO2, daily activity, workout/activity records.

## Permissions

Least privilege; request only needed scopes. Document Huawei console setup separately; mark Huawei paths incomplete until credentials exist.

## Backend

Optional sync of daily/sleep metrics to `wearable_*` / `sleep_metrics` tables for recovery model. Same abstraction: supporting signals only.
