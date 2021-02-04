// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/user_menu_button/theme/user_menu_button_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("UserMenuButtonThemeData", () {
    test(
      "creates a theme with the default colors for the user menu button if the parameters are not specified",
      () {
        const themeData = UserMenuButtonThemeData();

        expect(themeData.hoverColor, isNotNull);
        expect(themeData.color, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const hoverColor = Colors.yellow;
      const color = Colors.red;

      const themeData = UserMenuButtonThemeData(
        hoverColor: hoverColor,
        color: color,
      );

      expect(themeData.hoverColor, equals(hoverColor));
      expect(themeData.color, equals(color));
    });
  });
}
