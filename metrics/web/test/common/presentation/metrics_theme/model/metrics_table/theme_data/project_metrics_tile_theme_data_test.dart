// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ProjectMetricsTileThemeData", () {
    test(
      "creates a theme data with the default border color if the given one is null",
      () {
        const themeData = ProjectMetricsTileThemeData(borderColor: null);

        expect(
          themeData.borderColor,
          isNotNull,
        );
      },
    );

    test(
      "creates a theme data with the default hover border color if the given one is null",
      () {
        const themeData = ProjectMetricsTileThemeData(hoverBorderColor: null);

        expect(
          themeData.hoverBorderColor,
          isNotNull,
        );
      },
    );

    test("creates a theme data with the given parameters", () {
      const backgroundColor = Colors.grey;
      const hoverBackgroundColor = Colors.yellow;
      const borderColor = Colors.red;
      const hoverBorderColor = Colors.orange;
      const textStyle = TextStyle(
        color: Colors.blue,
        fontSize: 20.0,
      );

      const themeData = ProjectMetricsTileThemeData(
        backgroundColor: backgroundColor,
        hoverBackgroundColor: hoverBackgroundColor,
        borderColor: borderColor,
        hoverBorderColor: hoverBorderColor,
        textStyle: textStyle,
      );

      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.hoverBackgroundColor, equals(hoverBackgroundColor));
      expect(themeData.borderColor, equals(borderColor));
      expect(themeData.hoverBorderColor, equals(hoverBorderColor));
      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
