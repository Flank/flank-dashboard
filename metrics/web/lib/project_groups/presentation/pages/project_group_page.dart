import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card_list.dart';

class ProjectGroupPage extends StatefulWidget {
  @override
  _ProjectGroupPageState createState() => _ProjectGroupPageState();
}

class _ProjectGroupPageState extends State<ProjectGroupPage> {
  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 124.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                ProjectGroupsStrings.projectGroups,
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            Expanded(
              child: ProjectGroupCardList(),
            ),
          ],
        ),
      ),
    );
  }
}
