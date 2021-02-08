// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// The class that stores the theme data for the project group card.
class ProjectGroupCardThemeData {
  /// The background [Color] of the project group card.
  final Color backgroundColor;

  /// The hover highlight [Color] of the project group card.
  final Color hoverColor;

  /// The border [Color] of the project group card.
  final Color borderColor;

  /// A primary [MetricsButtonStyle] of the icon label button of the
  /// project group card.
  final MetricsButtonStyle primaryButtonStyle;

  /// An accent [MetricsButtonStyle] of the icon label button of the
  /// project group card.
  final MetricsButtonStyle accentButtonStyle;

  /// The [TextStyle] for the title text of the project group card.
  final TextStyle titleStyle;

  /// The [TextStyle] of the subtitle text for the project group card.
  final TextStyle subtitleStyle;

  /// Creates the [ProjectGroupCardThemeData].
  ///
  /// [backgroundColor] defaults to [Colors.grey]
  /// [hoverColor] defaults to [Colors.black26]
  /// [borderColor] defaults to [Colors.black]
  /// [primaryButtonStyle] defaults to an empty [MetricsButtonStyle].
  /// [accentButtonStyle] defaults to an empty [MetricsButtonStyle].
  const ProjectGroupCardThemeData({
    Color backgroundColor,
    Color hoverColor,
    Color borderColor,
    MetricsButtonStyle primaryButtonStyle,
    MetricsButtonStyle accentButtonStyle,
    this.titleStyle,
    this.subtitleStyle,
  })  : backgroundColor = backgroundColor ?? Colors.grey,
        hoverColor = hoverColor ?? Colors.black26,
        borderColor = borderColor ?? Colors.black,
        primaryButtonStyle = primaryButtonStyle ?? const MetricsButtonStyle(),
        accentButtonStyle = accentButtonStyle ?? const MetricsButtonStyle();
}
