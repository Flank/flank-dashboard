import 'package:flutter/material.dart';

/// Stores the theme data for the project group dropdown.
class ProjectGroupsDropdownThemeData {
  /// A default [Color] of the dropdown button border.
  static const Color _defaultBorderColor = Colors.transparent;

  /// The background [Color] for main elements of the project group dropdown.
  final Color backgroundColor;

  /// The [TextStyle] for the for main elements of the project group dropdown.
  final TextStyle textStyle;

  /// The background [Color] of the project group dropdown button when hovered.
  final Color hoverBackgroundColor;

  /// The background [Color] of the project group dropdown button when open.
  final Color openedButtonBackgroundColor;

  /// The background [Color] of the project group dropdown button when closed.
  final Color closedButtonBackgroundColor;

  /// The background [Color] of the project group dropdown button when hovered.
  final Color hoverBorderColor;

  /// The border [Color] of the project group dropdown button when open.
  final Color openedButtonBorderColor;

  /// The border [Color] of the project group dropdown button when closed.
  final Color closedButtonBorderColor;

  /// Creates the [ProjectGroupsDropdownThemeData].
  ///
  /// If [openedButtonBorderColor] or [closedButtonBorderColor] or [hoverBorderColor] is null,
  /// the [Colors.transparent] used.
  const ProjectGroupsDropdownThemeData({
    this.backgroundColor,
    this.textStyle,
    this.hoverBackgroundColor,
    this.openedButtonBackgroundColor,
    this.closedButtonBackgroundColor,
    Color hoverBorderColor,
    Color openedButtonBorderColor,
    Color closedButtonBorderColor,
  })  : hoverBorderColor = hoverBorderColor ?? _defaultBorderColor,
        openedButtonBorderColor =
            openedButtonBorderColor ?? _defaultBorderColor,
        closedButtonBorderColor =
            closedButtonBorderColor ?? _defaultBorderColor;
}
