// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the tooltip popup.
@immutable
class TooltipPopupThemeData {
  /// A [TextStyle] of the tooltip popup's text.
  final TextStyle textStyle;

  /// A background [Color] of the tooltip popup.
  final Color backgroundColor;

  /// A shadow [Color] of the tooltip popup.
  final Color shadowColor;

  /// Creates a new instance of the [TooltipPopupThemeData].
  ///
  /// If the given [backgroundColor] or [shadowColor] is null,
  /// the [Colors.grey] is used.
  const TooltipPopupThemeData({
    Color backgroundColor,
    Color shadowColor,
    this.textStyle,
  })  : backgroundColor = backgroundColor ?? Colors.grey,
        shadowColor = shadowColor ?? Colors.grey;
}
