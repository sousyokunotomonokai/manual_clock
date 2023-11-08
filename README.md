
# Manual Clock

This package is for testing current time and Timer related code.

The ManualClock class is a derived class of [Clock](https://pub.dev/documentation/clock/latest/clock/Clock-class.html).

With
[clock](https://pub.dev/packages/clock) and
[fake_async](https://pub.dev/packages/fake_async) libraries,
you can test current time related code by using clock.now().
But inside fake async callback, you can't use await.
Because of this restriction, Sometimes it is hard to test your code.
With this library, you can test current time and Timer related code using await.

## Restrictions

* Timers with 0 duration are not supported.
* If a target code contains a code like `await Future.delayed(...)`, it will stop there permanently.

## Getting started

pubspec.yaml

```yaml
dev_dependencies:
  manual_clock: ^latest_version
```

## Usage

```dart
test('a test case', () async {
  await withManualClock((clock) async {
    final obj = ClassDependOnNow(...);
    clock.elapse(Duration(...));

    // You can use await inside callback
    final result = await obj.getResult();
    expect(result, ...);

    // You can test Timers
    var fired = false;
    Timer(duration, () { fired = true; });
    clock.elapse(duration);
    expect(fired, true);

  },
  // optionally set initial time
  initialTime: DateTime(2000, 1, 1));
});
```
