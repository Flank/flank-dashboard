// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Theme data of the metrics widget.
class MetricsWidgetThemeData {
  /// A main [Color] of the widget.
  ///
  /// It is used to paint the main elements of the widget
  /// like strokes of graphs, etc.
  final Color primaryColor;

  /// A secondary [Color] that is used to paint the secondary elements
  /// of the widget.
  final Color accentColor;

  /// A background [Color] of the metrics widget.
  final Color backgroundColor;

  /// A [TextStyle] applied to all text in the metrics widget.
  final TextStyle textStyle;

  /// Creates the [MetricsWidgetThemeData].
  ///
  /// If the [primaryColor] is `null`, the [Colors.blue] is used.
  /// If the [accentColor] is `null`, the [Colors.grey] is used.
  const MetricsWidgetThemeData({
    Color primaryColor,
    Color accentColor,
    this.backgroundColor,
    this.textStyle,
  })  : primaryColor = primaryColor ?? Colors.blue,
        accentColor = accentColor ?? Colors.grey;
}
