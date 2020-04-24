import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/project_metrics_circle_percentage_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';

/// A [CirclePercentage] widget that displays the project metric.
///
/// Applies the theme given by the [themeStrategy].
class ThemedCirclePercentage extends StatelessWidget {
  final CirclePercentageThemeStrategy themeStrategy;
  final double value;

  /// Creates the [ThemedCirclePercentage] with the given [value] and [themeStrategy].
  const ThemedCirclePercentage({
    Key key,
    this.value,
    this.themeStrategy = const CirclePercentageThemeStrategy(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = _getWidgetTheme(context);

    return CirclePercentage(
      value: value,
      valueColor: widgetTheme?.primaryColor,
      strokeColor: widgetTheme?.accentColor,
      backgroundColor: widgetTheme?.backgroundColor,
      valueStyle: widgetTheme?.textStyle,
    );
  }

  /// Gets the [MetricWidgetThemeData] using the [themeStrategy].
  MetricWidgetThemeData _getWidgetTheme(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);

    return themeStrategy?.getWidgetTheme(metricsTheme, value);
  }
}

/// A class that represents the strategy of applying the [MetricWidgetThemeData] to the [ThemedCirclePercentage] widget.
class CirclePercentageThemeStrategy {
  /// Is the lower bound of the [value]
  /// to return the [ProjectMetricsCirclePercentageThemeData.highPercentTheme].
  static const double highPercentBound = 0.8;

  /// Is the lower bound of the [value]
  /// to return the [ProjectMetricsCirclePercentageThemeData.mediumPercentTheme].
  static const double mediumPercentBound = 0.51;

  /// Is the lower bound of the [value]
  /// to return the [ProjectMetricsCirclePercentageThemeData.lowPercentTheme].
  static const double lowPercentBound = 0.0;

  const CirclePercentageThemeStrategy();

  /// Gets the [MetricWidgetThemeData] according to the [value] following the next rules:
  /// * if the [value] is 0, applies the [MetricsThemeData.inactiveWidgetTheme]
  /// * if the [value] is greater than [lowPercentBound] and less than [mediumPercentBound], applies the [ProjectMetricsCirclePercentageThemeData.lowPercentTheme]
  /// * if the [value] is greater than or equal to [mediumPercentBound] and less than [highPercentBound], applies the [ProjectMetricsCirclePercentageThemeData.mediumPercentTheme]
  /// * if the [value] is greater or equal to [highPercentBound], applies the [ProjectMetricsCirclePercentageThemeData.highPercentTheme].
  MetricWidgetThemeData getWidgetTheme(
    MetricsThemeData metricsTheme,
    double value,
  ) {
    final circlePercentageTheme =
        metricsTheme.projectMetricsCirclePercentageTheme;
    final inactiveTheme = metricsTheme.inactiveWidgetTheme;
    final percent = value;

    if (percent == null) return inactiveTheme;

    if (percent >= highPercentBound) {
      return circlePercentageTheme.highPercentTheme;
    } else if (percent >= mediumPercentBound) {
      return circlePercentageTheme.mediumPercentTheme;
    } else if (percent > lowPercentBound) {
      return circlePercentageTheme.lowPercentTheme;
    } else {
      return inactiveTheme;
    }
  }
}
