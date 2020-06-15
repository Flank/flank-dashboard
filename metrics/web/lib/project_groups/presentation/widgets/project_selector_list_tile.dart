import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_selector_view_model.dart';
import 'package:provider/provider.dart';

/// A widget that represent a [ProjectSelectorViewModel].
class ProjectSelectorListTile extends StatelessWidget {
  /// Represents a data of a project that using in [CheckboxListTile].
  final ProjectSelectorViewModel projectSelectorViewModel;

  /// Creates a [ProjectSelectorListTile] with the given [projectSelectorViewModel].
  ///
  /// The [projectSelectorViewModel] must not be null.
  const ProjectSelectorListTile({
    Key key,
    @required this.projectSelectorViewModel,
  })  : assert(projectSelectorViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        projectSelectorViewModel.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: projectSelectorViewModel.isChecked,
      onChanged: (value) => Provider.of<ProjectGroupsNotifier>(
        context,
        listen: false,
      ).toggleProjectCheckedStatus(
        projectId: projectSelectorViewModel.id,
        isChecked: value,
      ),
    );
  }
}
