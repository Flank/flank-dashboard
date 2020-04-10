// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:test/test.dart';

void main() {
  const circlePercentagePrimaryTheme = MetricWidgetThemeData(
    primaryColor: ColorConfig.primaryColor,
    accentColor: Colors.transparent,
    backgroundColor: ColorConfig.primaryTranslucentColor,
  );

  const circlePercentageAccentTheme = MetricWidgetThemeData(
    primaryColor: ColorConfig.accentColor,
    accentColor: Colors.transparent,
    backgroundColor: ColorConfig.accentTranslucentColor,
  );

  const sparklineTheme = MetricWidgetThemeData(
    primaryColor: ColorConfig.primaryColor,
    accentColor: ColorConfig.primaryColor,
    backgroundColor: ColorConfig.darkGrey,
  );

  const buildResultTheme = BuildResultsThemeData(
    canceledColor: ColorConfig.accentColor,
    successfulColor: ColorConfig.primaryColor,
    failedColor: ColorConfig.accentColor,
  );

  test('Creates LightMetricsThemeData variation theme', () {
    final darkMetricsThemeData = DarkMetricsThemeData();

    expect(darkMetricsThemeData.circlePercentagePrimaryTheme,
        equals(circlePercentagePrimaryTheme));
    expect(darkMetricsThemeData.circlePercentageAccentTheme,
        equals(circlePercentageAccentTheme));
    expect(darkMetricsThemeData.sparklineTheme, equals(sparklineTheme));
    expect(darkMetricsThemeData.buildResultTheme, equals(buildResultTheme));
  });
}
