import 'dart:async';

Duration _max(Duration a, Duration b) {
  return a < b ? b : a;
}

/// Manually tick timer to fake [Timer]
class ManualTimer implements Timer {
  late final Duration _period;

  late Duration _nextTime;

  final void Function(Timer) _callback;

  int _tick = 0;

  /// Create a one-shot timer
  ///
  /// Duration.zero is not supported
  ManualTimer(Duration duration, this._callback) {
    _period = Duration.zero;
    _nextTime = _max(duration, Duration.zero);
  }

  /// Create a periodic timer
  ///
  /// Duration.zero is not supported
  ManualTimer.periodic(Duration period, this._callback) {
    period = _max(period, Duration.zero);
    _period = period;
    _nextTime = period;
  }

  /// Time till next fire, if this is Duration.zero, this timer is inactive
  Duration get nextTime => _nextTime;

  void elapse(Duration duration) {
    if (_nextTime == Duration.zero) {
      // stopped
      return;
    }

    while (duration.inMicroseconds > 0) {
      if (duration >= _nextTime) {
        _callback(this);
        ++_tick;
        duration -= _nextTime;
        if (_period != Duration.zero) {
          // periodic timer
          _nextTime = _period;
        } else {
          // one-shot timer
          cancel();
          break;
        }
      } else {
        // duration < _nextTime
        _nextTime -= duration;
        break;
      }
    }
  }

  @override
  void cancel() {
    _nextTime = Duration.zero;
  }

  @override
  int get tick => _tick;

  @override
  bool get isActive => _nextTime != Duration.zero;
}
