import 'package:flutter/material.dart';

/// A class that stores the theme data for the project metrics tile.
class ProjectMetricsTileThemeData {
  /// A background [Color] of the tile displaying project metrics.
  final Color backgroundColor;

  /// A [TextStyle] of the metrics tile text.
  final TextStyle textStyle;

  /// A [Color] of the border.
  final Color borderColor;

  /// Creates an instance of the [ProjectMetricsTileThemeData].
  ///
  /// The [borderColor] defaults to [Colors.grey].
  const ProjectMetricsTileThemeData({
    this.backgroundColor,
    this.textStyle,
    Color borderColor,
  }) : borderColor = borderColor ?? Colors.grey;
}
