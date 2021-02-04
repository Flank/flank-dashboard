// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupCardThemeData", () {
    test(
      "creates the theme with the default colors for project cards if the parameters are not specified",
      () {
        const themeData = ProjectGroupCardThemeData();

        expect(themeData.primaryButtonStyle, isNotNull);
        expect(themeData.accentButtonStyle, isNotNull);
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
      const backgroundColor = Colors.red;
      const borderColor = Colors.white;
      const hoverColor = Colors.yellow;
      const primaryColor = Colors.pink;
      const textStyle = TextStyle();
      const primaryButtonStyle = MetricsButtonStyle(
        color: primaryColor,
      );
      const accentButtonStyle = MetricsButtonStyle(
        color: accentColor,
      );

      const themeData = ProjectGroupCardThemeData(
        accentButtonStyle: accentButtonStyle,
        primaryButtonStyle: primaryButtonStyle,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        hoverColor: hoverColor,
        subtitleStyle: textStyle,
        titleStyle: textStyle,
      );

      expect(themeData.primaryButtonStyle, equals(primaryButtonStyle));
      expect(themeData.accentButtonStyle, equals(accentButtonStyle));
      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.borderColor, equals(borderColor));
      expect(themeData.hoverColor, equals(hoverColor));
      expect(themeData.subtitleStyle, equals(textStyle));
      expect(themeData.titleStyle, equals(textStyle));
    });
  });
}
