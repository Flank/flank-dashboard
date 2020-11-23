import 'package:flutter/material.dart';

/// A class that stores the theme data for the tooltip popup.
class TooltipPopupThemeData {
  /// A [TextStyle] of the tooltip popup's text.
  final TextStyle textStyle;

  /// A background [Color] of the tooltip popup.
  final Color backgroundColor;

  /// Creates a new instance of the [TooltipPopupThemeData].
  ///
  /// If the given [backgroundColor] is null, the [Colors.grey] is used.
  const TooltipPopupThemeData({
    this.textStyle,
    Color backgroundColor,
  }) : backgroundColor = backgroundColor ?? Colors.grey;
}
