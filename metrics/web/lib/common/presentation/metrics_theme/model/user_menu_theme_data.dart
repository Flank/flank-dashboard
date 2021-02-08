// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the metrics user menu.
class UserMenuThemeData {
  /// A shadow [Color] of the user menu.
  final Color shadowColor;

  /// A background [Color] of the user menu.
  final Color backgroundColor;

  /// A divider [Color] of the user menu.
  final Color dividerColor;

  /// The [TextStyle] of the text in the user menu.
  final TextStyle contentTextStyle;

  /// Creates a new instance of the [UserMenuThemeData].
  ///
  /// The [shadowColor] default value is [Colors.black].
  const UserMenuThemeData({
    this.shadowColor = Colors.black,
    this.backgroundColor,
    this.dividerColor,
    this.contentTextStyle,
  });
}
