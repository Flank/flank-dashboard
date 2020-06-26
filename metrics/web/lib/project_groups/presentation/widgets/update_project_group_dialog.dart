import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/update_project_group_dialog_strategy.dart';

/// The widget that displays dialog for updating a project group.
class UpdateProjectGroupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final strategy = UpdateProjectGroupDialogStrategy();

    return ProjectGroupDialog(
      strategy: strategy,
    );
  }
}
