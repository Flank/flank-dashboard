import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// Stores the theme data for light metrics theme.
class LightMetricsThemeData extends MetricsThemeData {
  static const Color _primaryThemeColor = Color(0xFF489CFF);
  static const Color _accentThemeColor = Color(0xFFC15AFF);

  /// Creates the light theme with the default widget theme configuration.
  const LightMetricsThemeData()
      : super(
          circlePercentagePrimaryTheme: const MetricWidgetThemeData(
            primaryColor: _primaryThemeColor,
            accentColor: Colors.grey,
          ),
          circlePercentageAccentTheme: const MetricWidgetThemeData(
            primaryColor: _accentThemeColor,
            accentColor: Colors.grey,
          ),
          sparklineTheme: const MetricWidgetThemeData(
            primaryColor: _primaryThemeColor,
            accentColor: Color(0x5F489CFF),
            backgroundColor: Color(0xFF3D4F85),
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: Colors.grey,
            successfulColor: Color(0xFF1CD8C2),
            failedColor: Color(0xFFFE2E6E),
          ),
        );
}
