import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card_grid_view.dart';
import 'package:provider/provider.dart';

class ProjectGroupPage extends StatefulWidget {
  @override
  _ProjectGroupPageState createState() => _ProjectGroupPageState();
}

class _ProjectGroupPageState extends State<ProjectGroupPage> {
  /// A [ProjectGroupsNotifier] needed to unsubscribe from project groups
  /// updates in [dispose].
  ProjectGroupsNotifier _projectGroupsNotifier;

  @override
  void initState() {
    super.initState();

    _projectGroupsNotifier =
        Provider.of<ProjectGroupsNotifier>(context, listen: false);

    _projectGroupsNotifier.subscribeToProjectGroups();
  }

  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 124.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                ProjectGroupsStrings.projectGroups,
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            Expanded(
              child: ProjectGroupCardGridView(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectGroupsNotifier.unsubscribeFromProjectGroups();

    super.dispose();
  }
}
