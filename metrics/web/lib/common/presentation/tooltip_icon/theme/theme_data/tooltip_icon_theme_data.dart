// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data for the tooltip icon.
@immutable
class TooltipIconThemeData {
  /// A [Color] of the tooltip icon.
  final Color color;

  /// A hover [Color] of the tooltip icon.
  final Color hoverColor;

  /// Creates a new instance of the [TooltipIconThemeData].
  ///
  /// If the given [color] or [hoverColor] is null, the [Colors.grey] is used.
  const TooltipIconThemeData({
    Color color,
    Color hoverColor,
  })  : color = color ?? Colors.grey,
        hoverColor = hoverColor ?? Colors.grey;
}
