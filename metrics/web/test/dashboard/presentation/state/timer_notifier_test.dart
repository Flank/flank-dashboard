// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:fake_async/fake_async.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:test/test.dart';

void main() {
  group("TimerNotifier", () {
    final notifier = TimerNotifier();

    tearDown(() {
      notifier.stop();
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
      () async {

          const expectedTickCount = 3;
          const duration = Duration(milliseconds: 10);

          int tickCount = 0;

          notifier.addListener(() {
            ++tickCount;
          });

          notifier.start(duration * expectedTickCount);

          await Future.delayed(duration * expectedTickCount);

          expect(tickCount, equals(expectedTickCount));
        
      },
    );
  });
}
