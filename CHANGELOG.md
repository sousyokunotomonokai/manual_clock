# Change Log

## [1.3.4](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.3.4) (2024/12/17)

- add the advertisement of our products at the bottom of README

## [1.3.3](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.3.3) (2024/07/31)

- Fixed an issue that it will throw an exception when a new timer is created inside timer callback.
- Fixed an issue that the current time inside timer callback will not pass until clock.elapse(...) finish.
- Add pumpManualEventQueue() function (experimental)

## [1.3.2](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.3.2) (2024/07/30)

- Add a test case for withManualClock function.

## [1.3.1](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.3.1) (2024/07/30)

- Fixed that ManualClock will elapse time more than specified duration.
- Fixed that runZoned and withClock calling order is wrong.
- Add a test case for withManualClock function.

## [1.3.0](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.3.0) (2024/04/24)

- A one-shot timer of 0 duration is supported now.

## [1.2.0](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.2.0) (2023/11/11)

- Add waitRealLifeTime(duration)

## [1.1.0](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.1.0) (2023/11/09)

- Add support for Timer

## [1.0.0](https://github.com/sousyokunotomonokai/manual_clock/tree/v1.0.0) (2023/10/27)

- Initial version.
