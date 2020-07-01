import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_view.dart';
import 'package:provider/provider.dart';

/// A page that displays the list of [ProjectGroup]s and provides an ability
/// to add a new [ProjectGroup].
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
      bodyTitle: ProjectGroupsStrings.projectGroups,
      padding: const EdgeInsets.only(top: 40.0),
      body: SingleChildScrollView(
        child: ProjectGroupView(),
      ),
    );
  }

  @override
  void dispose() {
    _projectGroupsNotifier.unsubscribeFromProjectGroups();
    super.dispose();
  }
}
