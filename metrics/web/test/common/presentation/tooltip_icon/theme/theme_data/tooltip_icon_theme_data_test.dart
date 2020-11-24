import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/tooltip_icon/theme/theme_data/tooltip_icon_theme_data.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("TooltipIconThemeData", () {
    test(
      "creates an instance with the default color if the color is not specified",
      () {
        final themeData = TooltipIconThemeData();

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with the default color if the given color is null",
      () {
        final themeData = TooltipIconThemeData(color: null);

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with the default hover color if the color is not specified",
      () {
        final themeData = TooltipIconThemeData();

        expect(themeData.hoverColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default hover color if the given color is null",
      () {
        final themeData = TooltipIconThemeData(hoverColor: null);

        expect(themeData.hoverColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const color = Colors.white;
      const hoverColor = Colors.yellow;

      final themeData = TooltipIconThemeData(
        color: color,
        hoverColor: hoverColor,
      );

      expect(themeData.color, equals(color));
      expect(themeData.hoverColor, equals(hoverColor));
    });
  });
}
