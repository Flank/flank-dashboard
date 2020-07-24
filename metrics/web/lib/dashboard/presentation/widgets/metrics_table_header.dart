import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

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
      child: MetricsTableRow(
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
