import 'package:flutter/material.dart';

/// A class that provides a style configuration for the project build status widget.
@immutable
class AddProjectGroupCardStyle {
  /// A [Color] of the background.
  final Color backgroundColor;

  /// A [Color] of the icon.
  final Color iconColor;

  /// A hover [Color] of a card.
  final Color hoverColor;

  /// A [TextStyle] of the label.
  final TextStyle labelStyle;

  /// Creates an instance of the [AddProjectGroupCardStyle].
  const AddProjectGroupCardStyle({
    this.backgroundColor = Colors.green,
    this.iconColor = Colors.yellow,
    this.hoverColor = Colors.transparent,
    this.labelStyle = const TextStyle(),
  });
}
