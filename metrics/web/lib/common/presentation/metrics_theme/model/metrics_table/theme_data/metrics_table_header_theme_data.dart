import 'package:flutter/material.dart';

/// A class that stores the theme data for the metrics table header.
class MetricsTableHeaderThemeData {
  /// A [TextStyle] of the metrics table header text.
  final TextStyle textStyle;

  /// Creates an instance of the [MetricsTableHeaderThemeData].
  ///
  /// The [textStyle] defaults to an empty `TextStyle`.
  const MetricsTableHeaderThemeData({
    TextStyle textStyle,
  }) : textStyle = textStyle ?? const TextStyle();
}
