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
      expect(themeData.spakrlineTheme, isNotNull);
      expect(themeData.circlePercentagePrimaryTheme, isNotNull);
      expect(themeData.circlePercentageAccentTheme, isNotNull);
    },
  );

  test(
    'Creates the theme with the default metric widgets theme data if nulls are passed',
    () {
      const themeData = MetricsThemeData(
        circlePercentagePrimaryTheme: null,
        circlePercentageAccentTheme: null,
        spakrlineTheme: null,
        buildResultTheme: null,
      );

      expect(themeData.circlePercentagePrimaryTheme, isNotNull);
      expect(themeData.circlePercentageAccentTheme, isNotNull);
      expect(themeData.spakrlineTheme, isNotNull);
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
      const circlePercentageTheme = MetricWidgetThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
      );

      const buildResultsTheme = BuildResultsThemeData(
        successfulColor: primaryColor,
        failedColor: accentColor,
        canceledColor: backgroundColor,
      );

      const themeData = MetricsThemeData();

      final copiedTheme = themeData.copyWith(
        spakrlineTheme: sparklineTheme,
        circlePercentageAccentTheme: circlePercentageTheme,
        circlePercentagePrimaryTheme: circlePercentageTheme,
        barGraphBackgroundColor: backgroundColor,
        buildResultTheme: buildResultsTheme,
      );

      expect(copiedTheme.circlePercentagePrimaryTheme, circlePercentageTheme);
      expect(copiedTheme.circlePercentageAccentTheme, circlePercentageTheme);
      expect(copiedTheme.spakrlineTheme, sparklineTheme);
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
        themeData.spakrlineTheme,
        copiedTheme.spakrlineTheme,
      );
      expect(
        themeData.circlePercentagePrimaryTheme,
        copiedTheme.circlePercentagePrimaryTheme,
      );
      expect(
        themeData.circlePercentageAccentTheme,
        copiedTheme.circlePercentageAccentTheme,
      );
      expect(
        themeData.buildResultTheme,
        copiedTheme.buildResultTheme,
      );
    },
  );
}
