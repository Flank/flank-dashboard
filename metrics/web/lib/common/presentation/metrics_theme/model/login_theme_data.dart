import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// A class that stores the theme data for the login page.
class LoginThemeData {
  /// A [TextStyle] of the login page title.
  final TextStyle titleTextStyle;

  /// A [MetricsButtonStyle] for buttons with login options.
  final MetricsButtonStyle loginOptionButtonStyle;

  /// A [Color] of the password visibility icon.
  final Color passwordVisibilityIconColor;

  /// Creates a new instance of the [LoginThemeData].
  ///
  /// The [loginOptionButtonStyle] defaults to an empty
  /// [MetricsButtonStyle] instance.
  /// If the [passwordVisibilityIconColor] is `null`, the
  /// [Colors.grey] is used.
  const LoginThemeData({
    this.loginOptionButtonStyle = const MetricsButtonStyle(),
    this.titleTextStyle,
    Color passwordVisibilityIconColor,
  }) : passwordVisibilityIconColor = passwordVisibilityIconColor ?? Colors.grey;
}
