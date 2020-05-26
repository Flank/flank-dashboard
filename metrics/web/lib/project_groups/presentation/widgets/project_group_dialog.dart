import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/clearable_text_field.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/project_search_input.dart';
import 'package:metrics/project_groups/data/model/project_group_data.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:provider/provider.dart';

import '../state/project_groups_notifier.dart';

class ProjectGroupDialog extends StatefulWidget {
  final ProjectGroupData projectGroupData;

  const ProjectGroupDialog({
    this.projectGroupData,
  });

  @override
  _ProjectGroupDialogState createState() => _ProjectGroupDialogState();
}

class _ProjectGroupDialogState extends State<ProjectGroupDialog> {
  final TextEditingController groupNameController = TextEditingController();
  ProjectMetricsNotifier _projectMetricsNotifier;
  final List<String> projectIds = [];

  @override
  void initState() {
    super.initState();

    groupNameController.text = widget.projectGroupData?.name;

    groupNameController.addListener(() {
      setState(() {});
    });

    _projectMetricsNotifier =
        Provider.of<ProjectMetricsNotifier>(context, listen: false);

    _projectMetricsNotifier.subscribeToProjects();
  }

  @override
  Widget build(BuildContext context) {
    return MetricsDialog(
      padding: const EdgeInsets.all(32.0),
      maxWidth: 500.0,
      title: Text(
        widget.projectGroupData == null
            ? ProjectGroupsStrings.addProjectGroup
            : ProjectGroupsStrings.editProjectGroup,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 12.0),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClearableTextField(
            label: ProjectGroupsStrings.nameYourStrings,
            controller: groupNameController,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(ProjectGroupsStrings.chooseProjectToAdd),
          ),
          Container(
            height: 250.0,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Column(
              children: <Widget>[
                ProjectSearchInput(),
                Flexible(
                  child: Consumer<ProjectMetricsNotifier>(
                    builder: (_, projectsMetricsNotifier, __) {
                      if (projectsMetricsNotifier.errorMessage != null) {
                        return Container(); //error loading
                      }

                      final projects = projectsMetricsNotifier.projectsMetrics;

                      if (projects == null) return Container(); // no projects

                      if (projects.isEmpty) {
                        return Container(); // empty projects
                        // return const _DashboardTablePlaceholder(
                        //   text: DashboardStrings.noConfiguredProjects,
                        // );
                      }

                      return ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return CheckboxListTile(
                            title: Text(
                              project.projectName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: projectIds.contains(project.projectId),
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  projectIds.add(project.projectId);
                                } else {
                                  projectIds.remove(project.projectId);
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Text(
            projectIds.isNotEmpty
                ? ProjectGroupsStrings.getSelectedCount(projectIds.length)
                : '',
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
      actions: <Widget>[
        Container(
          height: 50.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: () async {
              final projectGroupNotifier =
                  Provider.of<ProjectGroupsNotifier>(context, listen: false);
              await projectGroupNotifier.saveProjectGroups(
                widget.projectGroupData?.id,
                groupNameController.text,
                projectIds,
              );
              Navigator.pop(context);
            },
            child: Text(
              widget.projectGroupData == null
                  ? ProjectGroupsStrings.createGroup
                  : ProjectGroupsStrings.saveChanges,
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(vertical: 12.0),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }
}
