import 'package:clock/clock.dart';

/// A clock which will not tick automatically, but only tick manually.

class ManualClock extends Clock {
  final DateTime _initialTime;
  var _elapsed = Duration.zero;

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
    _elapsed += duration;
  }
}
