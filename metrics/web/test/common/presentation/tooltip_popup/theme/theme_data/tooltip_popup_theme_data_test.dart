import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/tooltip_popup/theme/theme_data/tooltip_popup_theme_data.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("TooltipPopupThemeData", () {
    test(
      "creates an instance with the default background color if it is not specified",
      () {
        final themeData = TooltipPopupThemeData();

        expect(themeData.backgroundColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default background color if the given color is null",
      () {
        final themeData = TooltipPopupThemeData(backgroundColor: null);

        expect(themeData.backgroundColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const backGroundColor = Colors.white;
      const textStyle = TextStyle(color: Colors.blue);

      final themeData = TooltipPopupThemeData(
        backgroundColor: backGroundColor,
        textStyle: textStyle,
      );

      expect(themeData.backgroundColor, equals(backGroundColor));
      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
