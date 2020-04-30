import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table.dart';

/// Shows the available projects and metrics for these projects.
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 124.0),
        child: MetricsTable(),
      ),
    );
  }
}
