import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_metrics_tile_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsTableHeaderThemeData", () {
    test(
      "creates an instance with the default values if the parameters are not specified",
      () {
        const themeData = ProjectMetricsTableThemeData();

        expect(themeData.metricsTableHeaderTheme, isNotNull);
        expect(themeData.projectMetricsTileTheme, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      final textStyle = TextStyle(color: Colors.red);
      final borderColor = Colors.black;
      final backgroundColor = Colors.green;

      final themeData = ProjectMetricsTableThemeData(
        metricsTableHeaderTheme: MetricsTableHeaderThemeData(
          textStyle: textStyle,
        ),
        projectMetricsTileTheme: ProjectMetricsTileThemeData(
          textStyle: textStyle,
          borderColor: borderColor,
          backgroundColor: backgroundColor,
        ),
      );

      expect(themeData.metricsTableHeaderTheme.textStyle, equals(textStyle));
      expect(themeData.projectMetricsTileTheme.textStyle, equals(textStyle));
      expect(
        themeData.projectMetricsTileTheme.borderColor,
        equals(borderColor),
      );
      expect(
        themeData.projectMetricsTileTheme.backgroundColor,
        equals(backgroundColor),
      );
    });
  });
}
