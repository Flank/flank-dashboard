import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/user_menu_button/theme/user_menu_button_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("UserMenuButtonThemeData", () {
    test(
      "creates a theme with the default colors for the user menu button if the parameters are not specified",
      () {
        final themeData = UserMenuButtonThemeData();

        expect(themeData.hoverColor, isNotNull);
        expect(themeData.color, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const hoverColor = Colors.yellow;
      const color = Colors.red;

      final themeData = UserMenuButtonThemeData(
        hoverColor: hoverColor,
        color: color,
      );

      expect(themeData.hoverColor, equals(hoverColor));
      expect(themeData.color, equals(color));
    });
  });
}
