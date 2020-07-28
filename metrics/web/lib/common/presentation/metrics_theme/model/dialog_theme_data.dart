import 'package:flutter/material.dart';

/// A class that stores the theme data for the dialogues.
class DialogThemeData {
  /// A primary [Color] for main elements of the dialog.
  final Color primaryColor;

  /// A secondary [Color] for elements of the dialog.
  final Color accentColor;

  /// A background [Color] of the dialog.
  final Color backgroundColor;

  /// A [Color] of the close icon of the dialog.
  final Color closeIconColor;

  /// A [TextStyle] of the dialog title.
  final TextStyle titleTextStyle;

  const DialogThemeData({
    Color primaryColor,
    Color accentColor,
    Color backgroundColor,
    Color closeIconColor,
    this.titleTextStyle,
  })  : primaryColor = primaryColor ?? Colors.blue,
        accentColor = accentColor ?? Colors.red,
        backgroundColor = backgroundColor ?? Colors.white,
        closeIconColor = closeIconColor ?? Colors.black;
}
