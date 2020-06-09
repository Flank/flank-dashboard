import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table.dart';
import 'package:metrics/util/debounce.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 124.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: TextField(
                onChanged: (value) {
                  const duration = Duration(milliseconds: 300);

                  Debounce(duration: duration)(
                    () => _projectMetricsNotifier.filterByProjectName(value),
                  );
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: CommonStrings.searchForProject,
                ),
              ),
            ),
            Expanded(
              child: MetricsTable(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectMetricsNotifier.unsubscribeFromBuildMetrics();
    super.dispose();
  }
}
