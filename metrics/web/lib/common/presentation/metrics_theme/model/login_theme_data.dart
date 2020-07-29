import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// A class that stores the theme data for the login page.
class LoginThemeData {
  /// A [TextStyle] of the login page title.
  final TextStyle titleTextStyle;

  /// A [MetricsButtonStyle] for buttons with login options.
  final MetricsButtonStyle loginOptionButtonStyle;

  /// Creates a new instance of the [LoginThemeData].
  const LoginThemeData({
    this.loginOptionButtonStyle = const MetricsButtonStyle(),
    this.titleTextStyle,
  });
}
