import 'package:flutter/material.dart';

/// Stores the theme data for the metrics styled dropdown item.
class DropdownItemThemeData {
  /// A background [Color] of the dropdown item.
  final Color backgroundColor;

  /// A hover [Color] of the dropdown item.
  final Color hoverColor;

  /// A [TextStyle] of the dropdown item text.
  final TextStyle textStyle;

  /// Creates the [DropdownItemThemeData].
  const DropdownItemThemeData({
    this.backgroundColor,
    this.hoverColor,
    this.textStyle,
  });
}
