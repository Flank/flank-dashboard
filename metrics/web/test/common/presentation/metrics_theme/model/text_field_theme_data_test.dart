import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/text_field_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("TextFieldThemeData", () {
    test(
      "creates a theme with the default colors for text fields if the parameters are not specified",
      () {
        const themeData = TextFieldThemeData();

        expect(themeData.focusColor, isNotNull);
        expect(themeData.hoverBorderColor, isNotNull);
      },
    );

    test(
      "creates a theme with null text styles for text fields if the text styles are not specified",
      () {
        const themeData = TextFieldThemeData();

        expect(themeData.textStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const focusColor = Colors.black87;
      const hoverBorderColor = Colors.black;
      const textStyle = TextStyle();

      final themeData = TextFieldThemeData(
        focusColor: focusColor,
        hoverBorderColor: hoverBorderColor,
        textStyle: textStyle,
      );

      expect(themeData.focusColor, equals(focusColor));
      expect(themeData.hoverBorderColor, equals(hoverBorderColor));
      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
