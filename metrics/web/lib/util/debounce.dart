import 'dart:async';
import 'package:flutter/foundation.dart';

/// Represents a class that gives the ability to execute action after a certain
/// period of time.
class Debounce {
  /// Defines the duration, that action waits before executing.
  final Duration duration;
  Timer _timer;

  /// Creates the [Debounce] with the given [duration].
  Debounce({
    this.duration,
  });

  void call(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(duration, action);
  }
}
