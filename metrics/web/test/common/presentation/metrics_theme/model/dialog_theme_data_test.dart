// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dialog_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("DialogThemeData", () {
    test(
      "creates an instance with the default colors if the parameters are not specified",
      () {
        const themeData = DialogThemeData();

        expect(themeData.primaryColor, isNotNull);
        expect(themeData.accentColor, isNotNull);
        expect(themeData.backgroundColor, isNotNull);
        expect(themeData.barrierColor, isNotNull);
        expect(themeData.closeIconColor, isNotNull);
      },
    );

    test(
      "creates an instance with null text styles if the parameters are not specified",
      () {
        const themeData = DialogThemeData();

        expect(themeData.titleTextStyle, isNull);
        expect(themeData.errorTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const defaultTextStyle = TextStyle();

      const primaryColor = Colors.blue;
      const accentColor = Colors.red;
      const backgroundColor = Colors.white;
      const barrierColor = Colors.yellow;
      const closeIconColor = Colors.black;

      const titleTextStyle = defaultTextStyle;
      const errorTextStyle = defaultTextStyle;

      const themeData = DialogThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        closeIconColor: closeIconColor,
        titleTextStyle: titleTextStyle,
        errorTextStyle: errorTextStyle,
      );

      expect(themeData.primaryColor, equals(primaryColor));
      expect(themeData.accentColor, equals(accentColor));
      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.barrierColor, equals(barrierColor));
      expect(themeData.closeIconColor, equals(closeIconColor));
      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(themeData.errorTextStyle, equals(errorTextStyle));
    });
  });
}
