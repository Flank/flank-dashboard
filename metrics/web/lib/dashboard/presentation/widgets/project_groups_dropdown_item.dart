import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_item.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
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
    final theme = MetricsTheme.of(context).projectGroupsDropdownItemTheme;

    return DropdownItem(
      height: 40.0,
      width: 210.0,
      alignment: Alignment.centerLeft,
      backgroundColor: theme.backgroundColor,
      hoverColor: theme.hoverColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 11.0),
      child: Text(
        projectGroupDropdownItemViewModel.name,
        style: theme.textStyle,
      ),
    );
  }
}
