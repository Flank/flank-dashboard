import 'package:flutter/material.dart';

/// A class that stores style data for circle graph indicators.
class MetricsCircleGraphIndicatorStyle {
  /// An inner circle [Color].
  final Color innerColor;

  /// An outer circle [Color].
  final Color outerColor;

  /// Creates a new instance of the [MetricsCircleGraphIndicatorStyle].
  const MetricsCircleGraphIndicatorStyle({
    this.innerColor,
    this.outerColor,
  });
}
