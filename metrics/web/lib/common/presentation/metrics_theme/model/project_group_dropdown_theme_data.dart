import 'package:flutter/material.dart';

/// Stores the theme data for the project group dropdown.
class ProjectGroupDropdownThemeData {
  /// A default [Color] of the dropdown button border.
  static const Color _defaultBorderColor = Colors.transparent;

  /// The background [Color] for main elements of the project group dropdown.
  final Color backgroundColor;

  /// The [TextStyle] for the for main elements of the project group dropdown.
  final TextStyle textStyle;

  /// The background [Color] of the project group dropdown button when the project group dropdown is hovered.
  final Color hoverBackgroundColor;

  /// The background [Color] of the project group dropdown button when the project group dropdown is hovered.
  final Color hoverBorderColor;

  /// The background [Color] of the project group dropdown button when the project group dropdown is opened.
  final Color openedButtonBackgroundColor;

  /// The background [Color] of the project group dropdown button when the project group dropdown is closed.
  final Color closedButtonBackgroundColor;

  /// The border [Color] of the project group dropdown button when the project group dropdown is opened.
  final Color openedButtonBorderColor;

  /// The border [Color] of the project group dropdown button when the project group dropdown is closed.
  final Color closedButtonBorderColor;

  /// Creates the [ProjectGroupDropdownThemeData].
  ///
  /// If [openedButtonBorderColor] or [closedButtonBorderColor] or [hoverBorderColor] is null,
  /// the [Colors.transparent] used.
  const ProjectGroupDropdownThemeData({
    this.backgroundColor,
    this.textStyle,
    this.openedButtonBackgroundColor,
    this.closedButtonBackgroundColor,
    this.hoverBackgroundColor,
    Color hoverBorderColor,
    Color openedButtonBorderColor,
    Color closedButtonBorderColor,
  })  : hoverBorderColor = hoverBorderColor ?? _defaultBorderColor,
        openedButtonBorderColor =
            openedButtonBorderColor ?? _defaultBorderColor,
        closedButtonBorderColor =
            closedButtonBorderColor ?? _defaultBorderColor;
}
