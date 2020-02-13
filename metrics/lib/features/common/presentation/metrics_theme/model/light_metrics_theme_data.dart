import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// Stores the theme data for light metrics theme.
class LightMetricsThemeData extends MetricsThemeData {
  /// Creates the light theme with the default widget theme configuration.
  const LightMetricsThemeData()
      : super(
          circlePercentagePrimaryTheme: const MetricWidgetThemeData(
            primaryColor: Colors.blue,
            accentColor: Colors.grey,
          ),
          circlePercentageAccentTheme: const MetricWidgetThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.grey,
          ),
          spakrlineTheme: const MetricWidgetThemeData(
            primaryColor: Colors.blue,
            accentColor: Colors.blue,
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: Colors.grey,
            successfulColor: Colors.teal,
            failedColor: Colors.redAccent,
          ),
          barGraphBackgroundColor: Colors.white,
        );
}
