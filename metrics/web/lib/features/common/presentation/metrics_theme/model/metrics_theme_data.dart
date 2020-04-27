import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';

/// Stores the theme data for all metric widgets.
class MetricsThemeData {
  static const MetricWidgetThemeData _defaultWidgetThemeData =
      MetricWidgetThemeData();

  final MetricCirclePercentageThemeData metricCirclePercentageThemeData;
  final MetricWidgetThemeData metricWidgetTheme;
  final MetricWidgetThemeData inactiveWidgetTheme;
  final BuildResultsThemeData buildResultTheme;

  /// Creates the [MetricsThemeData].
  ///
  /// [metricCirclePercentageThemeData] is the theme of the [CirclePercentage].
  ///
  /// [metricWidgetTheme] is the theme of the metrics widgets.
  /// Used to set the default colors and text styles.
  ///
  /// [inactiveWidgetTheme] is the theme of the inactive metric widgets.
  /// This theme is used when there are no data for metric.
  ///
  /// [buildResultTheme] is the theme for the [BuildResultBarGraph].
  /// Used to set the colors of the graph bars.
  const MetricsThemeData({
    MetricCirclePercentageThemeData metricCirclePercentageThemeData,
    MetricWidgetThemeData metricWidgetTheme,
    MetricWidgetThemeData inactiveWidgetTheme,
    BuildResultsThemeData buildResultTheme,
  })  : metricCirclePercentageThemeData = metricCirclePercentageThemeData ??
            const MetricCirclePercentageThemeData(),
        inactiveWidgetTheme = inactiveWidgetTheme ?? _defaultWidgetThemeData,
        metricWidgetTheme = metricWidgetTheme ?? _defaultWidgetThemeData,
        buildResultTheme = buildResultTheme ??
            const BuildResultsThemeData(
              canceledColor: Colors.grey,
              successfulColor: Colors.teal,
              failedColor: Colors.redAccent,
            );

  /// Creates the new instance of the [MetricsThemeData] based on current instance.
  ///
  /// If any of the passed parameters are null, or parameter isn't specified,
  /// the value will be copied from the current instance.
  MetricsThemeData copyWith({
    MetricCirclePercentageThemeData metricCirclePercentageThemeData,
    MetricWidgetThemeData metricWidgetTheme,
    BuildResultsThemeData buildResultTheme,
    Color barGraphBackgroundColor,
  }) {
    return MetricsThemeData(
      metricCirclePercentageThemeData: metricCirclePercentageThemeData ??
          this.metricCirclePercentageThemeData,
      metricWidgetTheme: metricWidgetTheme ?? this.metricWidgetTheme,
      buildResultTheme: buildResultTheme ?? this.buildResultTheme,
    );
  }
}
