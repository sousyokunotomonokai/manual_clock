import 'package:collection/collection.dart';
import 'package:clock/clock.dart';

import 'manual_timer.dart';

Duration _minDuration(Duration a, Duration b) {
  return a.compareTo(b) < 0 ? a : b;
}

/// A clock which will not tick automatically, but only tick manually.
class ManualClock extends Clock {
  final DateTime _initialTime;
  var _elapsed = Duration.zero;
  final _timers = <ManualTimer>[];

  ManualClock({DateTime? initialTime})
      : _initialTime = initialTime ?? clock.now();

  @override
  DateTime now() => _initialTime.add(_elapsed);

  /// Get total elapsed time
  Duration get elapsed => _elapsed;

  /// Tick manually
  ///
  /// Throws an [ArgumentError] if [duration] is negative value.
  void elapse(Duration duration) {
    if (duration.inMicroseconds < 0) {
      throw ArgumentError.value(
          duration, 'duration', 'may not be negative value');
    }

    // tick timers
    _removeInactiveTimers();
    if (_timers.isNotEmpty) {
      var rest = duration;
      do {
        final minNextTime = minBy(_timers, (timer) => timer.nextTime)!.nextTime;
        assert(minNextTime >= Duration.zero);
        final elapsedTime = _minDuration(rest, minNextTime);
        _elapsed += elapsedTime;

        // create a copy of the timer list to handle the case that
        // a new timer is created inside timer callback.
        final timers = [..._timers];
        for (final timer in timers) {
          timer.elapse(elapsedTime);
        }
        rest -= elapsedTime;
        _removeInactiveTimers();
      } while (_timers.isNotEmpty && rest > Duration.zero);
      _elapsed += rest;
    } else {
      _elapsed += duration;
    }
  }

  void addTimer(ManualTimer timer) {
    if (timer.isActive) {
      _timers.add(timer);
    }
  }

  void removeTimer(ManualTimer timer) {
    _timers.remove(timer);
  }

  void _removeInactiveTimers() {
    _timers.removeWhere((timer) => !timer.isActive);
  }
}
