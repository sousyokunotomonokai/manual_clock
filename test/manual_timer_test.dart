// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:manual_clock/manual_clock.dart';

abstract class TimerCallback {
  void call();
}

abstract class PeriodicTimerCallback {
  void call(Timer timer);
}

class MockTimerCallback extends Mock implements TimerCallback {}

class MockPeriodicTimerCallback extends Mock implements PeriodicTimerCallback {
  @override
  void call(Timer? timer) {
    super.noSuchMethod(Invocation.method(#call, [timer]));
  }
}

void main() {
  test('A one-shot timer will fire if time pass manually', () {
    withManualClock((clock) {
      final callback = MockTimerCallback();
      const duration = Duration(seconds: 3);
      final timer = Timer(duration, callback);
      verifyNever(callback());
      clock.elapse(duration);
      verify(callback()).called(1);
    });
  });

  test('A one-shot timer of Duration.zero will fire immediately', () {
    withManualClock((clock) {
      final callback = MockTimerCallback();
      final timer = Timer(Duration.zero, callback);
      verifyNever(callback());
      clock.elapse(Duration.zero);
      verify(callback()).called(1);
    });
  });

  test('A periodic timer will fire periodically if time pass manually', () {
    withManualClock((clock) {
      final callback = MockPeriodicTimerCallback();
      const duration = Duration(seconds: 1);
      final timer = Timer.periodic(duration, callback);

      verifyNever(callback(timer));
      for (var i = 0; i < 3; ++i) {
        clock.elapse(duration);
        verify(callback(any)).called(1);
        expect(timer.tick, i + 1);
      }
    });
  });

  test('Multiple timers will fire if time pass manually', () {
    withManualClock((clock) {
      final list = <String>[];
      callback0() {
        list.add('0');
      }

      callback1() {
        list.add('1');
      }

      callback3() {
        list.add('3');
      }

      callback6() {
        list.add('6');
      }

      pcallback2(Timer _) {
        list.add('p2');
      }

      pcallback5(Timer _) {
        list.add('p5');
      }

      final timer0 = Timer(Duration.zero, callback0);
      final timer1 = Timer(Duration(seconds: 1), callback1);
      final timer3 = Timer(Duration(seconds: 3), callback3);
      final timer6 = Timer(Duration(seconds: 6), callback6);
      final ptimer2 = Timer.periodic(Duration(seconds: 2), pcallback2);
      final ptimer5 = Timer.periodic(Duration(seconds: 5), pcallback5);

      clock.elapse(Duration(seconds: 10));
      expect(list, [
        '0',
        '1',
        'p2',
        '3',
        /*4*/ 'p2',
        'p5',
        '6',
        'p2',
        /*8*/ 'p2',
        /*10*/ 'p2',
        'p5',
      ]);
    });
  });
}
