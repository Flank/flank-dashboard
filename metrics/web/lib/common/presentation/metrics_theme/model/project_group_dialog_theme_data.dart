import 'package:flutter/material.dart';

/// A class that stores the theme data for the project group dialogues.
class ProjectGroupDialogThemeData {
  /// A primary [Color] for main elements of the project group dialog.
  final Color primaryColor;

  /// A secondary [Color] for elements of the project group dialog.
  final Color accentColor;

  /// A background [Color] of the project group dialog.
  final Color backgroundColor;

  /// A [TextStyle] for the [TextField]s of the project group dialog.
  final TextStyle textFieldTextStyle;

  /// A [TextStyle] of the dialog title.
  final TextStyle titleTextStyle;

  /// A border [Color] of the project group dialog content.
  final Color contentBorderColor;

  /// A [TextStyle] of the content text for the project group dialog.
  final TextStyle contentTextStyle;

  /// A [TextStyle] of the content secondary text for the project group dialog.
  final TextStyle contentSecondaryTextStyle;

  /// A [TextStyle] of the actions text for the project group dialog.
  final TextStyle actionsTextStyle;

  /// Creates a new instance of the [ProjectGroupDialogThemeData].
  const ProjectGroupDialogThemeData({
    this.primaryColor = Colors.blue,
    this.accentColor = Colors.red,
    this.backgroundColor = Colors.white,
    this.contentBorderColor = Colors.grey,
    this.titleTextStyle,
    this.textFieldTextStyle,
    this.contentTextStyle,
    this.contentSecondaryTextStyle,
    this.actionsTextStyle,
  });
}
