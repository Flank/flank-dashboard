import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectGroupCardThemeData", () {
    test(
      "creates the theme with the default colors for project cards if the parameters are not specified",
      () {
        const themeData = ProjectGroupCardThemeData();

        expect(themeData.accentColor, isNotNull);
        expect(themeData.primaryColor, isNotNull);
        expect(themeData.backgroundColor, isNotNull);
        expect(themeData.borderColor, isNotNull);
        expect(themeData.hoverColor, isNotNull);
      },
    );

    test(
      "creates the theme with null text styles for project cards if the text styles are not specified",
      () {
        const themeData = ProjectGroupCardThemeData();

        expect(themeData.titleStyle, isNull);
        expect(themeData.subtitleStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const accentColor = Colors.red;
      const backgroundColor = Colors.grey;
      const borderColor = Colors.black;
      const hoverColor = Colors.black26;
      const primaryColor = Colors.green;
      const textStyle = TextStyle();

      final themeData = ProjectGroupCardThemeData(
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        hoverColor: hoverColor,
        primaryColor: primaryColor,
        subtitleStyle: textStyle,
        titleStyle: textStyle,
      );

      expect(themeData.accentColor, equals(accentColor));
      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.borderColor, equals(borderColor));
      expect(themeData.hoverColor, equals(hoverColor));
      expect(themeData.primaryColor, equals(primaryColor));
      expect(themeData.subtitleStyle, equals(textStyle));
      expect(themeData.titleStyle, equals(textStyle));
    });
  });
}
