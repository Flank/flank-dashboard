import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';

/// Stores the theme data for all metric widgets.
class MetricsThemeData {
  static const MetricWidgetThemeData _defaultWidgetThemeData =
      MetricWidgetThemeData();

  final MetricWidgetThemeData circlePercentageHighPercentTheme;
  final MetricWidgetThemeData circlePercentageMediumPercentTheme;
  final MetricWidgetThemeData circlePercentageLowPercentTheme;
  final MetricWidgetThemeData metricWidgetTheme;
  final MetricWidgetThemeData inactiveWidgetTheme;
  final BuildResultsThemeData buildResultTheme;
  final Color barGraphBackgroundColor;

  /// Creates the [MetricsThemeData].
  ///
  /// [circlePercentageHighPercentTheme] is the theme of the [CirclePercentage] widget
  /// with high percent value.
  ///
  /// [circlePercentageMediumPercentTheme] is the theme of the [CirclePercentage] widget
  /// with medium percent value.
  ///
  /// [circlePercentageLowPercentTheme] is the theme of the [CirclePercentage] widget
  /// with low percent value.
  ///
  /// [metricWidgetTheme] is the color theme of the [SparklineGraph].
  /// Used to set the default colors to the [SparklineGraph].
  ///
  /// [inactiveWidgetTheme] is the color theme of the inactive metric widgets.
  /// This theme is used when there are no data for metric.
  ///
  /// [buildResultTheme] is the color theme for the [BuildResultBarGraph].
  /// Used to set the colors of the graph bars.
  const MetricsThemeData({
    MetricWidgetThemeData circlePercentageHighPercentTheme,
    MetricWidgetThemeData circlePercentageMediumPercentTheme,
    MetricWidgetThemeData circlePercentageLowPercentTheme,
    MetricWidgetThemeData metricWidgetTheme,
    MetricWidgetThemeData inactiveWidgetTheme,
    BuildResultsThemeData buildResultTheme,
    this.barGraphBackgroundColor,
  })  : circlePercentageHighPercentTheme =
            circlePercentageHighPercentTheme ?? _defaultWidgetThemeData,
        circlePercentageMediumPercentTheme =
            circlePercentageMediumPercentTheme ?? _defaultWidgetThemeData,
        circlePercentageLowPercentTheme =
            circlePercentageLowPercentTheme ?? _defaultWidgetThemeData,
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
    MetricWidgetThemeData circlePercentageHighPercentTheme,
    MetricWidgetThemeData circlePercentageMediumPercentTheme,
    MetricWidgetThemeData circlePercentageLowPercentTheme,
    MetricWidgetThemeData metricWidgetTheme,
    BuildResultsThemeData buildResultTheme,
    Color barGraphBackgroundColor,
  }) {
    return MetricsThemeData(
      circlePercentageHighPercentTheme: circlePercentageHighPercentTheme ??
          this.circlePercentageHighPercentTheme,
      circlePercentageMediumPercentTheme: circlePercentageMediumPercentTheme ??
          this.circlePercentageMediumPercentTheme,
      circlePercentageLowPercentTheme: circlePercentageLowPercentTheme ??
          this.circlePercentageLowPercentTheme,
      metricWidgetTheme: metricWidgetTheme ?? this.metricWidgetTheme,
      buildResultTheme: buildResultTheme ?? this.buildResultTheme,
      barGraphBackgroundColor:
          barGraphBackgroundColor ?? this.barGraphBackgroundColor,
    );
  }
}
