// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:fake_async/fake_async.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("TimerNotifier", () {
    TimerNotifier notifier;
    const duration = Duration(milliseconds: 10);

    setUp(() {
      notifier = TimerNotifier();
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
      ".start() starts a timer with the given duration",
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
          int tickCount = 0;
          notifier.addListener(() => ++tickCount);

          notifier.start(duration);
          notifier.stop();

          async.elapse(duration);

          expect(tickCount, isZero);
        });
      },
    );

    test(
      ".dispose() stops the started timers",
      () {
        fakeAsync((async) {
          int tickCount = 0;
          notifier.addListener(() => ++tickCount);

          notifier.start(duration);
          notifier.dispose();

          async.elapse(duration);

          expect(tickCount, isZero);
        });
      },
    );

    test(
      ".dispose() disposes the notifier",
      () {
        notifier.dispose();

        expect(() => notifier.addListener(() {}), throwsAssertionError);
      },
    );
  });
}
