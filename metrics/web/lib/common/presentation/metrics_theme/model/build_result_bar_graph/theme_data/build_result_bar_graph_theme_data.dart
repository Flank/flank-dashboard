// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the build result bar graph.
class BuildResultBarGraphThemeData {
  /// A [TextStyle] of the build result bar graph.
  final TextStyle textStyle;

  /// Creates a new instance of the [BuildResultBarGraphThemeData].
  ///
  /// If the [textStyle] is null, an instance of the `TextStyle` used.
  const BuildResultBarGraphThemeData({
    TextStyle textStyle,
  }) : textStyle = textStyle ?? const TextStyle();
}
