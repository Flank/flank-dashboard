// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/tooltip_popup/theme/theme_data/tooltip_popup_theme_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("TooltipPopupThemeData", () {
    test(
      "creates an instance with the default background color if it is not specified",
      () {
        const themeData = TooltipPopupThemeData();

        expect(themeData.backgroundColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default background color if the given color is null",
      () {
        const themeData = TooltipPopupThemeData(backgroundColor: null);

        expect(themeData.backgroundColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default shadow color if it is not specified",
      () {
        const themeData = TooltipPopupThemeData();

        expect(themeData.shadowColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default shadow color if the given color is null",
      () {
        const themeData = TooltipPopupThemeData(shadowColor: null);

        expect(themeData.shadowColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const backGroundColor = Colors.white;
      const shadowColor = Colors.black;
      const textStyle = TextStyle(color: Colors.blue);

      const themeData = TooltipPopupThemeData(
        backgroundColor: backGroundColor,
        shadowColor: shadowColor,
        textStyle: textStyle,
      );

      expect(themeData.backgroundColor, equals(backGroundColor));
      expect(themeData.shadowColor, equals(shadowColor));
      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
