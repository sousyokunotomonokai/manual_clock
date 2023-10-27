import 'package:test/test.dart';
import 'package:clock/clock.dart';
import 'package:manual_clock/manual_clock.dart';

class ClassDependOnNow {
  final _startTime = clock.now();

  Duration get elapsed => clock.now().difference(_startTime);

  Future<Duration> someComplicatedTask() async {
    await Future.delayed(const Duration(seconds: 1));
    return elapsed;
  }
}

void main() {
  test('a test case', () async {
    await withManualClock((clock) async {
      final stopwatch = ClassDependOnNow();
      expect(stopwatch.elapsed, Duration.zero);

      final duration = Duration(minutes: 3);
      clock.elapse(duration);
      expect(stopwatch.elapsed, duration);

      final result = await stopwatch.someComplicatedTask();
      expect(result, duration);
    });
  });
}
