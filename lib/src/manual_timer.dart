import 'dart:async';

Duration _max(Duration a, Duration b) {
  return a < b ? b : a;
}

/// Manually tick timer to fake [Timer]
class ManualTimer implements Timer {
  late final Duration _period;

  late Duration _nextTime;
  late bool _isActive;

  final void Function(Timer) _callback;

  int _tick = 0;

  /// Create a one-shot timer
  ManualTimer(Duration duration, this._callback) {
    _period = Duration.zero;
    _nextTime = _max(duration, Duration.zero);
    _isActive = true;
  }

  /// Create a periodic timer
  ///
  /// Duration.zero is not supported
  ManualTimer.periodic(Duration period, this._callback) {
    period = _max(period, Duration.zero);
    _period = period;
    _nextTime = period;
    _isActive = period > Duration.zero;
  }

  /// Time till next fire
  Duration get nextTime => _nextTime;

  void elapse(Duration duration) {
    if (!_isActive) {
      return;
    }

    if (_nextTime <= Duration.zero) {
      _exec();
    }

    while (_isActive && duration.inMicroseconds > 0) {
      if (duration >= _nextTime) {
        duration -= _nextTime;
        _exec();
      } else {
        _nextTime -= duration;
        break;
      }
    }
  }

  /// execute the callback and update _nextTime
  void _exec() {
    _callback(this);
    ++_tick;
    if (_period != Duration.zero) {
      // periodic timer
      _nextTime = _period;
    } else {
      // one-shot timer
      cancel();
    }
  }

  @override
  void cancel() {
    _nextTime = Duration.zero;
    _isActive = false;
  }

  @override
  int get tick => _tick;

  @override
  bool get isActive => _isActive;
}
