import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  test(
    "Creates the theme with the default theme data for metric widgets if the parameters is not specified",
    () {
      const themeData = MetricsThemeData();

      expect(themeData.buildResultTheme, isNotNull);
      expect(themeData.metricWidgetTheme, isNotNull);
      expect(themeData.circlePercentageLowPercentTheme, isNotNull);
      expect(themeData.circlePercentageMediumPercentTheme, isNotNull);
      expect(themeData.circlePercentageHighPercentTheme, isNotNull);
    },
  );

  test(
    'Creates the theme with the default metric widgets theme data if nulls are passed',
    () {
      const themeData = MetricsThemeData(
        circlePercentageHighPercentTheme: null,
        circlePercentageLowPercentTheme: null,
        circlePercentageMediumPercentTheme: null,
        metricWidgetTheme: null,
        buildResultTheme: null,
      );

      expect(themeData.circlePercentageLowPercentTheme, isNotNull);
      expect(themeData.circlePercentageMediumPercentTheme, isNotNull);
      expect(themeData.circlePercentageHighPercentTheme, isNotNull);
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
      const circlePercentageHighTheme = MetricWidgetThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
      );
      const circlePercentageMediumTheme = MetricWidgetThemeData(
        primaryColor: Colors.yellow,
        accentColor: Colors.yellow,
        backgroundColor: Colors.yellow,
      );
      const circlePercentageLowTheme = MetricWidgetThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.red,
        backgroundColor: Colors.red,
      );

      const buildResultsTheme = BuildResultsThemeData(
        successfulColor: primaryColor,
        failedColor: accentColor,
        canceledColor: backgroundColor,
      );

      const themeData = MetricsThemeData();

      final copiedTheme = themeData.copyWith(
        metricWidgetTheme: sparklineTheme,
        circlePercentageHighPercentTheme: circlePercentageHighTheme,
        circlePercentageMediumPercentTheme: circlePercentageMediumTheme,
        circlePercentageLowPercentTheme: circlePercentageLowTheme,
        barGraphBackgroundColor: backgroundColor,
        buildResultTheme: buildResultsTheme,
      );

      expect(copiedTheme.circlePercentageLowPercentTheme,
          circlePercentageLowTheme);
      expect(copiedTheme.circlePercentageMediumPercentTheme,
          circlePercentageMediumTheme);
      expect(copiedTheme.circlePercentageHighPercentTheme,
          circlePercentageHighTheme);
      expect(copiedTheme.metricWidgetTheme, sparklineTheme);
      expect(copiedTheme.buildResultTheme, buildResultsTheme);
      expect(copiedTheme.barGraphBackgroundColor, backgroundColor);
    },
  );

  test(
    "Creates new instance with the same filed if copyWith was used widhout any params",
    () {
      const themeData = MetricsThemeData();
      final copiedTheme = themeData.copyWith();

      expect(themeData, isNot(copiedTheme));
      expect(
        themeData.barGraphBackgroundColor,
        copiedTheme.barGraphBackgroundColor,
      );
      expect(
        themeData.metricWidgetTheme,
        copiedTheme.metricWidgetTheme,
      );
      expect(
        themeData.circlePercentageHighPercentTheme,
        copiedTheme.circlePercentageHighPercentTheme,
      );
      expect(
        themeData.circlePercentageMediumPercentTheme,
        copiedTheme.circlePercentageMediumPercentTheme,
      );
      expect(
        themeData.circlePercentageLowPercentTheme,
        copiedTheme.circlePercentageLowPercentTheme,
      );
      expect(
        themeData.buildResultTheme,
        copiedTheme.buildResultTheme,
      );
    },
  );
}
