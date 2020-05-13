import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  test(
    "Creates the theme with the default theme data for metric widgets if the parameters is not specified",
    () {
      const themeData = MetricsThemeData();

      expect(themeData.buildResultTheme, isNotNull);
      expect(themeData.metricWidgetTheme, isNotNull);
      expect(themeData.metricCirclePercentageThemeData, isNotNull);
      expect(themeData.metricCirclePercentageThemeData, isNotNull);
    },
  );

  test(
    'Creates the theme with the default metric widgets theme data if nulls are passed',
    () {
      const themeData = MetricsThemeData(
        metricCirclePercentageThemeData: null,
        metricWidgetTheme: null,
        buildResultTheme: null,
      );

      expect(themeData.metricCirclePercentageThemeData, isNotNull);
      expect(themeData.metricCirclePercentageThemeData, isNotNull);
      expect(themeData.metricWidgetTheme, isNotNull);
      expect(themeData.buildResultTheme, isNotNull);
    },
  );

  test(
    "Creates the new theme from existing using the copyWith",
    () {
      const primaryColor = Colors.red;
      const accentColor = Colors.orange;
      const backgroundColor = Colors.black;

      const sparklineTheme = MetricWidgetThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
      );

      const circlePercentageTheme = MetricCirclePercentageThemeData(
        lowPercentTheme: MetricWidgetThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
        ),
      );

      const buildResultsTheme = BuildResultsThemeData(
        successfulColor: primaryColor,
        failedColor: accentColor,
        canceledColor: backgroundColor,
      );

      const themeData = MetricsThemeData();

      final copiedTheme = themeData.copyWith(
        metricWidgetTheme: sparklineTheme,
        metricCirclePercentageThemeData: circlePercentageTheme,
        barGraphBackgroundColor: backgroundColor,
        buildResultTheme: buildResultsTheme,
      );

      expect(
          copiedTheme.metricCirclePercentageThemeData, circlePercentageTheme);
      expect(copiedTheme.metricWidgetTheme, sparklineTheme);
      expect(copiedTheme.buildResultTheme, buildResultsTheme);
    },
  );

  test(
    "Creates new instance with the same filed if copyWith was used widhout any params",
    () {
      const themeData = MetricsThemeData();
      final copiedTheme = themeData.copyWith();

      expect(themeData, isNot(copiedTheme));
      expect(
        themeData.metricWidgetTheme,
        copiedTheme.metricWidgetTheme,
      );
      expect(
        themeData.metricCirclePercentageThemeData,
        copiedTheme.metricCirclePercentageThemeData,
      );
      expect(
        themeData.buildResultTheme,
        copiedTheme.buildResultTheme,
      );
    },
  );
}
