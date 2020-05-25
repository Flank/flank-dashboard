import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/components/project_group_dialog.dart';

class EditProjectGroupDialog extends StatefulWidget {
  @override
  _EditProjectGroupDialogState createState() => _EditProjectGroupDialogState();
}

class _EditProjectGroupDialogState extends State<EditProjectGroupDialog> {
  @override
  Widget build(BuildContext context) {
    return const ProjectGroupDialog(
      title: ProjectGroupsStrings.editProjectGroup,
    );
  }
}
