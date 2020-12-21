import 'package:flutter/material.dart';

/// A class that stores the theme data for the debug menu.
class DebugMenuThemeData {
  /// A [TextStyle] for a debug menu section header.
  final TextStyle sectionHeaderTextStyle;

  /// A [TextStyle] for debug menu section content.
  final TextStyle sectionContentTextStyle;

  /// Creates a new instance of the [DebugMenuThemeData]
  /// with the given parameters.
  ///
  /// If the given [sectionHeaderTextStyle] is `null`,
  /// an instance of [TextStyle] is used.
  ///
  /// If the given [sectionContentTextStyle] is `null`,
  /// an instance of [TextStyle] is used.
  const DebugMenuThemeData({
    TextStyle sectionHeaderTextStyle,
    TextStyle sectionContentTextStyle,
  })  : sectionHeaderTextStyle = sectionHeaderTextStyle ?? const TextStyle(),
        sectionContentTextStyle = sectionContentTextStyle ?? const TextStyle();
}
