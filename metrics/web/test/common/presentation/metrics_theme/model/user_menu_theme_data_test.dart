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
      const shadowColor = Colors.red;
      const iconColor = Colors.red;
      const activeIconColor = Colors.yellow;
      const contentTextStyle = TextStyle();

      final themeData = UserMenuThemeData(
          backgroundColor: backgroundColor,
          dividerColor: dividerColor,
          shadowColor: shadowColor,
          contentTextStyle: contentTextStyle,
          iconColor: iconColor,
          activeIconColor: activeIconColor);

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.dividerColor, equals(dividerColor));
      expect(themeData.shadowColor, equals(shadowColor));
      expect(themeData.contentTextStyle, equals(contentTextStyle));
      expect(themeData.iconColor, equals(iconColor));
      expect(themeData.activeIconColor, equals(activeIconColor));
    });

    test("creates an instance with the default shadow color", () {
      final themeData = UserMenuThemeData();

      expect(themeData.shadowColor, isNotNull);
    });
  });
}
