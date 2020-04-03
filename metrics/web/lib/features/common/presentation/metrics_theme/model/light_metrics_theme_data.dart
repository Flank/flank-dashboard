import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// Stores the theme data for light metrics theme.
class LightMetricsThemeData extends MetricsThemeData {
  /// Creates the light theme with the default widget theme configuration.
  const LightMetricsThemeData()
      : super(
          circlePercentageHighPercentTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.primaryTranslucentColor,
          ),
          circlePercentageLowPercentTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.accentColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.accentTranslucentColor,
          ),
          circlePercentageMediumPercentTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.yellow,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.yellowTranslucent,
          ),
          metricWidgetTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: ColorConfig.primaryTranslucentColor,
            backgroundColor: Colors.white,
            textStyle: TextStyle(color: ColorConfig.primaryColor),
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: ColorConfig.accentColor,
            successfulColor: ColorConfig.primaryColor,
            failedColor: ColorConfig.accentColor,
          ),
          inactiveWidgetTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.lightInactiveColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.lightInactiveBackgroundColor,
            textStyle: TextStyle(color: Colors.grey),
          ),
        );
}
