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
          circlePercentagePrimaryTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.primaryTranslucentColor,
          ),
          circlePercentageAccentTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.accentColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.accentTranslucentColor,
          ),
          sparklineTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: ColorConfig.primaryColor,
            backgroundColor: Colors.transparent,
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: Colors.grey,
            successfulColor: ColorConfig.primaryColor,
            failedColor: ColorConfig.accentColor,
          ),
        );
}
