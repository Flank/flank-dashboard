import 'package:flutter/material.dart';

/// A class that stores style data for circle graph indicators.
class GraphIndicatorStyle {
  /// An inner circle [Color].
  final Color innerColor;

  /// An outer circle [Color].
  final Color outerColor;

  /// Creates a new instance of the [GraphIndicatorStyle].
  const GraphIndicatorStyle({
    this.innerColor,
    this.outerColor,
  });
}
