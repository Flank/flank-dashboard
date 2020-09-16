import 'package:flutter/material.dart';

/// A class that stores the theme data for the user menu button.
class UserMenuButtonThemeData {
  /// A [Color] to use when the [MetricsUserMenu] is opened.
  final Color activeColor;

  /// A [Color] to use when the [MetricsUserMenu] is closed.
  final Color inactiveColor;

  /// Creates a new instance of the [UserMenuButtonThemeData].
  ///
  /// The [activeColor] default value is [Colors.blue].
  /// The [inactiveColor] default value is [Colors.grey].
  const UserMenuButtonThemeData({
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  });
}
