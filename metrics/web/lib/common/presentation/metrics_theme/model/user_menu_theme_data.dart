import 'package:flutter/material.dart';

/// A class that stores the theme data for the metrics user menu.
class UserMenuThemeData {
  /// A background color of the user menu.
  final Color backgroundColor;

  /// A divider color of the user menu.
  final Color dividerColor;

  /// The [TextStyle] for the text of the user menu.
  final TextStyle contentTextStyle;

  /// Creates a new instance of the [UserMenuThemeData].
  const UserMenuThemeData({
    this.backgroundColor,
    this.dividerColor,
    this.contentTextStyle,
  });
}
