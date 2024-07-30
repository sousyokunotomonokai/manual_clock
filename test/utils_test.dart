import 'dart:async';
import 'package:test/test.dart';
import 'package:clock/clock.dart';

import 'package:manual_clock/manual_clock.dart';
import 'package:manual_clock/src/manual_timer.dart';

void main() {
  test('The clock will be substituted with ManualClock instance', () {
    withManualClock((c) {
      expect(clock, c);
      expect(clock, isA<ManualClock>());
    });
  });

  test('A Timer instance will be ManualTimer inside withManualClock callback',
      () async {
    withManualClock((clock) {
      var timerExecuted = false;
      final timer = Timer(const Duration(hours: 1), () {
        timerExecuted = true;
      });
      expect(timer, isA<ManualTimer>());
      clock.elapse(const Duration(minutes: 59));
      expect(timerExecuted, false);
      expect(timer.tick, 0);
      expect(timer.isActive, true);

      clock.elapse(const Duration(minutes: 1));
      expect(timerExecuted, true);
      expect(timer.tick, 1);
      expect(timer.isActive, false);
    });
  });

  test('waitRealLifeTime inside withManualClock callback', () async {
    await withManualClock((clock) async {
      final from = DateTime.now();
      final duration = Duration(seconds: 1);
      await waitRealLifeTime(duration);
      final to = DateTime.now();
      expect(to.difference(from), greaterThanOrEqualTo(duration));
    });
  });
}
