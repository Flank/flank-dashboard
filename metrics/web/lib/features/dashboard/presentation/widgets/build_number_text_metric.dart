import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/text_metric.dart';

/// Widget that displays the [TextMetric] with the build number metric.
///
/// Applies the text styles from the [MetricsThemeData.metricWidgetTheme].
/// If the [buildNumberMetric] is equals to 0 applies the text styles
/// from [MetricsThemeData.inactiveWidgetTheme].
class BuildNumberTextMetric extends StatelessWidget {
  final int buildNumberMetric;

  /// Creates the [BuildNumberTextMetric] with the given [buildNumberMetric].
  const BuildNumberTextMetric({
    Key key,
    @required this.buildNumberMetric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = _getWidgetTheme(context);

    return TextMetric(
      value: '$buildNumberMetric',
      description: '/ week',
      descriptionStyle: widgetTheme.textStyle,
      valueStyle: widgetTheme.textStyle,
    );
  }

  MetricWidgetThemeData _getWidgetTheme(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);

    if (buildNumberMetric == 0) return metricsTheme.inactiveWidgetTheme;

    return metricsTheme.metricWidgetTheme;
  }
}
