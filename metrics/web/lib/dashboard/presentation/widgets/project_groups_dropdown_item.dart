import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/dropdown/widgets/metrics_dropdown_item.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';

/// A widget that displays a project group within a dropdown.
class ProjectGroupsDropdownItem extends StatelessWidget {
  /// A [ProjectGroupDropdownItemViewModel] with project group data to display.
  final ProjectGroupDropdownItemViewModel projectGroupDropdownItemViewModel;

  /// Creates the [ProjectGroupsDropdownItem]
  /// with the given [projectGroupDropdownItemViewModel].
  ///
  /// The [projectGroupDropdownItemViewModel] must not be null.
  const ProjectGroupsDropdownItem({
    Key key,
    @required this.projectGroupDropdownItemViewModel,
  })  : assert(projectGroupDropdownItemViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsDropdownItem(
      title: projectGroupDropdownItemViewModel.name,
    );
  }
}
