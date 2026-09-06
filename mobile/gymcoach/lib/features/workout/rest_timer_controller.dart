import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Survives tab navigation; lives at app scope.
class RestTimerController extends ChangeNotifier {
  Timer? _ticker;
  DateTime? _endsAt;
  Duration _remaining = Duration.zero;
  bool _paused = false;
  Duration _pausedRemaining = Duration.zero;

  Duration get remaining => _paused ? _pausedRemaining : _computeRemaining();
  int get remainingSeconds => remaining.inSeconds;
  bool get isRunning => remainingSeconds > 0;
  bool get isPaused => _paused;

  Duration _computeRemaining() {
    if (_endsAt == null) return Duration.zero;
    final left = _endsAt!.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  void start(int seconds) {
    _ticker?.cancel();
    _paused = false;
    _remaining = Duration(seconds: seconds);
    _endsAt = DateTime.now().add(_remaining);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_computeRemaining() == Duration.zero) {
        _ticker?.cancel();
        HapticFeedback.mediumImpact();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    if (!isRunning || _paused) return;
    _pausedRemaining = _computeRemaining();
    _paused = true;
    _endsAt = null;
    notifyListeners();
  }

  void resume() {
    if (!_paused) return;
    _paused = false;
    _endsAt = DateTime.now().add(_pausedRemaining);
    notifyListeners();
  }

  void addSeconds(int seconds) {
    if (_paused) {
      _pausedRemaining += Duration(seconds: seconds);
    } else if (_endsAt != null) {
      _endsAt = _endsAt!.add(Duration(seconds: seconds));
    } else {
      start(seconds);
      return;
    }
    notifyListeners();
  }

  void skip() {
    _ticker?.cancel();
    _endsAt = null;
    _paused = false;
    _pausedRemaining = Duration.zero;
    notifyListeners();
  }

  void reset(int seconds) => start(seconds);

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final restTimerProvider = ChangeNotifierProvider<RestTimerController>((ref) {
  final c = RestTimerController();
  ref.onDispose(c.dispose);
  return c;
});
