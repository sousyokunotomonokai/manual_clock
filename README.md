
# Manual Clock

This package is for testing current time related code.
ManualClock class is a derived class of [Clock](https://pub.dev/documentation/clock/latest/clock/Clock-class.html).

With
[clock](https://pub.dev/packages/clock) and
[fake_async](https://pub.dev/documentation/fake_async/latest/fake_async/fake_async-library.html) libraries,
you can test current time (clock.now()) related code.
But inside fake async callback, you can't use await.
Because of this restriction, Sometimes it is hard to test your code.
With this library, you can test current time related code using await.

## Getting started

pubspec.yaml

```yaml
dev_dependencies:
  manual_clock: ^1.0.0
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
  },
  // optionally set initial time
  initialTime: DateTime(2000, 1, 1));
});
```
