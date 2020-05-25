import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/components/project_group_dialog.dart';

class AddProjectGroupDialog extends StatefulWidget {
  @override
  _AddProjectGroupDialogState createState() => _AddProjectGroupDialogState();
}

class _AddProjectGroupDialogState extends State<AddProjectGroupDialog> {
  @override
  Widget build(BuildContext context) {
    return const ProjectGroupDialog(
      title: ProjectGroupsStrings.addProjectGroup,
    );
  }
}
