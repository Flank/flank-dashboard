import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/user_menu_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("UserMenuThemeData", () {
    test("creates an instance with the given values", () {
      const backgroundColor = Colors.blue;
      const dividerColor = Colors.black;
      const contentTextStyle = TextStyle();

      final themeData = UserMenuThemeData(
        backgroundColor: backgroundColor,
        dividerColor: dividerColor,
        contentTextStyle: contentTextStyle,
      );

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.dividerColor, equals(dividerColor));
      expect(themeData.contentTextStyle, equals(contentTextStyle));
    });
  });
}
