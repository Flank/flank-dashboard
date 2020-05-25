import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';

class ProjectGroupCardList extends StatefulWidget {
  @override
  _ProjectGroupCardListState createState() => _ProjectGroupCardListState();
}

class _ProjectGroupCardListState extends State<ProjectGroupCardList> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0, // gap between adjacent chips
      runSpacing: 16.0, // gap between lines
      children: const <Widget>[
        ProjectGroupCard(
          projectGroupName: 'AndroidAndroidAndroidAndroidAndroidAndroidAndroidAndroid',
          projectsCount: 0,
        ),
        ProjectGroupCard(
          projectGroupName: 'IOS',
          projectsCount: 3,
        ),
      ],
    );
  }
}
