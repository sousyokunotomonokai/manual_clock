import 'package:test/test.dart';

import 'package:manual_clock/manual_clock.dart';

void main() {
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
