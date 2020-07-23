import 'package:flutter/material.dart';

/// Stores the theme data for the project group dropdown.
class ProjectGroupsDropdownThemeData {
  /// A default [Color] of the dropdown button border.
  static const Color _defaultBorderColor = Colors.transparent;

  /// The background [Color] that can be applied to a trigger button,
  /// a menu and an item of the project group dropdown.
  final Color backgroundColor;

  /// The [TextStyle] that can be applied to a trigger button,
  /// a menu or an item of the project group dropdown.
  final TextStyle textStyle;

  /// The border [Color] of the project group dropdown button when open.
  final Color openedButtonBorderColor;

  /// The background [Color] of the project group dropdown button when open.
  final Color openedButtonBackgroundColor;

  /// The border [Color] of the project group dropdown button when closed.
  final Color closedButtonBorderColor;

  /// The background [Color] of the project group dropdown button when closed.
  final Color closedButtonBackgroundColor;

  /// The background [Color] of the project group dropdown button when hovered.
  final Color hoverBorderColor;

  /// The background [Color] of the project group dropdown button when hovered.
  final Color hoverBackgroundColor;

  /// Creates the [ProjectGroupsDropdownThemeData].
  ///
  /// If [openedButtonBorderColor] or [closedButtonBorderColor] or [hoverBorderColor] is null,
  /// the [Colors.transparent] used.
  const ProjectGroupsDropdownThemeData({
    this.backgroundColor,
    this.textStyle,
    Color openedButtonBorderColor,
    this.openedButtonBackgroundColor,
    Color closedButtonBorderColor,
    this.closedButtonBackgroundColor,
    Color hoverBorderColor,
    this.hoverBackgroundColor,
  })  : hoverBorderColor = hoverBorderColor ?? _defaultBorderColor,
        openedButtonBorderColor =
            openedButtonBorderColor ?? _defaultBorderColor,
        closedButtonBorderColor =
            closedButtonBorderColor ?? _defaultBorderColor;
}
