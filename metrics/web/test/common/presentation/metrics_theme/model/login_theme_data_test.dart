import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("LoginThemeData", () {
    test(
      "creates the theme with the default colors for login page if the parameters are not specified",
      () {
        const themeData = LoginThemeData();

        expect(themeData.primaryColor, isNotNull);
        expect(themeData.textFieldHoverColor, isNotNull);
        expect(themeData.textFieldHoverBorderColor, isNotNull);
        expect(themeData.loginOptionColor, isNotNull);
      },
    );

    test(
      "creates the theme with null text styles for login page if the text styles are not specified",
      () {
        const themeData = LoginThemeData();

        expect(themeData.titleTextStyle, isNull);
        expect(themeData.loginButtonTextStyle, isNull);
        expect(themeData.loginOptionTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const defaultTextStyle = TextStyle();

      const primaryColor = Colors.blue;
      const titleTextStyle = defaultTextStyle;
      const textFieldHoverColor = Colors.grey;
      const textFieldHoverBorderColor = Colors.black54;
      const loginButtonTextStyle = defaultTextStyle;
      const loginOptionTextStyle = defaultTextStyle;
      const loginOptionColor = Colors.green;

      final themeData = LoginThemeData(
        primaryColor: primaryColor,
        titleTextStyle: titleTextStyle,
        textFieldHoverColor: textFieldHoverColor,
        textFieldHoverBorderColor: textFieldHoverBorderColor,
        loginButtonTextStyle: loginButtonTextStyle,
        loginOptionTextStyle: loginOptionTextStyle,
        loginOptionColor: loginOptionColor,
      );

      expect(themeData.primaryColor, equals(primaryColor));
      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(themeData.textFieldHoverColor, equals(textFieldHoverColor));
      expect(
        themeData.textFieldHoverBorderColor,
        equals(textFieldHoverBorderColor),
      );
      expect(themeData.loginButtonTextStyle, equals(loginButtonTextStyle));
      expect(themeData.loginOptionTextStyle, equals(loginOptionTextStyle));
      expect(themeData.loginOptionColor, equals(loginOptionColor));
    });
  });
}
