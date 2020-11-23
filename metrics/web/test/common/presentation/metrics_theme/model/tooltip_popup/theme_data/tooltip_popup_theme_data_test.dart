import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/tooltip_popup/theme_data/tooltip_popup_theme_data.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("TooltipPopupThemeData", () {
    test(
      "creates an instance with the default color if the color is not specified",
      () {
        final themeData = TooltipPopupThemeData();

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with the default color if the given color is null",
      () {
        final themeData = TooltipPopupThemeData(color: null);

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with null text style if the parameters are not specified",
      () {
        final themeData = TooltipPopupThemeData();

        expect(themeData.textStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const color = Colors.white;
      const textStyle = TextStyle(color: Colors.blue);

      final themeData = TooltipPopupThemeData(
        color: color,
        textStyle: textStyle,
      );

      expect(themeData.color, equals(color));
      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
