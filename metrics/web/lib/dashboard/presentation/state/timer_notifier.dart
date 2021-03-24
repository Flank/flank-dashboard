// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';

/// The [ChangeNotifier] that holds the
class TimerNotifier extends ChangeNotifier {
  /// A [Timer] this notifier uses to perform periodic ticks.
  Timer _timer;

  /// Creates a new instance of the [TimerNotifier] with the given [Timer].
  ///
  /// Throws an [ArgumentError] if the given [Timer] is null.
  TimerNotifier(this._timer) {
    ArgumentError.checkNotNull(_timer, 'timer');
  }

  /// Starts the [Timer.periodic] with the given [duration].
  ///
  /// The [duration] must be a non-negative [Duration].
  ///
  /// Throws an [ArgumentError] if the given [duration] is null
  /// or [duration.isNegative].
  void start(Duration duration) {
    ArgumentError.checkNotNull(duration, 'duration');
    if (duration.isNegative) {
      throw ArgumentError('The given duration must not be negative.');
    }

    _timer?.cancel();

    _timer = Timer.periodic(duration, (timer) {});
  }
}
