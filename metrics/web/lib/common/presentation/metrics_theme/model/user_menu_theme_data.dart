import 'package:flutter/material.dart';

/// A class that stores the theme data for the metrics user menu.
class UserMenuThemeData {
  /// A background [Color] of the user menu.
  final Color backgroundColor;

  /// A divider [Color] of the user menu.
  final Color dividerColor;

  /// The [TextStyle] of the text in the user menu.
  final TextStyle contentTextStyle;

  /// Creates a new instance of the [UserMenuThemeData].
  const UserMenuThemeData({
    this.backgroundColor,
    this.dividerColor,
    this.contentTextStyle,
  });
}
