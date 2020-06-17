import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_selection_view_model.dart';
import 'package:provider/provider.dart';

/// A [CheckboxListTile] widget that displays a [ProjectSelectionViewModel] for selection.
class ProjectSelectionListTile extends StatelessWidget {
  /// A view model with the data to display within this widget.
  final ProjectSelectionViewModel projectSelectorViewModel;

  /// Creates a [ProjectSelectionListTile] with the given [projectSelectorViewModel].
  ///
  /// The [projectSelectorViewModel] must not be null.
  const ProjectSelectionListTile({
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
      onChanged: (isChecked) {
        _toggleProjectCheckedStatus(context, isChecked);
      },
    );
  }

  /// Change the checked status for [ProjectSelectionViewModel] by [projectId].
  void _toggleProjectCheckedStatus(BuildContext context, bool isChecked) {
    Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    ).toggleProjectCheckedStatus(
      projectId: projectSelectorViewModel.id,
      isChecked: isChecked,
    );
  }
}
