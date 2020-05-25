import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/data/model/project_group_data.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';

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
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 224.0,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  projectGroupName,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  projectsCount > 0
                      ? ProjectGroupsStrings.getProjectsCount(projectsCount)
                      : ProjectGroupsStrings.noProjects,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ProjectGroupDialog(
                                title: ProjectGroupsStrings.editProjectGroup,
                                projectGroupData: const ProjectGroupData(name: 'Android'),
                              );
                            });
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
