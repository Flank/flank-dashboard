// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the user menu button.
class UserMenuButtonThemeData {
  /// A [Color] of the hovered user menu button.
  final Color hoverColor;

  /// A [Color] of the user menu button.
  final Color color;

  /// Creates a new instance of the [UserMenuButtonThemeData].
  ///
  /// The [hoverColor] default value is [Colors.blue].
  /// The [color] default value is [Colors.grey].
  const UserMenuButtonThemeData({
    this.hoverColor = Colors.blue,
    this.color = Colors.grey,
  });
}
