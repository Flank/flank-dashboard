import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table.dart';
import 'package:provider/provider.dart';

/// Allows to quickly get primary metrics of all available projects.
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// A [ProjectMetricsNotifier] needed to unsubscribe from project updates in [dispose].
  ProjectMetricsNotifier _projectMetricsNotifier;

  @override
  void initState() {
    super.initState();
    _projectMetricsNotifier =
        Provider.of<ProjectMetricsNotifier>(context, listen: false);

    _projectMetricsNotifier.subscribeToProjectsNameFilter();
  }

  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: TextField(
              onChanged: _projectMetricsNotifier.filterByProjectName,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: CommonStrings.searchForProject,
              ),
            ),
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
