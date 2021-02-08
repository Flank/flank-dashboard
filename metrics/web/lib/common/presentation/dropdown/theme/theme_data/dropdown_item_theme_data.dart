// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Stores the theme data for the metrics styled dropdown item.
class DropdownItemThemeData {
  /// A background [Color] of the dropdown item.
  final Color backgroundColor;

  /// A hover [Color] of the dropdown item.
  final Color hoverColor;

  /// A [TextStyle] of the dropdown item text.
  final TextStyle textStyle;

  /// A [TextStyle] of the dropdown item text when this item is hovered.
  final TextStyle hoverTextStyle;

  /// Creates the [DropdownItemThemeData].
  const DropdownItemThemeData({
    this.backgroundColor,
    this.hoverColor,
    this.textStyle,
    this.hoverTextStyle,
  });
}
