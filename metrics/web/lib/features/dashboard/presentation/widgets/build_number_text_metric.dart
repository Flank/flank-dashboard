import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_text.dart';
import 'package:metrics/features/dashboard/presentation/widgets/text_metric.dart';

/// Widget that displays the [TextMetric] with the build number metric.
///
/// Applies the text styles from the [MetricsThemeData.metricWidgetTheme].
/// If the [buildNumberMetric] is equals to 0 or is `null` - displays the [PlaceholderText]
/// and applies the text styles from [MetricsThemeData.inactiveWidgetTheme] to it.
class BuildNumberTextMetric extends StatelessWidget {
  final int buildNumberMetric;

  /// Creates the [BuildNumberTextMetric] with the given [buildNumberMetric].
  const BuildNumberTextMetric({
    Key key,
    this.buildNumberMetric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = MetricsTheme.of(context).metricWidgetTheme;

    if (buildNumberMetric == null || buildNumberMetric == 0) {
      return const PlaceholderText();
    }

    return TextMetric(
      value: '$buildNumberMetric',
      description: DashboardStrings.perWeek,
      descriptionStyle: widgetTheme.textStyle,
      valueStyle: widgetTheme.textStyle,
    );
  }
}
