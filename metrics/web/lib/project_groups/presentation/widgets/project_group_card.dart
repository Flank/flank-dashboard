import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';
import 'package:metrics/project_groups/data/model/project_group_data.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:provider/provider.dart';

class ProjectGroupCard extends StatelessWidget {
  final String projectGroupName;
  final int projectsCount;

  const ProjectGroupCard({
    Key key,
    this.projectGroupName,
    this.projectsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MetricsCard(
      backgroundColor:
          themeNotifier.isDark ? Colors.grey[900] : Colors.grey[200],
      padding: const EdgeInsets.all(16.0),
      elevation: 0.0,
      title: Text(
        projectGroupName,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 1,
        style: const TextStyle(fontSize: 24.0),
      ),
      titlePadding: const EdgeInsets.all(8.0),
      subtitle: Text(projectsCount > 0
          ? ProjectGroupsStrings.getProjectsCount(projectsCount)
          : ProjectGroupsStrings.noProjects),
      subtitlePadding: const EdgeInsets.all(8.0),
      actionsPadding: const EdgeInsets.only(top: 24.0),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const ProjectGroupDialog(
                  projectGroupData: ProjectGroupData(name: 'Android'),
                );
              },
            );
          },
          icon: Icon(Icons.edit),
          label: const Text(CommonStrings.edit),
        ),
        FlatButton.icon(
          onPressed: () {},
          icon: Icon(Icons.delete_outline),
          label: const Text(CommonStrings.delete),
        ),
      ],
    );
  }
}
