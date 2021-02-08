// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/page_title/theme/page_title_theme_data.dart';

void main() {
  group("PageTitleThemeData", () {
    test(
      "creates an instance with the default icon color if the parameter is not specified",
      () {
        const themeData = PageTitleThemeData();

        expect(themeData.iconColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const iconColor = Colors.red;
      const textStyle = TextStyle(fontSize: 6.0);

      const themeData = PageTitleThemeData(
        iconColor: iconColor,
        textStyle: textStyle,
      );

      expect(themeData.iconColor, equals(iconColor));
      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
