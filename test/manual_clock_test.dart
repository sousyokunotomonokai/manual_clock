import 'package:test/test.dart';
import 'package:manual_clock/manual_clock.dart';

void main() {
  final initialTime = DateTime(2000, 1, 1);

  test('ManualClock with initialTime', () {
    final clock = ManualClock(initialTime: initialTime);
    expect(clock.now(), initialTime);
  });

  test('ManualClock will not tick automatically', () async {
    final clock = ManualClock(initialTime: initialTime);
    await Future.delayed(const Duration(seconds: 1));
    expect(clock.now(), initialTime);
  });

  test('ManualClock ticks manually', () async {
    final clock = ManualClock(initialTime: initialTime);
    var totalDuration = Duration.zero;
    var duration = Duration(minutes: 1);

    for (var i = 0; i < 3; ++i) {
      clock.elapse(duration);
      totalDuration += duration;
      expect(clock.elapsed, totalDuration);
      expect(clock.now(), initialTime.add(totalDuration));
    }
  });
}
