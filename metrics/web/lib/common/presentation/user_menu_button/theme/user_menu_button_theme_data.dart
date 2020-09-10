import 'package:flutter/material.dart';

/// A class that stores the theme data for the user menu button.
class UserMenuButtonThemeData {
  /// A [Color] to use when the [MetricsUserMenu] is open.
  final Color activeColor;

  /// A [Color] to use when the [MetricsUserMenu] is closed.
  final Color inactiveColor;

  /// Creates the [UserMenuButtonThemeData].
  const UserMenuButtonThemeData({this.activeColor, this.inactiveColor});
}
