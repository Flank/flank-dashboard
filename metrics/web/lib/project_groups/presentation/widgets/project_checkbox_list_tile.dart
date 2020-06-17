import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:provider/provider.dart';

/// The widget that displays a [ProjectCheckboxViewModel].
class ProjectCheckboxListTile extends StatelessWidget {
  /// A view model with the data to display within this widget.
  final ProjectCheckboxViewModel projectCheckboxViewModel;

  /// Creates a [ProjectCheckboxListTile] with the given [projectCheckboxViewModel].
  ///
  /// The [projectCheckboxViewModel] must not be null.
  const ProjectCheckboxListTile({
    Key key,
    @required this.projectCheckboxViewModel,
  })  : assert(projectCheckboxViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        projectCheckboxViewModel.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: projectCheckboxViewModel.isChecked,
      onChanged: (isChecked) {
        _toggleProjectCheckedStatus(context, isChecked);
      },
    );
  }

  /// Changes checked status to [isChecked] for the [ProjectCheckboxViewModel].
  void _toggleProjectCheckedStatus(BuildContext context, bool isChecked) {
    Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    ).toggleProjectCheckedStatus(
      projectId: projectCheckboxViewModel.id,
      isChecked: isChecked,
    );
  }
}
