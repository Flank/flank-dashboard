// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
