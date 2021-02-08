// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ProjectMetricsTableThemeData", () {
    test(
      "creates an instance with the default metrics table header theme if the given parameter is null",
      () {
        const themeData = ProjectMetricsTableThemeData(
          metricsTableHeaderTheme: null,
        );

        expect(themeData.metricsTableHeaderTheme, isNotNull);
      },
    );

    test(
      "creates an instance with the default metrics table header placeholder theme if the given parameter is null",
      () {
        const themeData = ProjectMetricsTableThemeData(
          metricsTableHeaderPlaceholderTheme: null,
        );

        expect(themeData.metricsTableHeaderPlaceholderTheme, isNotNull);
      },
    );

    test(
      "creates an instance with the default project metrics tile theme if the given parameter is null",
      () {
        const themeData = ProjectMetricsTableThemeData(
          projectMetricsTileTheme: null,
        );

        expect(themeData.projectMetricsTileTheme, isNotNull);
      },
    );

    test(
      "creates an instance with the default project metrics tile placeholder theme if the given parameter is null",
      () {
        const themeData = ProjectMetricsTableThemeData(
          projectMetricsTilePlaceholderTheme: null,
        );

        expect(themeData.projectMetricsTilePlaceholderTheme, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const headerTheme = MetricsTableHeaderThemeData(
        textStyle: TextStyle(color: Colors.red),
      );

      const headerPlaceholderTheme = ShimmerPlaceholderThemeData(
        backgroundColor: Colors.red,
      );

      const tileTheme = ProjectMetricsTileThemeData(
        textStyle: TextStyle(color: Colors.blue),
        borderColor: Colors.black,
        backgroundColor: Colors.green,
      );

      const tilePlaceholderTheme = ShimmerPlaceholderThemeData(
        backgroundColor: Colors.green,
      );

      const themeData = ProjectMetricsTableThemeData(
        metricsTableHeaderTheme: headerTheme,
        metricsTableHeaderPlaceholderTheme: headerPlaceholderTheme,
        projectMetricsTileTheme: tileTheme,
        projectMetricsTilePlaceholderTheme: tilePlaceholderTheme,
      );

      expect(themeData.metricsTableHeaderTheme, equals(headerTheme));
      expect(
        themeData.metricsTableHeaderPlaceholderTheme,
        equals(headerPlaceholderTheme),
      );
      expect(themeData.projectMetricsTileTheme, equals(tileTheme));
      expect(
        themeData.projectMetricsTilePlaceholderTheme,
        equals(tilePlaceholderTheme),
      );
    });
  });
}
