import 'package:flutter/material.dart';

/// Theme data of the metrics widget.
class MetricsWidgetThemeData {
  static const Color _defaultPrimaryColor = Colors.blue;
  static const Color _defaultAccentColor = Colors.grey;

  /// A main [Color] of the widget.
  /// Used to paint the main elements of the widget,
  /// like strokes of the graphs, etc.
  final Color primaryColor;

  /// A secondary [Color], used to paint the secondary elements of the widget.
  final Color accentColor;

  /// A background [Color] of the metrics widget.
  final Color backgroundColor;

  /// A [TextStyle] applied to all text in metrics widget.
  final TextStyle textStyle;

  /// Creates the [MetricsWidgetThemeData].
  ///
  /// If the [primaryColor] is not specified or the null is passed,
  /// the [_defaultPrimaryColor] will be used.
  ///
  /// If [accentColor] is not specified or the null is passed,
  /// the [_defaultAccentColor] will be used.
  const MetricsWidgetThemeData({
    Color primaryColor,
    Color accentColor,
    this.backgroundColor,
    this.textStyle,
  })  : primaryColor = primaryColor ?? _defaultPrimaryColor,
        accentColor = accentColor ?? _defaultAccentColor;
}
