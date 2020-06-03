import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_selector_view_model.dart';
import 'package:provider/provider.dart';

class ProjectSelectorListTile extends StatelessWidget {
  final ProjectSelectorViewModel projectSelectorViewModel;

  const ProjectSelectorListTile({
    Key key,
    this.projectSelectorViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        projectSelectorViewModel.name,
        style: TextStyle(
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
