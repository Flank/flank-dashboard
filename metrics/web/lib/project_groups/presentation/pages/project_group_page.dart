import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_view.dart';

/// A page that displays the list of [ProjectGroup]s and provides an ability
/// to add a new [ProjectGroup].
class ProjectGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      title: CommonStrings.projectGroups,
      padding: const EdgeInsets.only(top: 40.0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProjectGroupView(),
          ],
        ),
      ),
    );
  }
}
