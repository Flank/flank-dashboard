import 'package:flutter/material.dart';

/// A class that stores the theme data for the login page.
class LoginThemeData {
  /// A primary [Color] for main elements of the project group dialog.
  final Color primaryColor;

  /// A [TextStyle] of the login page title.
  final TextStyle titleTextStyle;

  /// A fill [Color] of hovered text fields on the login page.
  final Color textFieldHoverColor;

  /// A border [Color] of hovered text fields on the login page.
  final Color textFieldHoverBorderColor;

  /// A [TextStyle] for the login button on the login page.
  final TextStyle loginButtonTextStyle;

  /// A [TextStyle] for login options on the login page.
  final TextStyle loginOptionTextStyle;

  /// A [Color] of login options on the login page.
  final Color loginOptionColor;

  /// Creates a new instance of the [LoginThemeData].
  const LoginThemeData({
    this.primaryColor = Colors.blue,
    this.textFieldHoverColor = Colors.grey,
    this.textFieldHoverBorderColor = Colors.black,
    this.loginOptionColor = Colors.green,
    this.titleTextStyle,
    this.loginButtonTextStyle,
    this.loginOptionTextStyle,
  });
}
