import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/tooltip_icon/widgets/tooltip_icon.dart';
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
    const padding = EdgeInsets.only(right: 4.0);
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
        buildResults: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Flexible(
              child: Padding(
                padding: padding,
                child: Text(DashboardStrings.lastBuilds),
              ),
            ),
            TooltipIcon(tooltip: DashboardStrings.lastBuildsDescription),
          ],
        ),
        performance: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Flexible(
              child: Padding(
                padding: padding,
                child: Text(DashboardStrings.performance),
              ),
            ),
            TooltipIcon(tooltip: DashboardStrings.performanceDescription),
          ],
        ),
        buildNumber: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Flexible(
              child: Padding(
                padding: padding,
                child: Text(DashboardStrings.builds),
              ),
            ),
            TooltipIcon(tooltip: DashboardStrings.buildsDescription),
          ],
        ),
        stability: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Flexible(
              child: Padding(
                padding: padding,
                child: Text(DashboardStrings.stability),
              ),
            ),
            TooltipIcon(tooltip: DashboardStrings.stabilityDescription),
          ],
        ),
        coverage: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Flexible(
              child: Padding(
                padding: padding,
                child: Text(DashboardStrings.coverage),
              ),
            ),
            TooltipIcon(tooltip: DashboardStrings.coverageDescription),
          ],
        ),
      ),
    );
  }
}
