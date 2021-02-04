// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the debug menu.
class DebugMenuThemeData {
  /// A [TextStyle] for a debug menu section header.
  final TextStyle sectionHeaderTextStyle;

  /// A [TextStyle] for a debug menu section content.
  final TextStyle sectionContentTextStyle;

  /// A [Color] of the divider within a debug menu section.
  final Color sectionDividerColor;

  /// Creates a new instance of the [DebugMenuThemeData]
  /// with the given parameters.
  ///
  /// If the given [sectionHeaderTextStyle] is `null`,
  /// an empty [TextStyle] is used.
  /// If the given [sectionContentTextStyle] is `null`,
  /// an empty [TextStyle] is used.
  /// If the given [sectionDividerColor] is `null`,
  /// the [Colors.grey] is used.
  const DebugMenuThemeData({
    TextStyle sectionHeaderTextStyle,
    TextStyle sectionContentTextStyle,
    Color sectionDividerColor,
  })  : sectionHeaderTextStyle = sectionHeaderTextStyle ?? const TextStyle(),
        sectionContentTextStyle = sectionContentTextStyle ?? const TextStyle(),
        sectionDividerColor = sectionDividerColor ?? Colors.grey;
}
