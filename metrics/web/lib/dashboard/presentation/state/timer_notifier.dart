// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';

/// The [ChangeNotifier] that holds the
class TimerNotifier extends ChangeNotifier {
  /// A [Timer] this notifier uses to perform periodic ticks.
  Timer _timer;

  /// Creates a new instance of the [TimerNotifier].
  TimerNotifier();

  /// Starts a [Timer.periodic] with the given [duration].
  ///
  /// Cancels the timer if it is active.
  ///
  /// The [duration] must be a non-negative [Duration].
  ///
  /// Throws an [ArgumentError] if the given [duration] is `null`
  /// or [duration.isNegative].
  void start(Duration duration) {
    ArgumentError.checkNotNull(duration, 'duration');
    if (duration.isNegative) {
      throw ArgumentError('The given duration must not be negative.');
    }

    stop();

    _timer = Timer.periodic(duration, (_) => _tick());
  }

  /// Stops the timer.
  void stop() {
    _timer?.cancel();
  }

  /// Notifies the listeners about the timer's tick.
  void _tick() {
    notifyListeners();
  }

  @override
  void dispose() {
    stop();

    super.dispose();
  }
}
