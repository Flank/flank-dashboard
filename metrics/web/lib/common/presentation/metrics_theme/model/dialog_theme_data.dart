// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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

  /// Creates a new instance of the [DialogThemeData].
  ///
  /// If the [primaryColor] is `null`, the [Colors.blue] is used.
  /// If the [accentColor] is `null`, the [Colors.red] is used.
  /// If the [backgroundColor] is `null`, the [Colors.white] is used.
  /// If the [barrierColor] is `null`, the [Colors.black45] is used.
  /// If the [closeIconColor] is `null`, the [Colors.black] is used.
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
