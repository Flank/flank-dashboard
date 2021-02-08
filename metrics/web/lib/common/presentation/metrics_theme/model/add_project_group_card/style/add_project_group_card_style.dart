// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that provides a style configuration for the add project group card widget.
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
  ///
  /// [backgroundColor] defaults to `Colors.green`.
  /// [iconColor] defaults to `Colors.yellow`.
  /// [hoverColor] defaults to `Colors.transparent`.
  /// [labelStyle] defaults to `TextStyle`.
  const AddProjectGroupCardStyle({
    Color backgroundColor,
    Color iconColor,
    Color hoverColor,
    TextStyle labelStyle,
  })  : backgroundColor = backgroundColor ?? Colors.green,
        iconColor = iconColor ?? Colors.yellow,
        hoverColor = hoverColor ?? Colors.transparent,
        labelStyle = labelStyle ?? const TextStyle();
}
