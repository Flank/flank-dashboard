// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/dropdown/theme/theme_data/dropdown_item_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("DropdownItemThemeData", () {
    test("creates an instance with the given values", () {
      const backgroundColor = Colors.red;
      const textStyle = TextStyle(fontSize: 13.0);
      const hoverColor = Colors.orange;
      const hoverTextStyle = TextStyle(color: Colors.yellow);

      const themeData = DropdownItemThemeData(
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        hoverColor: hoverColor,
        hoverTextStyle: hoverTextStyle,
      );

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.textStyle, equals(textStyle));
      expect(themeData.hoverColor, equals(hoverColor));
      expect(themeData.hoverTextStyle, equals(hoverTextStyle));
    });
  });
}
