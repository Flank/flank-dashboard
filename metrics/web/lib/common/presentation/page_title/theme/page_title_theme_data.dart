import 'package:flutter/material.dart';

/// A class that stores the theme data for the page title.
class PageTitleThemeData {
  /// A main [TextStyle] for the page title.
  final TextStyle textStyle;

  /// The icon's [Color] for the page title.
  final Color iconColor;

  /// Creates a new instance of the [PageTitleThemeData].
  const PageTitleThemeData({
    this.textStyle,
    this.iconColor,
  });
}
