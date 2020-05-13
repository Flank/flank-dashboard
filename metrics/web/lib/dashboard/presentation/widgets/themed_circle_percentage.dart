import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/circle_percentage.dart';

/// A [CirclePercentage] widget that applies the given [ValueBasedThemeStrategy].
class ThemedCirclePercentage extends StatelessWidget {
  final ValueBasedThemeStrategy themeStrategy;
  final double value;

  /// Creates the [ThemedCirclePercentage] with the given [value] and [themeStrategy].
  const ThemedCirclePercentage({
    Key key,
    this.value,
    @required this.themeStrategy,
  })  : assert(themeStrategy != null),
        super(key: key);

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
