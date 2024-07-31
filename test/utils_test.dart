// ignore_for_file: unused_local_variable

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

  test('The current time inside timer callback will pass gradually', () async {
    final initialTime = DateTime(2000);
    withManualClock(initialTime: initialTime, (clock) {
      const n = 3;
      final durations = List.generate(n, (i) => Duration(minutes: i + 1));
      final timerExecuted = List.generate(n, (i) => false);
      final timers = List.generate(
          n,
          (i) => Timer(durations[i], () {
                timerExecuted[i] = true;
                expect(clock.now(), initialTime.add(durations[i]));
              }));

      final totalTime =
          durations.fold(Duration.zero, (subTotal, d) => subTotal + d);
      clock.elapse(totalTime);

      for (int i = 0; i < timers.length; ++i) {
        expect(timerExecuted[i], true);
      }
    });
  });

  test('You can create a new timer inside timer callback', () async {
    withManualClock((clock) {
      var timerExecuted = false;
      var nestedTimerExecuted = false;
      final timer = Timer(const Duration(hours: 1), () {
        timerExecuted = true;
        final nestedTimer = Timer(const Duration(hours: 1), () {
          nestedTimerExecuted = true;
        });
      });

      clock.elapse(const Duration(hours: 2));
      expect(timerExecuted, true);
      expect(nestedTimerExecuted, true);
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
