import 'package:flutter/material.dart';

/// A class that stores the theme data for the project group dialogues.
class ProjectGroupDialogThemeData {
  /// The default padding for this theme data.
  static const _defaultPadding = EdgeInsets.zero;

  /// An empty space between the main content and dialog's edges.
  final EdgeInsets padding;

  /// An empty space that surrounds the content.
  final EdgeInsets contentPadding;

  /// A [TextStyle] of the content text for the project group dialog.
  final TextStyle contentTextStyle;

  /// A [TextStyle] of the content secondary text for the project group dialog.
  final TextStyle contentSecondaryTextStyle;

  /// A border [Color] of the project group dialog content.
  final Color contentBorderColor;

  /// An empty space that surrounds the actions.
  final EdgeInsets actionsPadding;

  /// A [TextStyle] of the actions text for the project group dialog.
  final TextStyle actionsTextStyle;

  /// An empty space that surrounds the title.
  final EdgeInsets titlePadding;

  /// A [TextStyle] of the dialog title.
  final TextStyle titleTextStyle;

  /// A primary [Color] for main elements of the project group dialog.
  final Color primaryColor;

  /// A secondary [Color] for elements of the project group dialog.
  final Color accentColor;

  /// A background [Color] of the project group dialog.
  final Color backgroundColor;

  /// A decoration for the [TextField]s of the project group dialog.
  final InputDecoration textFieldDecoration;

  /// Creates the new instance of the [ProjectGroupDialogThemeData].
  ///
  /// The [padding] default insets' value is 32.0.
  /// The [titlePadding], the [contentPadding], and the [actionsPadding]
  /// default value is [EdgeInsets.zero].
  const ProjectGroupDialogThemeData({
    this.padding = const EdgeInsets.all(32.0),
    this.titlePadding = _defaultPadding,
    this.contentPadding = _defaultPadding,
    this.actionsPadding = _defaultPadding,
    this.primaryColor = Colors.blue,
    this.accentColor = Colors.red,
    this.backgroundColor = Colors.white,
    this.contentBorderColor = Colors.grey,
    this.titleTextStyle,
    this.contentTextStyle,
    this.contentSecondaryTextStyle,
    this.actionsTextStyle,
    this.textFieldDecoration,
  });
}
