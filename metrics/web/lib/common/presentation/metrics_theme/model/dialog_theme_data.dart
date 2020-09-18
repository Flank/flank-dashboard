import 'package:flutter/material.dart';

/// A class that stores the theme data for the dialogues.
class DialogThemeData {
  /// A primary [Color] for main elements of the dialog.
  final Color primaryColor;

  /// A secondary [Color] for elements of the dialog.
  final Color accentColor;

  /// A background [Color] of the dialog.
  final Color backgroundColor;

  /// A [Color] of the backdrop that darkens everything outside the dialog.
  final Color barrierColor;

  /// A [Color] of the close icon of the dialog.
  final Color closeIconColor;

  /// A [TextStyle] of the dialog title.
  final TextStyle titleTextStyle;

  /// A [TextStyle] of the dialog error message.
  final TextStyle errorTextStyle;

  const DialogThemeData({
    Color primaryColor,
    Color accentColor,
    Color backgroundColor,
    Color barrierColor,
    Color closeIconColor,
    this.errorTextStyle,
    this.titleTextStyle,
  })  : primaryColor = primaryColor ?? Colors.blue,
        accentColor = accentColor ?? Colors.red,
        backgroundColor = backgroundColor ?? Colors.white,
        barrierColor = barrierColor ?? Colors.black45,
        closeIconColor = closeIconColor ?? Colors.black;
}
