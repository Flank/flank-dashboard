// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toggle/theme/theme_data/toggle_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("ToggleThemeData", () {
    test("creates an instance with the given values", () {
      const activeColor = Colors.lightBlue;
      const activeHoverColor = Colors.blue;
      const inactiveColor = Colors.orange;
      const inactiveHoverColor = Colors.deepOrange;

      const themeData = ToggleThemeData(
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        activeHoverColor: activeHoverColor,
        inactiveHoverColor: inactiveHoverColor,
      );

      expect(themeData.activeColor, equals(activeColor));
      expect(themeData.inactiveColor, equals(inactiveColor));
      expect(themeData.activeHoverColor, equals(activeHoverColor));
      expect(themeData.inactiveHoverColor, equals(inactiveHoverColor));
    });
  });
}
