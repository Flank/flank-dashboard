// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dropdown_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupDropdownThemeData", () {
    test(
      "creates an instance with the default openedButtonBorderColor if given color is null",
      () {
        final themeData = ProjectGroupDropdownThemeData(
          openedButtonBorderColor: null,
        );

        expect(themeData.openedButtonBorderColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default closedButtonBorderColor if given color is null",
      () {
        final themeData = ProjectGroupDropdownThemeData(
          closedButtonBorderColor: null,
        );

        expect(themeData.closedButtonBorderColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default hoverBorderColor if given color is null",
      () {
        final themeData = ProjectGroupDropdownThemeData(
          hoverBorderColor: null,
        );

        expect(themeData.hoverBorderColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const backgroundColor = Colors.red;
      const textStyle = TextStyle(fontSize: 13.0);
      const openedButtonBackgroundColor = Colors.orange;
      const closedButtonBackgroundColor = Colors.yellow;
      const openedButtonBorderColor = Colors.white;
      const closedButtonBorderColor = Colors.blue;

      final themeData = ProjectGroupDropdownThemeData(
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        openedButtonBackgroundColor: openedButtonBackgroundColor,
        closedButtonBackgroundColor: closedButtonBackgroundColor,
        openedButtonBorderColor: openedButtonBorderColor,
        closedButtonBorderColor: closedButtonBorderColor,
      );

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.textStyle, equals(textStyle));
      expect(
        themeData.openedButtonBackgroundColor,
        equals(openedButtonBackgroundColor),
      );
      expect(
        themeData.closedButtonBackgroundColor,
        equals(closedButtonBackgroundColor),
      );
      expect(
        themeData.openedButtonBorderColor,
        equals(openedButtonBorderColor),
      );
      expect(
        themeData.closedButtonBorderColor,
        equals(closedButtonBorderColor),
      );
    });
  });
}