import 'package:flutter/material.dart';

/// Theme data of the metrics widget.
class MetricsWidgetThemeData {
  static const Color _defaultPrimaryColor = Colors.blue;
  static const Color _defaultAccentColor = Colors.grey;

  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final TextStyle textStyle;

  /// Creates the [MetricsWidgetThemeData].
  ///
  /// [primaryColor] is the main color of the widget.
  /// Used to paint the main elements of the widget, like strokes of the graphs, etc.
  /// If the parameter is not specified or the null is passed,
  /// the [_defaultPrimaryColor] will be used.
  ///
  /// [accentColor] or the secondary color,
  /// used to paint the secondary elements of the widget.
  /// If nothing is specified, or the null is passed,
  /// the [_defaultAccentColor] will be used.
  ///
  /// [backgroundColor] is the color of the background of the metrics widget.
  ///
  /// [textStyle] is the [TextStyle] applied to all text in metrics widget.
  const MetricsWidgetThemeData({
    Color primaryColor,
    Color accentColor,
    this.backgroundColor,
    this.textStyle,
  })  : primaryColor = primaryColor ?? _defaultPrimaryColor,
        accentColor = accentColor ?? _defaultAccentColor;
}
