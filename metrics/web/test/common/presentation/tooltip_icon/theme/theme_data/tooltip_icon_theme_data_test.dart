// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/tooltip_icon/theme/theme_data/tooltip_icon_theme_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("TooltipIconThemeData", () {
    test(
      "creates an instance with the default color if the color is not specified",
      () {
        const themeData = TooltipIconThemeData();

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with the default color if the given color is null",
      () {
        const themeData = TooltipIconThemeData(color: null);

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with the default hover color if the color is not specified",
      () {
        const themeData = TooltipIconThemeData();

        expect(themeData.hoverColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default hover color if the given color is null",
      () {
        const themeData = TooltipIconThemeData(hoverColor: null);

        expect(themeData.hoverColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const color = Colors.white;
      const hoverColor = Colors.yellow;

      const themeData = TooltipIconThemeData(
        color: color,
        hoverColor: hoverColor,
      );

      expect(themeData.color, equals(color));
      expect(themeData.hoverColor, equals(hoverColor));
    });
  });
}
