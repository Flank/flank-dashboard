import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table.dart';
import 'package:provider/provider.dart';

/// Allows to quickly get primary metrics of all available projects.
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    Provider.of<ProjectMetricsNotifier>(context, listen: false)
        .subscribeToProjects();
    super.initState();
  }

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
