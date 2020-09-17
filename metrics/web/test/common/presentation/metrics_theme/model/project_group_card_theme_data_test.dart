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
        expect(themeData.accentHoverColor, isNotNull);
        expect(themeData.primaryColor, isNotNull);
        expect(themeData.primaryHoverColor, isNotNull);
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
      const accentColor = Colors.grey;
      const accentHoverColor = Colors.orange;
      const backgroundColor = Colors.red;
      const borderColor = Colors.white;
      const hoverColor = Colors.yellow;
      const primaryColor = Colors.pink;
      const primaryHoverColor = Colors.grey;
      const textStyle = TextStyle();

      final themeData = ProjectGroupCardThemeData(
        accentColor: accentColor,
        accentHoverColor: accentHoverColor,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        hoverColor: hoverColor,
        primaryColor: primaryColor,
        primaryHoverColor: primaryHoverColor,
        subtitleStyle: textStyle,
        titleStyle: textStyle,
      );

      expect(themeData.accentColor, equals(accentColor));
      expect(themeData.accentHoverColor, equals(accentHoverColor));
      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.borderColor, equals(borderColor));
      expect(themeData.hoverColor, equals(hoverColor));
      expect(themeData.primaryColor, equals(primaryColor));
      expect(themeData.primaryHoverColor, equals(primaryHoverColor));
      expect(themeData.subtitleStyle, equals(textStyle));
      expect(themeData.titleStyle, equals(textStyle));
    });
  });
}
