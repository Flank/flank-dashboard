import 'package:flutter/material.dart';

/// A class that stores style data for a circle percentage.
@immutable
class CirclePercentageStyle {
  /// A [Color] to apply to a part of a graph that represents a value.
  final Color valueColor;

  /// A [Color] to apply to a graph's circle.
  final Color strokeColor;

  /// A [Color] to apply to fill the graph.
  final Color backgroundColor;

  /// A [TextStyle] to apply to a percent text.
  final TextStyle valueStyle;

  /// Creates an instance of the [CirclePercentageStyle].
  const CirclePercentageStyle({
    this.valueColor,
    this.strokeColor,
    this.backgroundColor,
    this.valueStyle,
  });
}
