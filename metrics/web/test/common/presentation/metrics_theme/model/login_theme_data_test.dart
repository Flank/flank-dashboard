// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LoginThemeData", () {
    test(
      "creates a theme with the default login option button style if the given one is null",
      () {
        const themeData = LoginThemeData(loginOptionButtonStyle: null);

        expect(themeData.loginOptionButtonStyle, isNotNull);
      },
    );

    test(
      "creates a theme with the default visibility icon color if the given value is null",
      () {
        const themeData = LoginThemeData(passwordVisibilityIconColor: null);

        expect(themeData.passwordVisibilityIconColor, isNotNull);
      },
    );

    test(
      "creates a theme with the default inactive login option button style if the given one is null",
      () {
        const themeData = LoginThemeData(inactiveLoginOptionButtonStyle: null);

        expect(themeData.inactiveLoginOptionButtonStyle, isNotNull);
      },
    );

    test(
      "creates a theme with null text styles for login page if the given one is null",
      () {
        const themeData = LoginThemeData(titleTextStyle: null);

        expect(themeData.titleTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const titleTextStyle = TextStyle();
      const loginOptionButtonStyle = MetricsButtonStyle(color: Colors.white);
      const passwordVisibilityIconColor = Colors.green;

      const themeData = LoginThemeData(
        titleTextStyle: titleTextStyle,
        loginOptionButtonStyle: loginOptionButtonStyle,
        passwordVisibilityIconColor: passwordVisibilityIconColor,
      );

      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(themeData.loginOptionButtonStyle, equals(loginOptionButtonStyle));
      expect(themeData.passwordVisibilityIconColor,
          equals(passwordVisibilityIconColor));
    });
  });
}
