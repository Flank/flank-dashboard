// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("DebugMenuThemeData", () {
    test(
      "creates an instance with the default section header text style if the given one is null",
      () {
        const themeData = DebugMenuThemeData(sectionHeaderTextStyle: null);

        expect(themeData.sectionHeaderTextStyle, isNotNull);
      },
    );

    test(
      "creates an instance with the default section content text style if the given one is null",
      () {
        const themeData = DebugMenuThemeData(sectionContentTextStyle: null);

        expect(themeData.sectionContentTextStyle, isNotNull);
      },
    );

    test(
      "creates an instance with the default section divider color if the given one is null",
      () {
        const themeData = DebugMenuThemeData(sectionDividerColor: null);

        expect(themeData.sectionDividerColor, isNotNull);
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const sectionHeaderTextStyle = TextStyle(color: Colors.red);
        const sectionContentTextStyle = TextStyle(color: Colors.green);
        const sectionDividerColor = Colors.blue;

        const themeData = DebugMenuThemeData(
          sectionHeaderTextStyle: sectionHeaderTextStyle,
          sectionContentTextStyle: sectionContentTextStyle,
          sectionDividerColor: sectionDividerColor,
        );

        expect(
          themeData.sectionHeaderTextStyle,
          equals(sectionHeaderTextStyle),
        );
        expect(
          themeData.sectionContentTextStyle,
          equals(sectionContentTextStyle),
        );
        expect(themeData.sectionDividerColor, equals(sectionDividerColor));
      },
    );
  });
}
