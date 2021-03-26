// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:fake_async/fake_async.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("TimerNotifier", () {
    const duration = Duration(milliseconds: 10);

    TimerNotifier notifier;

    setUp(() {
      notifier = TimerNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test(
      ".start() throws an ArgumentError if the given duration is null",
      () {
        expect(() => notifier.start(null), throwsArgumentError);
      },
    );

    test(
      ".start() throws an ArgumentError if the given duration is negative",
      () {
        const negativeDuration = Duration(seconds: -1);

        expect(() => notifier.start(negativeDuration), throwsArgumentError);
      },
    );

    test(
      ".start() creates a periodic timer with the given duration",
      () {
        fakeAsync((async) {
          notifier.start(duration);

          final timers = async.pendingTimers;

          final timer = timers.singleWhere(
            (timer) => timer.isPeriodic && timer.duration == duration,
            orElse: () => null,
          );

          expect(timer, isNotNull);
        });
      },
    );

    test(
      ".start() stops the previously created timer",
      () {
        fakeAsync((async) {
          notifier.start(duration);
          notifier.start(duration);

          expect(async.periodicTimerCount, equals(1));
        });
      },
    );

    test(
      ".start() starts ticking with the given duration",
      () {
        fakeAsync((async) {
          const expectedTickCount = 3;
          int tickCount = 0;

          notifier.addListener(() => ++tickCount);

          notifier.start(duration);

          async.elapse(duration * expectedTickCount);

          expect(tickCount, equals(expectedTickCount));
        });
      },
    );

    test(
      ".stop() stops the started timer",
      () {
        fakeAsync((async) {
          notifier.start(duration);

          notifier.stop();

          expect(async.periodicTimerCount, isZero);
        });
      },
    );

    test(
      ".dispose() stops the started timers",
      () {
        fakeAsync((async) {
          final notifier = TimerNotifier();

          notifier.start(duration);

          notifier.dispose();

          expect(async.periodicTimerCount, isZero);
        });
      },
    );

    test(
      ".dispose() disposes the notifier",
      () {
        final notifier = TimerNotifier();

        notifier.dispose();

        expect(() => notifier.notifyListeners(), throwsAssertionError);
      },
    );
  });
}
