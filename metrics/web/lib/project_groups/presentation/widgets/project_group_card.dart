import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/components/card_container.dart';
import 'package:metrics/project_groups/presentation/widgets/delete_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/edit_project_group_dialog.dart';

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
    return CardContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildProjectGroupName(),
            const SizedBox(height: 8.0),
            _buildProjectsCount(),
            const Spacer(),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildButton(Icons.edit, CommonStrings.edit, () async {
                  await showDialog(
                    context: context,
                    child: EditProjectGroupDialog(),
                  );
                }),
                const SizedBox(width: 20.0),
                _buildButton(Icons.delete, CommonStrings.delete, () async {
                  await showDialog(
                    context: context,
                    child: DeleteProjectGroupDialog(),
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectGroupName() {
    return Text(
      projectGroupName,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24.0,
      ),
    );
  }

  Widget _buildProjectsCount() {
    return Text(
      projectsCount > 0
          ? ProjectGroupsStrings.getProjectsCount(projectsCount)
          : ProjectGroupsStrings.noProjects,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
    );
  }

  Widget _buildButton(
    IconData icon,
    String text,
    VoidCallback onPressed,
  ) {
    return FlatButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
