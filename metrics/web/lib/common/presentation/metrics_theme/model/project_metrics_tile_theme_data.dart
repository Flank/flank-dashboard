import 'package:flutter/material.dart';

/// A class that stores the theme data for the project metrics tile.
class ProjectMetricsTileThemeData {
  /// A background [Color] of the tile displaying project metrics.
  final Color backgroundColor;

  /// A [Color] of the border.
  final Color borderColor;

  /// A [TextStyle] of the metrics tile text.
  final TextStyle textStyle;

  /// Creates an instance of the [ProjectMetricsTileThemeData].
  ///
  /// The [borderColor] defaults to [Colors.grey].
  const ProjectMetricsTileThemeData({
    Color borderColor,
    this.textStyle,
    this.backgroundColor,
  }) : borderColor = borderColor ?? Colors.grey;
}
