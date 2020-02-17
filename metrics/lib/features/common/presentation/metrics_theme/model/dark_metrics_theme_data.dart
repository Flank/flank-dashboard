import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// Stores the theme data for dark metrics theme.
class DarkMetricsThemeData extends MetricsThemeData {
  static const Color _primaryThemeColor = Color(0xFF20CE9A);
  static const Color _accentThemeColor = Color(0xFFF45531);

  /// Creates the dark theme with the default widget theme configuration.
  const DarkMetricsThemeData()
      : super(
          circlePercentagePrimaryTheme: const MetricWidgetThemeData(
            primaryColor: _primaryThemeColor,
            accentColor: Colors.transparent,
            backgroundColor: Color(0x1F20CE9A),
          ),
          circlePercentageAccentTheme: const MetricWidgetThemeData(
            primaryColor: _accentThemeColor,
            accentColor: Colors.transparent,
            backgroundColor: Color(0x1FF45531),
          ),
          sparklineTheme: const MetricWidgetThemeData(
            primaryColor: _primaryThemeColor,
            accentColor: _primaryThemeColor,
            backgroundColor: Colors.transparent,
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: Colors.grey,
            successfulColor: _primaryThemeColor,
            failedColor: _accentThemeColor,
          ),
        );
}
