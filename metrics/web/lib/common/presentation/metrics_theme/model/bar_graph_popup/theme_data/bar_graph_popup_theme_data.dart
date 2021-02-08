// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the bar graph popup.
class BarGraphPopupThemeData {
  /// A [TextStyle] of the bar graph popup's title.
  final TextStyle titleTextStyle;

  /// A [TextStyle] of the bar graph popup's subtitle.
  final TextStyle subtitleTextStyle;

  /// A [Color] of the bar graph popup.
  final Color color;

  /// A shadow [Color] of the bar graph popup.
  final Color shadowColor;

  /// Creates a new instance of the [BarGraphPopupThemeData].
  ///
  /// If the given [color] is null, the [Colors.grey] is used.
  /// If the given [shadowColor] is null, the [Colors.black26] is used.
  const BarGraphPopupThemeData({
    this.titleTextStyle,
    this.subtitleTextStyle,
    Color color,
    Color shadowColor,
  })  : color = color ?? Colors.grey,
        shadowColor = shadowColor ?? Colors.black26;
}
