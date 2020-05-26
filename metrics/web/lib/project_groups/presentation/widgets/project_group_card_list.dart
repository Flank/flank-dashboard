import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';

class ProjectGroupCardList extends StatefulWidget {
  @override
  _ProjectGroupCardListState createState() => _ProjectGroupCardListState();
}

class _ProjectGroupCardListState extends State<ProjectGroupCardList> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2.0,
      ),
      children: const <Widget>[
        ProjectGroupCard(
          projectGroupName:
              'AndroidAndroidAndroidAndroidAndroidAndroidAndroidAndroid',
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
