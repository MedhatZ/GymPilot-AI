import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateRange {
  DateRange(this.start, this.end);
  final DateTime start;
  final DateTime end;
}

class WearableAuthStatus {
  const WearableAuthStatus({required this.connected, this.message});
  final bool connected;
  final String? message;
}

class DailyHealthSnapshot {
  const DailyHealthSnapshot({
    this.restingHeartRate,
    this.steps,
    this.stressScore,
    this.spo2,
  });
  final int? restingHeartRate;
  final int? steps;
  final int? stressScore;
  final double? spo2;
}

class SleepSample {
  const SleepSample({required this.date, required this.durationHours});
  final DateTime date;
  final double durationHours;
}

class HeartRateSample {
  const HeartRateSample({required this.at, required this.bpm});
  final DateTime at;
  final int bpm;
}

/// Abstraction so Huawei is not coupled through the app.
abstract interface class WearableHealthProvider {
  Future<WearableAuthStatus> connect();
  Future<void> disconnect();
  Future<bool> isAvailable();
  Stream<DailyHealthSnapshot> watchDailyMetrics();
  Future<List<SleepSample>> getSleep(DateRange range);
  Future<List<HeartRateSample>> getHeartRate(DateRange range);
}

class NullWearableHealthProvider implements WearableHealthProvider {
  @override
  Future<WearableAuthStatus> connect() async =>
      const WearableAuthStatus(connected: false, message: 'No wearable configured');

  @override
  Future<void> disconnect() async {}

  @override
  Future<bool> isAvailable() async => false;

  @override
  Stream<DailyHealthSnapshot> watchDailyMetrics() => const Stream.empty();

  @override
  Future<List<SleepSample>> getSleep(DateRange range) async => [];

  @override
  Future<List<HeartRateSample>> getHeartRate(DateRange range) async => [];
}

/// Requires Huawei Developer / Health Kit credentials. Not functional until configured.
class HuaweiHealthProvider implements WearableHealthProvider {
  HuaweiHealthProvider({this.appId});

  final String? appId;

  @override
  Future<WearableAuthStatus> connect() async {
    if (appId == null || appId!.isEmpty) {
      return const WearableAuthStatus(
        connected: false,
        message: 'Huawei Health Kit not configured (needs developer app id / scopes)',
      );
    }
    return const WearableAuthStatus(
      connected: false,
      message: 'Huawei SDK wiring pending credentials',
    );
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<bool> isAvailable() async => false;

  @override
  Stream<DailyHealthSnapshot> watchDailyMetrics() => const Stream.empty();

  @override
  Future<List<SleepSample>> getSleep(DateRange range) async => [];

  @override
  Future<List<HeartRateSample>> getHeartRate(DateRange range) async => [];
}

final wearableProvider = Provider<WearableHealthProvider>((ref) {
  // Prefer Null provider so missing Huawei credentials never block workouts.
  return NullWearableHealthProvider();
});
