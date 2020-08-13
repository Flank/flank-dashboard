import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/text_placeholder/theme/theme_data/text_placeholder_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("TextPlaceholderThemeData", () {
    test("creates an instance with the given values", () {
      const textStyle = TextStyle();

      final themeData = TextPlaceholderThemeData(
        textStyle: textStyle
      );

      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
