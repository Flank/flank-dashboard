import 'package:flutter/material.dart';

/// A class that stores style data for buttons.
class MetricsButtonStyle {
  /// A [Color] to apply to button.
  final Color color;

  /// A [Color] to apply to button when it is hovered.
  final Color hoverColor;

  /// A [TextStyle] for a button label.
  final TextStyle labelStyle;

  /// Creates a new instance of the [MetricsButtonStyle].
  const MetricsButtonStyle({
    this.color = Colors.blue,
    this.hoverColor = Colors.black12,
    this.labelStyle,
  });
}
