import 'package:flutter/material.dart';

/// A class that stores the theme data for the text fields within application.
class TextFieldThemeData {
  /// A [Color] to fill the text field with when field is focused.
  final Color focusColor;

  /// A [Color] of the text field border when field is hovered.
  final Color hoverBorderColor;

  /// A [TextStyle] to use for the text being edited.
  final TextStyle textStyle;

  /// Creates a new instance of the [TextFieldThemeData].
  const TextFieldThemeData({
    this.focusColor = Colors.black,
    this.hoverBorderColor = Colors.grey,
    this.textStyle,
  });
}
