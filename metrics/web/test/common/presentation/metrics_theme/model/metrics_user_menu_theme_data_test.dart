import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_user_menu_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsUserMenuThemeData", () {
    test(
      "creates an instance with the default colors if the parameters are not specified",
          () {
        const themeData = MetricsUserMenuThemeData();

        expect(themeData.backgroundColor, isNotNull);
        expect(themeData.dividerColor, isNotNull);
      },
    );

    test(
      "creates an instance with null text style if the parameter is not specified",
          () {
        const themeData = MetricsUserMenuThemeData();

        expect(themeData.contentTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const backgroundColor = Colors.blue;
      const dividerColor = Colors.black;
      const contentTextStyle = TextStyle();

      final themeData = MetricsUserMenuThemeData(
        backgroundColor: backgroundColor,
        dividerColor: dividerColor,
        contentTextStyle: contentTextStyle,
      );

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.dividerColor, equals(dividerColor));
      expect(themeData.contentTextStyle, equals(contentTextStyle));
    });
  });
}
