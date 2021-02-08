// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Stores the theme data for the metrics styled dropdown.
class DropdownThemeData {
  /// A default [Color] of the dropdown border.
  static const Color _defaultBorderColor = Colors.transparent;

  /// The background [Color] that usually applied to a dropdown button or
  /// a menu backgrounds.
  final Color backgroundColor;

  /// The text style that usually applied to a dropdown button or
  /// menu texts.
  final TextStyle textStyle;

  /// The border [Color] of the dropdown button when open.
  final Color openedButtonBorderColor;

  /// The background [Color] of the dropdown button when open.
  final Color openedButtonBackgroundColor;

  /// The border [Color] of the dropdown button when closed.
  final Color closedButtonBorderColor;

  /// The background [Color] of the dropdown button when closed.
  final Color closedButtonBackgroundColor;

  /// The border [Color] of the dropdown button when hovered.
  final Color hoverBorderColor;

  /// The background [Color] of the dropdown button when hovered.
  final Color hoverBackgroundColor;

  /// The [Color] of the dropdown body's shadow.
  final Color shadowColor;

  /// The [Color] of the dropdown icon.
  final Color iconColor;

  /// Creates the [DropdownThemeData].
  ///
  /// If [openedButtonBorderColor] or [closedButtonBorderColor]
  /// or [hoverBorderColor] or [shadowColor] is null,
  /// the [Colors.transparent] used.
  const DropdownThemeData({
    this.backgroundColor,
    this.textStyle,
    Color openedButtonBorderColor,
    this.openedButtonBackgroundColor,
    Color closedButtonBorderColor,
    this.closedButtonBackgroundColor,
    Color hoverBorderColor,
    this.hoverBackgroundColor,
    Color shadowColor,
    this.iconColor,
  })  : hoverBorderColor = hoverBorderColor ?? _defaultBorderColor,
        openedButtonBorderColor =
            openedButtonBorderColor ?? _defaultBorderColor,
        closedButtonBorderColor =
            closedButtonBorderColor ?? _defaultBorderColor,
        shadowColor = shadowColor ?? _defaultBorderColor;
}
