import 'package:flutter/material.dart';

/// A class that stores the theme data for the project group dialogues.
class ProjectGroupDialogThemeData {
  /// A primary [Color] for main elements of the project group dialog.
  final Color primaryColor;

  /// A secondary [Color] for elements of the project group dialog.
  final Color accentColor;

  /// A background [Color] of the project group dialog.
  final Color backgroundColor;

  /// A [Color] of the close icon of the project group dialog.
  final Color closeIconColor;

  /// A [TextStyle] of the dialog title.
  final TextStyle titleTextStyle;

  /// A [TextStyle] for the [TextField]s of the project group dialog.
  final TextStyle groupNameTextStyle;

  /// A [TextStyle] for the search for project text field
  /// of the project group dialog.
  final TextStyle searchForProjectTextStyle;

  /// A border [Color] of the project group dialog content.
  final Color contentBorderColor;

  /// A [TextStyle] of the unchecked project within the project group dialog.
  final TextStyle uncheckedProjectTextStyle;

  /// A [TextStyle] of the checked project within the project group dialog.
  final TextStyle checkedProjectTextStyle;

  /// A [TextStyle] of the counter text of selected projects within
  /// the project group dialog.
  final TextStyle counterTextStyle;

  /// A [TextStyle] of the actions text for the project group dialog.
  final TextStyle actionsTextStyle;

  /// Creates a new instance of the [ProjectGroupDialogThemeData].
  const ProjectGroupDialogThemeData({
    this.primaryColor = Colors.blue,
    this.accentColor = Colors.red,
    this.backgroundColor = Colors.white,
    this.closeIconColor = Colors.black,
    this.contentBorderColor = Colors.grey,
    this.titleTextStyle,
    this.groupNameTextStyle,
    this.searchForProjectTextStyle,
    this.uncheckedProjectTextStyle,
    this.checkedProjectTextStyle,
    this.counterTextStyle,
    this.actionsTextStyle,
  });
}
