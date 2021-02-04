// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores style data for buttons.
class MetricsButtonStyle {
  /// A [Color] to apply to button.
  final Color color;

  /// A [Color] to apply to button when it is hovered.
  final Color hoverColor;

  /// A [TextStyle] for a button label.
  final TextStyle labelStyle;

  /// The z-coordinate at which to place the button relative to its parent.
  final double elevation;

  /// Creates a new instance of the [MetricsButtonStyle].
  ///
  /// The [color] default value is [Colors.blue].
  /// The [hoverColor] default value is [Colors.black12].
  /// The [elevation] default value is `0.0`.
  const MetricsButtonStyle({
    this.color = Colors.blue,
    this.hoverColor = Colors.black12,
    this.elevation = 0.0,
    this.labelStyle,
  });
}
