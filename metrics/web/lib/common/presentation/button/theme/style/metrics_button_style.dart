import 'package:flutter/material.dart';

/// A class that stores style data for buttons.
class MetricsButtonStyle {
  /// A [Color] to apply to button.
  final Color color;

  /// A [Color] to apply to button when it is hovered.
  final Color hoverColor;

  /// A [Color] to apply to button label.
  final Color labelColor;

  /// A [TextStyle] for a button label.
  ///
  /// It is recommended to avoid setting a [TextStyle.color] for this text style
  /// since it overrides a text color for a disabled button.
  /// Set [TextStyle.color] for this style if and only if you are sure that
  /// disabled button's label color is the same as for enabled button's label.
  final TextStyle labelStyle;

  /// Creates a new instance of the [MetricsButtonStyle].
  const MetricsButtonStyle({
    this.color = Colors.blue,
    this.hoverColor = Colors.black12,
    this.labelColor = Colors.white,
    this.labelStyle,
  });
}
