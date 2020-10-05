import 'package:flutter/material.dart';

/// A class that stores style data for build result bars.
class MetricsColoredBarStyle {
  /// A [Color] of the bar.
  final Color color;

  /// A background [Color] of the bar.
  final Color backgroundColor;

  /// Creates a new instance of the [MetricsColoredBarStyle].
  ///
  /// The [color] defaults to the [Colors.green].
  /// The [backgroundColor] defaults to the [Colors.lightGreen].
  const MetricsColoredBarStyle({
    this.color = Colors.green,
    this.backgroundColor = Colors.lightGreen,
  });
}