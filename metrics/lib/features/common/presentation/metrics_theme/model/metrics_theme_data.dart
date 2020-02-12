import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';

/// Stores the theme data for all metric widgets.
class MetricsThemeData {
  static const MetricWidgetThemeData _defaultWidgetThemeData =
      MetricWidgetThemeData();

  final MetricWidgetThemeData circlePercentagePrimaryTheme;
  final MetricWidgetThemeData circlePercentageAccentTheme;
  final MetricWidgetThemeData spakrlineTheme;
  final BuildResultsThemeData buildResultTheme;
  final Color barGraphBackgroundColor;

  /// Creates the [MetricsThemeData].
  ///
  /// [circlePercentagePrimaryTheme] is the theme of
  /// main [CirclePercentage] widget.
  /// Used to set the default colors to the [CirclePercentage] widget.
  ///
  /// [circlePercentageAccentTheme] is the theme of
  /// the additional [CirclePercentage] widget.
  /// Used to create the additional color configuration
  /// for the [CirclePercentage] widget.
  ///
  /// [spakrlineTheme] is the color theme of the [SparklineGraph].
  /// Used to set the default colors to the [SparklineGraph].
  ///
  /// [buildResultThemeData] is the color theme for the [BuildResultBarGraph].
  /// Used to set the colors of the graph bars.
  const MetricsThemeData({
    MetricWidgetThemeData circlePercentagePrimaryTheme,
    MetricWidgetThemeData circlePercentageAccentTheme,
    MetricWidgetThemeData spakrlineTheme,
    BuildResultsThemeData buildResultThemeData,
    this.barGraphBackgroundColor,
  })  : circlePercentageAccentTheme =
            circlePercentageAccentTheme ?? _defaultWidgetThemeData,
        circlePercentagePrimaryTheme =
            circlePercentagePrimaryTheme ?? _defaultWidgetThemeData,
        spakrlineTheme = spakrlineTheme ?? _defaultWidgetThemeData,
        buildResultTheme =
            buildResultThemeData ?? const BuildResultsThemeData.light();

  /// Creates the light theme with the default widget theme configuration.
  const MetricsThemeData.light()
      : circlePercentagePrimaryTheme = const MetricWidgetThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.grey,
        ),
        circlePercentageAccentTheme = const MetricWidgetThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.grey,
        ),
        spakrlineTheme = const MetricWidgetThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.blue,
        ),
        buildResultTheme = const BuildResultsThemeData.light(),
        barGraphBackgroundColor = Colors.white;

  /// Creates the dark theme with the default widget theme configuration.
  const MetricsThemeData.dark()
      : circlePercentagePrimaryTheme = const MetricWidgetThemeData(
            primaryColor: Colors.green,
            accentColor: Colors.transparent,
            backgroundColor: Color(0x5F4CAF50)),
        circlePercentageAccentTheme = const MetricWidgetThemeData(
            primaryColor: Colors.red,
            accentColor: Colors.transparent,
            backgroundColor: Color(0x5FF44336)),
        spakrlineTheme = const MetricWidgetThemeData(
          primaryColor: Colors.green,
          accentColor: Colors.green,
        ),
        buildResultTheme = const BuildResultsThemeData.dark(),
        barGraphBackgroundColor = Colors.white;

  /// Creates the new instance of the [MetricsThemeData] based on current instance.
  ///
  /// If any of the passed parameters are null, or parameter isn't specified,
  /// the value will be copied from the current instance.
  MetricsThemeData copyWith({
    MetricWidgetThemeData circlePercentagePrimaryTheme,
    MetricWidgetThemeData circlePercentageAccentTheme,
    MetricWidgetThemeData spakrlineTheme,
    BuildResultsThemeData buildResultTheme,
    Color barGraphBackgroundColor,
  }) {
    return MetricsThemeData(
      circlePercentagePrimaryTheme:
          circlePercentagePrimaryTheme ?? this.circlePercentagePrimaryTheme,
      circlePercentageAccentTheme:
          circlePercentageAccentTheme ?? this.circlePercentageAccentTheme,
      spakrlineTheme: spakrlineTheme ?? this.spakrlineTheme,
      buildResultThemeData: buildResultTheme ?? this.buildResultTheme,
      barGraphBackgroundColor:
          barGraphBackgroundColor ?? this.barGraphBackgroundColor,
    );
  }
}
