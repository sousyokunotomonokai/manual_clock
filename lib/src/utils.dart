import 'dart:async';
import 'package:clock/clock.dart';

import 'manual_clock.dart';
import 'manual_timer.dart';

/// Run [callback] with overriding the top level clock field with a manual clock.
///
/// This function is useful for testing clock.now() and [Timer] related code.
T withManualClock<T>(
  T Function(ManualClock clock) callback, {
  DateTime? initialTime,
}) {
  final clock = ManualClock(initialTime: initialTime);
  return withClock(
    clock,
    () => runZoned(
      () => callback(clock),
      zoneSpecification: ZoneSpecification(
        createTimer: (_, __, ___, duration, callback) {
          final timer = ManualTimer(duration, (timer) => callback());
          clock.addTimer(timer);
          return timer;
        },
        createPeriodicTimer: (_, __, ___, period, callback) {
          final timer = ManualTimer.periodic(period, callback);
          clock.addTimer(timer);
          return timer;
        },
      ),
    ),
  );
}

/// Wait for real life time
///
/// Inside [withManualClock] callback, await Future.delayed(...) don't work
/// because time is freezed virtually.
/// Using this function, you can wait for real life time inside [withManualClock] callback.
Future<void> waitRealLifeTime(Duration duration) {
  return runZoned(
    () {
      return Future.delayed(duration);
    },
    zoneSpecification: ZoneSpecification(
      createTimer: (_, __, ___, duration, callback) {
        return Zone.root.createTimer(duration, callback);
      },
      createPeriodicTimer: (_, __, ___, period, callback) {
        return Zone.root.createPeriodicTimer(period, callback);
      },
    ),
  );
}
