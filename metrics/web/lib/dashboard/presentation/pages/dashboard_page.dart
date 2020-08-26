import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_menu.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_search_input.dart';

/// The widget that allows to quickly get primary metrics
/// of all available projects.
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: ProjectMetricsSearchInput(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: ProjectGroupsDropdownMenu(),
                ),
              ],
            ),
          ),
          Expanded(
            child: MetricsTable(),
          ),
        ],
      ),
    );
  }
}
