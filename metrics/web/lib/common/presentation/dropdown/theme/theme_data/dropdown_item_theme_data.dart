import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_item.dart';

/// Stores the theme data for the metrics styled dropdown item.
class DropdownItemThemeData {
  /// A background [Color] of the dropdown item.
  final Color backgroundColor;

  /// A hover [Color] of the dropdown item.
  final Color hoverColor;

  /// A [TextStyle] of the dropdown item text.
  final TextStyle textStyle;

  /// A [TextStyle] of the dropdown item text when the [DropdownItem] is hovered.
  final TextStyle hoverTextStyle;

  /// Creates the [DropdownItemThemeData].
  const DropdownItemThemeData({
    this.backgroundColor,
    this.hoverColor,
    this.textStyle,
    this.hoverTextStyle,
  });
}
