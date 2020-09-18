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

  final MetricsButtonStyle primaryButtonStyle;

  final MetricsButtonStyle accentButtonStyle;

  /// The [TextStyle] for the title text of the project group card.
  final TextStyle titleStyle;

  /// The [TextStyle] of the subtitle text for the project group card.
  final TextStyle subtitleStyle;

  /// Creates the [ProjectGroupCardThemeData].
  const ProjectGroupCardThemeData({
    this.backgroundColor = Colors.grey,
    this.hoverColor = Colors.black26,
    this.borderColor = Colors.black,
    this.primaryButtonStyle = const MetricsButtonStyle(),
    this.accentButtonStyle = const MetricsButtonStyle(),
    this.titleStyle,
    this.subtitleStyle,
  });
}
