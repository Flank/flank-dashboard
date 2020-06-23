import 'package:flutter/material.dart';

/// The class that stores the theme data for the project group card.
class ProjectGroupCardTheme {
  /// The color for the background of the project group card.
  final Color backgroundColor;

  /// The color for the hover highlight of the project group card.
  final Color hoverColor;

  /// The color for the border of the project group card.
  final Color borderColor;

  /// An edit button color of the project group card.
  final Color editColor;

  /// A delete button color of the project group card.
  final Color deleteColor;

  /// The color for the inactive text of the project group card.
  final TextStyle inactiveTextStyle;

  /// Creates the [ProjectGroupCardTheme].
  const ProjectGroupCardTheme({
    this.backgroundColor,
    this.hoverColor,
    this.borderColor,
    this.editColor,
    this.deleteColor,
    this.inactiveTextStyle,
  });
}
