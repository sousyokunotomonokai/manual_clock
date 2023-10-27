import 'package:clock/clock.dart';

import 'manual_clock.dart';

/// Run [callback] with overriding the top level clock field with a manual clock.
///
/// This function is useful for testing clock.now() related code.
T withManualClock<T>(
  T Function(ManualClock clock) callback, {
  DateTime? initialTime,
}) {
  final clock = ManualClock(initialTime: initialTime);
  return withClock(clock, () => callback(clock));
}
