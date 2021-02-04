// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the page title.
class PageTitleThemeData {
  /// A [TextStyle] for the page title.
  final TextStyle textStyle;

  /// A [Color] for the page title icon.
  final Color iconColor;

  /// Creates a new instance of the [PageTitleThemeData].
  ///
  /// The [iconColor] defaults to [Colors.grey].
  const PageTitleThemeData({
    this.iconColor = Colors.grey,
    this.textStyle,
  });
}
