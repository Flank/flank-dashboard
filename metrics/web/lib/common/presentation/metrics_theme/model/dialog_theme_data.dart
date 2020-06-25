import 'package:flutter/material.dart';

/// A class that specifies the dialog theme.
class DialogThemeData {
  /// The padding used as a default.
  static const _defaultPadding = EdgeInsets.symmetric(vertical: 12.0);

  /// An empty space between the main content and dialog's edges.
  final EdgeInsets padding;

  /// An empty space that surrounds the content.
  final EdgeInsets contentPadding;

  /// An empty space that surrounds the actions.
  final EdgeInsets actionsPadding;

  /// An empty space that surrounds the title.
  final EdgeInsets titlePadding;

  /// The [TextStyle] of the dialog title.
  final TextStyle titleTextStyle;

  /// Creates the new instance of the [DialogThemeData].
  ///
  /// The [padding] default insets' value is 32.0.
  /// The [titlePadding], the [contentPadding] and the [actionsPadding]
  /// default vertical insets' value is 12.0.
  /// The [titleTextStyle] default font size is 32.0
  /// and a font weight is the [FontWeight.bold].
  const DialogThemeData({
    this.padding = const EdgeInsets.all(32.0),
    this.titlePadding = _defaultPadding,
    this.contentPadding = _defaultPadding,
    this.actionsPadding = _defaultPadding,
    this.titleTextStyle = const TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
  });
}
