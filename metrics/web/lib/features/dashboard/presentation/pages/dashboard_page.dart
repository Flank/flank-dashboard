import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/features/dashboard/presentation/widgets/dashboard_table.dart';

/// Shows the metric table with available projects and metrics for these projects.
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: DashboardTable(),
      ),
    );
  }
}
