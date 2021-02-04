// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/project_group_dialog_strategy.dart';

/// The [ProjectGroupDialogStrategy] implementation for the
/// [AddProjectGroupDialog] and adding a new project group.
class AddProjectGroupDialogStrategy implements ProjectGroupDialogStrategy {
  @override
  final String title = ProjectGroupsStrings.createProjectGroup;

  @override
  final String text = ProjectGroupsStrings.createGroup;

  @override
  final String loadingText = ProjectGroupsStrings.creatingProjectGroup;

  @override
  String getSuccessfulActionMessage(String groupName) =>
      ProjectGroupsStrings.getCreatedProjectGroupMessage(groupName);

  @override
  Future<void> action(
    ProjectGroupsNotifier notifier,
    String groupId,
    String groupName,
    List<String> projectIds,
  ) {
    return notifier.addProjectGroup(groupName, projectIds);
  }
}
