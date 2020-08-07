import 'package:flutter/material.dart';

/// A class that stores the theme data for the metrics toggle.
class MetricsToggleThemeData {
  /// A color to use when the toggle is off.
  final Color inactiveColor;

  /// A color to use when the toggle is off and hovered.
  final Color inactiveHoverColor;

  /// A color to use when the toggle is on.
  final Color activeColor;

  /// A color to use when the toggle is on and hovered.
  final Color activeHoverColor;

  /// Creates a new instance of the [MetricsToggleThemeData].
  const MetricsToggleThemeData({
    this.inactiveColor = Colors.grey,
    this.inactiveHoverColor = Colors.black87,
    this.activeColor = Colors.green,
    this.activeHoverColor = Colors.lightGreen,
  });
}
