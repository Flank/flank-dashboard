import 'package:flutter/material.dart';

/// A class that stores style data for build result bars.
class MetricsColoredBarStyle {
  /// A [Color] of the bar.
  final Color color;

  /// A hover [Color] of the bar.
  final Color hoverColor;

  /// Creates a new instance of the [MetricsColoredBarStyle].
  ///
  /// The [color] defaults to the [Colors.green].
  /// The [hoverColor] defaults to the [Colors.lightGreen].
  const MetricsColoredBarStyle({
    this.color = Colors.green,
    this.hoverColor = Colors.lightGreen,
  });
}
