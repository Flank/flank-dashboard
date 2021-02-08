// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// A class that stores the theme data for the login page.
class LoginThemeData {
  /// A [TextStyle] of the login page title.
  final TextStyle titleTextStyle;

  /// A [MetricsButtonStyle] for buttons with login options.
  final MetricsButtonStyle loginOptionButtonStyle;

  /// A [MetricsButtonStyle] for inactive buttons with login options.
  final MetricsButtonStyle inactiveLoginOptionButtonStyle;

  /// A [Color] of the password visibility icon.
  final Color passwordVisibilityIconColor;

  /// Creates a new instance of the [LoginThemeData].
  ///
  /// If the [loginOptionButtonStyle] is `null`, an empty
  /// [MetricsButtonStyle] instance is used.
  /// If the [inactiveLoginOptionButtonStyle] is `null`, an empty
  /// [MetricsButtonStyle] instance is used.
  /// If the [passwordVisibilityIconColor] is `null`, the
  /// [Colors.grey] is used.
  const LoginThemeData({
    this.titleTextStyle,
    MetricsButtonStyle loginOptionButtonStyle,
    MetricsButtonStyle inactiveLoginOptionButtonStyle,
    Color passwordVisibilityIconColor,
  })  : loginOptionButtonStyle =
            loginOptionButtonStyle ?? const MetricsButtonStyle(),
        inactiveLoginOptionButtonStyle =
            inactiveLoginOptionButtonStyle ?? const MetricsButtonStyle(),
        passwordVisibilityIconColor =
            passwordVisibilityIconColor ?? Colors.grey;
}
