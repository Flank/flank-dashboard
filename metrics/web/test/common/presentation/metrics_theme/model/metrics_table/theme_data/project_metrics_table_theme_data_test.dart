import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectMetricsTableThemeData", () {
    test(
      "creates an instance with the default metrics table header theme if the given parameter is null",
      () {
        final themeData = ProjectMetricsTableThemeData(
          metricsTableHeaderTheme: null,
        );

        expect(themeData.metricsTableHeaderTheme, isNotNull);
      },
    );

    test(
      "creates an instance with the default project metrics tile theme if the given parameter is null",
      () {
        final themeData = ProjectMetricsTableThemeData(
          projectMetricsTileTheme: null,
        );

        expect(themeData.projectMetricsTileTheme, isNotNull);
      },
    );

    test(
      "creates an instance with the default project metrics tile placeholder theme if the given parameter is null",
      () {
        final themeData = ProjectMetricsTableThemeData(
          projectMetricsTilePlaceholderTheme: null,
        );

        expect(themeData.projectMetricsTilePlaceholderTheme, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      final headerTheme = MetricsTableHeaderThemeData(
        textStyle: TextStyle(color: Colors.red),
      );

      final tileTheme = ProjectMetricsTileThemeData(
        textStyle: TextStyle(color: Colors.blue),
        borderColor: Colors.black,
        backgroundColor: Colors.green,
      );

      final tilePlaceholderTheme = ShimmerPlaceholderThemeData(
        backgroundColor: Colors.green,
      );

      final themeData = ProjectMetricsTableThemeData(
        metricsTableHeaderTheme: headerTheme,
        projectMetricsTileTheme: tileTheme,
        projectMetricsTilePlaceholderTheme: tilePlaceholderTheme,
      );

      expect(themeData.metricsTableHeaderTheme, equals(headerTheme));
      expect(themeData.projectMetricsTileTheme, equals(tileTheme));
      expect(
        themeData.projectMetricsTilePlaceholderTheme,
        equals(tilePlaceholderTheme),
      );
    });
  });
}
