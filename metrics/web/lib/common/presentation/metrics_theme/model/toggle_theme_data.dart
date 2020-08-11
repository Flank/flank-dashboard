import 'package:flutter/material.dart';

/// A class that stores the theme data for the metrics toggle.
class ToggleThemeData {
  /// A [Color] to use when the toggle is off.
  final Color inactiveColor;

  /// A [Color] to use when the toggle is off and hovered.
  final Color inactiveHoverColor;

  /// A [Color] to use when the toggle is on.
  final Color activeColor;

  /// A [Color] to use when the toggle is on and hovered.
  final Color activeHoverColor;

  /// Creates a new instance of the [ToggleThemeData].
  const ToggleThemeData({
    this.inactiveColor,
    this.inactiveHoverColor,
    this.activeColor,
    this.activeHoverColor,
  });
}
