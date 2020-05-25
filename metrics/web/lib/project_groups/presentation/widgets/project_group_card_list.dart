import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';

class ProjectGroupCardList extends StatefulWidget {
  @override
  _ProjectGroupCardListState createState() => _ProjectGroupCardListState();
}

class _ProjectGroupCardListState extends State<ProjectGroupCardList> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 20.0,
      children: <Widget>[
        const ProjectGroupCard(
          projectGroupName: 'Android',
          projectsCount: 0,
        ),
        const ProjectGroupCard(
          projectGroupName: 'IOS',
          projectsCount: 3,
        ),
        AddProjectGroupCard(),
      ],
    );
  }
}
