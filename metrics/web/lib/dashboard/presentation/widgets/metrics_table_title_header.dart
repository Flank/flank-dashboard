import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

/// A widget that displays a metrics table header with titles of the metrics.
class MetricsTableTitleHeader extends StatelessWidget {
  /// Creates a new instance of the [MetricsTableTitleHeader].
  const MetricsTableTitleHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metricsTableHeaderTheme = MetricsTheme.of(context)
        .projectMetricsTableTheme
        .metricsTableHeaderTheme;
    final textStyle = DefaultTextStyle.of(context)
        .style
        .merge(metricsTableHeaderTheme.textStyle);

    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: textStyle,
      child: MetricsTableRow(
        status: Container(),
        name: Container(),
        buildResults: const Text(DashboardStrings.lastBuilds),
        performance: const Text(DashboardStrings.performance),
        buildNumber: const Text(DashboardStrings.builds),
        stability: const Text(DashboardStrings.stability),
        coverage: const Text(DashboardStrings.coverage),
      ),
    );
  }
}
