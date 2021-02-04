// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Stores the theme data for the metrics styled sparkline.
class SparklineThemeData {
  /// A [Color] of the graph stroke.
  final Color strokeColor;

  /// A fill [Color] of the graph.
  final Color fillColor;

  /// A [TextStyle] of the sparkline texts.
  final TextStyle textStyle;

  /// Creates a [SparklineThemeData].
  const SparklineThemeData({
    this.strokeColor,
    this.fillColor,
    this.textStyle,
  });
}
