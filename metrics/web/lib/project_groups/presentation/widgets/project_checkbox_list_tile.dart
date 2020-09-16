import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/widgets/metrics_checkbox.dart';
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
    final theme = MetricsTheme.of(context).projectGroupDialogTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleProjectCheckedStatus(context),
        child: Container(
          height: 48.0,
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: MetricsCheckbox(
                  value: projectCheckboxViewModel.isChecked,
                  onChanged: (_) {
                    _toggleProjectCheckedStatus(context);
                  },
                ),
              ),
              Text(
                projectCheckboxViewModel.name,
                style: projectCheckboxViewModel.isChecked
                    ? theme.checkedProjectTextStyle
                    : theme.uncheckedProjectTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Changes checked status for the [ProjectCheckboxViewModel].
  void _toggleProjectCheckedStatus(BuildContext context) {
    Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    ).toggleProjectCheckedStatus(
      projectCheckboxViewModel.id,
    );
  }
}
