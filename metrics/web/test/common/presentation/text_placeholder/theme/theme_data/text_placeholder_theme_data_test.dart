// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/text_placeholder/theme/theme_data/text_placeholder_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("TextPlaceholderThemeData", () {
    test("creates an instance with the given values", () {
      const textStyle = TextStyle();

      const themeData = TextPlaceholderThemeData(textStyle: textStyle);

      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
