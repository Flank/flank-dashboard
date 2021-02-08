// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the project metrics tile.
class ProjectMetricsTileThemeData {
  /// A background [Color] of the tile displaying project metrics.
  final Color backgroundColor;

  /// A background [Color] when the tile is hovered.
  final Color hoverBackgroundColor;

  /// A [TextStyle] of the metrics tile text.
  final TextStyle textStyle;

  /// A [Color] of the border.
  final Color borderColor;

  /// A [Color] of the border when the tile is hovered.
  final Color hoverBorderColor;

  /// Creates an instance of the [ProjectMetricsTileThemeData].
  ///
  /// If the given [borderColor] or [hoverBorderColor] is null,
  /// the [Colors.grey] used.
  const ProjectMetricsTileThemeData({
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.textStyle,
    Color borderColor,
    Color hoverBorderColor,
  })  : borderColor = borderColor ?? Colors.grey,
        hoverBorderColor = hoverBorderColor ?? Colors.grey;
}
