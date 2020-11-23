import 'package:flutter/material.dart';

/// A class that stores the theme data for the tooltip popup.
class TooltipPopupThemeData {
  /// A [TextStyle] of the tooltip popup's text.
  final TextStyle textStyle;

  /// A [Color] of the tooltip popup.
  final Color color;

  /// Creates a new instance of the [TooltipPopupThemeData].
  ///
  /// If the given [color] is null, the [Colors.grey] is used.
  const TooltipPopupThemeData({
    this.textStyle,
    Color color,
  }) : color = color ?? Colors.grey;
}
