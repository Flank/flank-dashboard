import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/switch/theme/toggle_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ToggleThemeData", () {
    test("creates an instance with the given values", () {
      const activeColor = Colors.lightBlue;
      const activeHoverColor = Colors.blue;
      const inactiveColor = Colors.orange;
      const inactiveHoverColor = Colors.deepOrange;

      final themeData = ToggleThemeData(
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        activeHoverColor: activeHoverColor,
        inactiveHoverColor: inactiveHoverColor,
      );

      expect(themeData.activeColor, equals(activeColor));
      expect(themeData.inactiveColor, equals(inactiveColor));
      expect(themeData.activeHoverColor, equals(activeHoverColor));
      expect(themeData.inactiveHoverColor, equals(inactiveHoverColor));
    });
  });
}
