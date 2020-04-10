import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:test/test.dart';

void main() {
  const circlePercentagePrimaryTheme = MetricWidgetThemeData(
    primaryColor: ColorConfig.primaryColor,
    accentColor: Colors.transparent,
    backgroundColor: ColorConfig.primaryTranslucentColor,
    titleStyle: TextStyle(color: ColorConfig.primaryColor),
  );

  const circlePercentageAccentTheme = MetricWidgetThemeData(
    primaryColor: ColorConfig.accentColor,
    accentColor: Colors.transparent,
    backgroundColor: ColorConfig.accentTranslucentColor,
    titleStyle: TextStyle(color: ColorConfig.accentColor),
  );

  const sparklineTheme = MetricWidgetThemeData(
    primaryColor: ColorConfig.primaryColor,
    accentColor: ColorConfig.primaryColor,
    backgroundColor: Colors.white,
  );

  const buildResultTheme = BuildResultsThemeData(
    canceledColor: ColorConfig.accentColor,
    successfulColor: ColorConfig.primaryColor,
    failedColor: ColorConfig.accentColor,
  );

  test('Creates LightMetricsThemeData variation theme', () {
    final lightMetricsThemeData = LightMetricsThemeData();

    expect(lightMetricsThemeData.circlePercentagePrimaryTheme,
        equals(circlePercentagePrimaryTheme));
    expect(lightMetricsThemeData.circlePercentageAccentTheme,
        equals(circlePercentageAccentTheme));
    expect(lightMetricsThemeData.sparklineTheme, equals(sparklineTheme));
    expect(lightMetricsThemeData.buildResultTheme, equals(buildResultTheme));
  });
}
