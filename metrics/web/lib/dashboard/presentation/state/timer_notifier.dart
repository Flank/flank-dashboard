// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that provides an ability to subscibe to fixed [Duration] 
/// periodic ticks.
class TimerNotifier extends ChangeNotifier {
  /// A [Timer] this notifier uses to perform periodic ticks.
  Timer _timer;

  /// Starts a [Timer.periodic] with the given [duration].
  ///
  /// Cancels the timer if it is active.
  ///
  /// The [duration] must be a non-negative [Duration].
  ///
  /// Throws an [ArgumentError] if the given [duration] is `null`
  /// or the [duration.isNegative].
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
