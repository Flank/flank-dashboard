import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table.dart';
import 'package:metrics/dashboard/presentation/widgets/projects_search_input.dart';
import 'package:provider/provider.dart';

/// The widget that allows to quickly get primary metrics
/// of all available projects.
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// A [ProjectMetricsNotifier] needed to unsubscribe from project
  /// metrics in [dispose].
  ProjectMetricsNotifier _projectMetricsNotifier;

  @override
  void initState() {
    super.initState();
    _projectMetricsNotifier =
        Provider.of<ProjectMetricsNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ProjectSearchInput(
                onChanged: _projectMetricsNotifier.filterByProjectName),
          ),
          Expanded(
            child: MetricsTable(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _projectMetricsNotifier.unsubscribeFromBuildMetrics();
    super.dispose();
  }
}
