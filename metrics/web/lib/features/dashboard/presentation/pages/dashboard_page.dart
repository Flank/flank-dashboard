import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Shows the available projects and metrics for these projects.
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    Injector.getAsReactive<ProjectMetricsStore>().setState(
      (store) => store.subscribeToProjects(),
      catchError: true,
    );
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
