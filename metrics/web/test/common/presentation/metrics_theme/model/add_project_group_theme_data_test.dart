import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("AddProjectGroupThemeData", () {
    test(
      "creates a theme with the default button styles if the parameters are not specified",
      () {
        const themeData = AddProjectGroupCardThemeData();

        expect(themeData.enabledStyle, isNotNull);
        expect(themeData.disabledStyle, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const enabledStyle = MetricsButtonStyle(
        color: Colors.green,
        labelStyle: TextStyle(color: Colors.yellow),
      );

      const disabledStyle = MetricsButtonStyle(
        color: Colors.grey,
        labelStyle: TextStyle(color: Colors.black),
      );

      final themeData = AddProjectGroupCardThemeData(
        enabledStyle: enabledStyle,
        disabledStyle: disabledStyle,
      );

      expect(themeData.enabledStyle, equals(enabledStyle));
      expect(themeData.disabledStyle, equals(disabledStyle));
    });
  });
}
