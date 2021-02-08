// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/user_menu_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("UserMenuThemeData", () {
    test("creates an instance with the given values", () {
      const backgroundColor = Colors.blue;
      const dividerColor = Colors.black;
      const shadowColor = Colors.red;
      const contentTextStyle = TextStyle();

      const themeData = UserMenuThemeData(
        backgroundColor: backgroundColor,
        dividerColor: dividerColor,
        shadowColor: shadowColor,
        contentTextStyle: contentTextStyle,
      );

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.dividerColor, equals(dividerColor));
      expect(themeData.shadowColor, equals(shadowColor));
      expect(themeData.contentTextStyle, equals(contentTextStyle));
    });

    test("creates an instance with the default shadow color", () {
      const themeData = UserMenuThemeData();

      expect(themeData.shadowColor, isNotNull);
    });
  });
}
