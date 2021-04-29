// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that provides an ability to subscribe to fixed [Duration]
/// periodic ticks.
class TimerNotifier extends ChangeNotifier {
  /// A [Timer] this notifier uses to perform periodic ticks.
  Timer _timer;

  /// Starts ticking with the given [duration] periodicity.
  ///
  /// Creates a new [Timer.periodic] with the given [duration] that notifies the
  /// listeners of this notifier on each [Timer]’s tick. Cancels the previously
  /// created [Timer.periodic] if any.
  ///
  /// The [duration] must be a non-negative [Duration].
  ///
  /// Throws an [ArgumentError] if the given [duration] is `null`
  /// or the [Duration.isNegative].
  void start(Duration duration) {
    ArgumentError.checkNotNull(duration, 'duration');
    if (duration.isNegative) {
      throw ArgumentError('The given duration must not be negative.');
    }

    stop();

    _timer = Timer.periodic(duration, (_) => _tick());
  }

  /// Stops this notifier's ticks.
  void stop() {
    _timer?.cancel();
  }

  /// Notifies the listeners about the [_timer]'s tick.
  void _tick() {
    notifyListeners();
  }

  @override
  void dispose() {
    stop();

    super.dispose();
  }
}
