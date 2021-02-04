// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/delete_dialog_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("DeleteDialogThemeData", () {
    test(
      "creates an instance with the default colors if the parameters are not specified",
      () {
        const themeData = DeleteDialogThemeData();

        expect(themeData.primaryColor, isNotNull);
        expect(themeData.accentColor, isNotNull);
        expect(themeData.backgroundColor, isNotNull);
        expect(themeData.closeIconColor, isNotNull);
      },
    );

    test(
      "creates an instance with null text styles if the parameters are not specified",
      () {
        const themeData = DeleteDialogThemeData();

        expect(themeData.titleTextStyle, isNull);
        expect(themeData.contentTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const defaultTextStyle = TextStyle();

      const backgroundColor = Colors.white;
      const closeIconColor = Colors.black;

      const titleTextStyle = defaultTextStyle;
      const contentTextStyle = defaultTextStyle;

      const themeData = DeleteDialogThemeData(
        backgroundColor: backgroundColor,
        closeIconColor: closeIconColor,
        titleTextStyle: titleTextStyle,
        contentTextStyle: contentTextStyle,
      );

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.closeIconColor, equals(closeIconColor));
      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(themeData.contentTextStyle, equals(contentTextStyle));
    });
  });
}
