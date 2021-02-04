// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the text fields within application.
class TextFieldThemeData {
  /// A [Color] to fill the text field when the field is focused.
  final Color focusColor;

  /// A [Color] of the text field border when the field is hovered.
  final Color hoverBorderColor;

  /// A [Color] of a prefix icon of the text field.
  final Color prefixIconColor;

  /// A [Color] of a focused prefix icon of the text field.
  final Color focusedPrefixIconColor;

  /// A [TextStyle] to use for the text being edited.
  final TextStyle textStyle;

  /// Creates a new instance of the [TextFieldThemeData].
  const TextFieldThemeData({
    this.focusColor = Colors.blue,
    this.hoverBorderColor = Colors.grey,
    this.prefixIconColor = Colors.red,
    this.focusedPrefixIconColor = Colors.yellow,
    this.textStyle,
  });
}
