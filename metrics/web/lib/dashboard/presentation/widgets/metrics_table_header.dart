import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_tile.dart';

/// Widget that displays the header of the metrics table.
class MetricsTableHeader extends StatelessWidget {
  const MetricsTableHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF79858b),
        fontWeight: FontWeight.w200,
      ),
      child: MetricsTableTile(
        leading: Container(),
        buildResultsColumn: Text(DashboardStrings.lastBuilds),
        performanceColumn: const Text(DashboardStrings.performance),
        buildNumberColumn: const Text(DashboardStrings.builds),
        stabilityColumn: const Text(DashboardStrings.stability),
        coverageColumn: const Text(DashboardStrings.coverage),
      ),
    );
  }
}
