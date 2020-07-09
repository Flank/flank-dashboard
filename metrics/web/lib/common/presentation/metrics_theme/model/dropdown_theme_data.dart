import 'package:flutter/material.dart';

/// The class that stores the theme data for the dropdown.
class DropdownThemeData {
  /// The [TextStyle] of the text of this dropdown.
  final TextStyle textStyle;

  /// The background [Color] of this dropdown.
  final Color backgroundColor;

  /// The hover highlight [Color] of this dropdown.
  final Color hoverColor;

  /// Creates the [DropdownThemeData].
  const DropdownThemeData({
    this.backgroundColor = Colors.transparent,
    this.hoverColor = const Color(0xFF1d1d20),
    this.textStyle = const TextStyle(fontSize: 16.0),
  });
}
