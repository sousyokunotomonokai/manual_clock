import 'dart:async';
import 'package:clock/clock.dart';

import 'manual_clock.dart';
import 'manual_timer.dart';

/// Run [callback] with overriding the top level clock field with a manual clock.
///
/// This function is useful for testing clock.now() ans [Timer] related code.
T withManualClock<T>(
  T Function(ManualClock clock) callback, {
  DateTime? initialTime,
}) {
  final clock = ManualClock(initialTime: initialTime);
  return runZoned(
    () => withClock(clock, () => callback(clock)),
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
  );
}
