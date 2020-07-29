import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("LoginThemeData", () {
    test(
      "creates a theme with the default styles for login page if the parameters are not specified",
      () {
        const themeData = LoginThemeData();

        expect(themeData.loginOptionButtonStyle, isNotNull);
      },
    );

    test(
      "creates a theme with null text styles for login page if the text styles are not specified",
      () {
        const themeData = LoginThemeData();

        expect(themeData.titleTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const titleTextStyle = TextStyle();
      const loginOptionButtonStyle = MetricsButtonStyle();

      final themeData = LoginThemeData(
        titleTextStyle: titleTextStyle,
        loginOptionButtonStyle: loginOptionButtonStyle,
      );

      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(themeData.loginOptionButtonStyle, equals(loginOptionButtonStyle));
    });
  });
}
