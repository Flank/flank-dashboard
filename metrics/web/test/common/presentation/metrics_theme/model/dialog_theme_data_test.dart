// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dialog_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("DialogThemeDataTest", () {
    test(
      "creates the theme with the default theme data if the parameters are not specified",
      () {
        final themeData = DialogThemeData();

        expect(themeData.padding, isNotNull);
        expect(themeData.contentPadding, isNotNull);
        expect(themeData.actionsPadding, isNotNull);
        expect(themeData.titlePadding, isNotNull);
        expect(themeData.titleTextStyle, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const padding = EdgeInsets.all(1.0);
      const contentPadding = EdgeInsets.all(2.0);
      const actionsPadding = EdgeInsets.all(3.0);
      const titlePadding = EdgeInsets.all(4.0);
      const titleTextStyle = TextStyle();

      final dialogThemeData = DialogThemeData(
        padding: padding,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
      );

      expect(dialogThemeData.padding, equals(padding));
      expect(dialogThemeData.contentPadding, equals(contentPadding));
      expect(dialogThemeData.actionsPadding, equals(actionsPadding));
      expect(dialogThemeData.titlePadding, equals(titlePadding));
      expect(dialogThemeData.titleTextStyle, equals(titleTextStyle));
    });
  });
}
