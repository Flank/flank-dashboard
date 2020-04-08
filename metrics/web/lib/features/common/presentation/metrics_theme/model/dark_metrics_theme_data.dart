import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// Stores the theme data for dark metrics theme.
class DarkMetricsThemeData extends MetricsThemeData {
  /// Creates the dark theme with the default widget theme configuration.
  const DarkMetricsThemeData()
      : super(
          circlePercentageHighPercentTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.primaryTranslucentColor,
            textStyle: TextStyle(
              color: ColorConfig.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          circlePercentageLowPercentTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.accentColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.accentTranslucentColor,
            textStyle: TextStyle(
              color: ColorConfig.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          circlePercentageMediumPercentTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.yellow,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.yellowTranslucent,
            textStyle: TextStyle(
              color: ColorConfig.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          metricWidgetTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: ColorConfig.primaryTranslucentColor,
            backgroundColor: ColorConfig.darkScaffoldColor,
            textStyle: TextStyle(
              color: ColorConfig.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: ColorConfig.accentColor,
            successfulColor: ColorConfig.primaryColor,
            failedColor: ColorConfig.accentColor,
          ),
          inactiveWidgetTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.darkInactiveColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.darkInactiveBackgroundColor,
            textStyle: TextStyle(
                color: ColorConfig.darkInactiveColor,
                fontSize: 32.0,
                fontWeight: FontWeight.bold),
          ),
        );
}
