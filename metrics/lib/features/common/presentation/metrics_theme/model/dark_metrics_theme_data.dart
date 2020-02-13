import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// Stores the theme data for dark metrics theme.
class DarkMetricsThemeData extends MetricsThemeData {
  /// Creates the dark theme with the default widget theme configuration.
  const DarkMetricsThemeData()
      : super(
          circlePercentagePrimaryTheme: const MetricWidgetThemeData(
            primaryColor: Colors.green,
            accentColor: Colors.transparent,
            backgroundColor: Color(0x5F4CAF50),
          ),
          circlePercentageAccentTheme: const MetricWidgetThemeData(
            primaryColor: Colors.red,
            accentColor: Colors.transparent,
            backgroundColor: Color(0x5FF44336),
          ),
          spakrlineTheme: const MetricWidgetThemeData(
            primaryColor: Colors.green,
            accentColor: Colors.green,
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: Colors.orange,
            successfulColor: Colors.teal,
            failedColor: Colors.red,
          ),
          barGraphBackgroundColor: Colors.white,
        );
}
