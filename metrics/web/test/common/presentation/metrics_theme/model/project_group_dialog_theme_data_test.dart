// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupDialogThemeData", () {
    test(
      "creates an instance with the default colors if the parameters are not specified",
      () {
        const themeData = ProjectGroupDialogThemeData();

        expect(themeData.primaryColor, isNotNull);
        expect(themeData.backgroundColor, isNotNull);
        expect(themeData.barrierColor, isNotNull);
        expect(themeData.closeIconColor, isNotNull);
        expect(themeData.contentBorderColor, isNotNull);
      },
    );

    test(
      "creates an instance with null text styles if the parameters are not specified",
      () {
        const themeData = ProjectGroupDialogThemeData();

        expect(themeData.titleTextStyle, isNull);
        expect(themeData.uncheckedProjectTextStyle, isNull);
        expect(themeData.checkedProjectTextStyle, isNull);
        expect(themeData.counterTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const defaultTextStyle = TextStyle();

      const primaryColor = Colors.blue;
      const backgroundColor = Colors.white;
      const barrierColor = Colors.yellow;
      const closeIconColor = Colors.black;
      const contentBorderColor = Colors.black;

      const titleTextStyle = defaultTextStyle;
      const uncheckedProjectTextStyle = defaultTextStyle;
      const checkedProjectTextStyle = defaultTextStyle;
      const counterTextStyle = defaultTextStyle;

      const themeData = ProjectGroupDialogThemeData(
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        closeIconColor: closeIconColor,
        contentBorderColor: contentBorderColor,
        titleTextStyle: titleTextStyle,
        uncheckedProjectTextStyle: uncheckedProjectTextStyle,
        checkedProjectTextStyle: checkedProjectTextStyle,
        counterTextStyle: counterTextStyle,
      );

      expect(themeData.primaryColor, equals(primaryColor));
      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.barrierColor, equals(barrierColor));
      expect(themeData.closeIconColor, equals(closeIconColor));
      expect(themeData.contentBorderColor, equals(contentBorderColor));
      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(
        themeData.uncheckedProjectTextStyle,
        equals(uncheckedProjectTextStyle),
      );
      expect(
        themeData.checkedProjectTextStyle,
        equals(checkedProjectTextStyle),
      );
      expect(themeData.counterTextStyle, equals(counterTextStyle));
    });
  });
}
