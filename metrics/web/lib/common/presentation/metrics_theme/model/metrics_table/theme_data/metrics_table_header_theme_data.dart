import 'package:flutter/material.dart';

/// A class that stores the theme data for the metrics table header.
class MetricsTableHeaderThemeData {
  /// A [TextStyle] of the metrics table header text.
  final TextStyle textStyle;

  /// Creates an instance of the [MetricsTableHeaderThemeData].
  ///
  /// If the [textStyle] is null, an instance of the `TextStyle` used.
  const MetricsTableHeaderThemeData({
    TextStyle textStyle,
  }) : textStyle = textStyle ?? const TextStyle();
}
