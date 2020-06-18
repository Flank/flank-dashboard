import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_delete_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/update_project_group_dialog.dart';
import 'package:provider/provider.dart';

/// A widget that represent [ProjectGroupCardViewModel].
class ProjectGroupCard extends StatelessWidget {
  /// A project group card viewModel with project group data to display.
  final ProjectGroupCardViewModel projectGroupCardViewModel;

  /// Creates the [ProjectGroupCard] with the given [projectGroupCardViewModel].
  ///
  /// The [projectGroupCardViewModel] must not be null.
  const ProjectGroupCard({
    Key key,
    @required this.projectGroupCardViewModel,
  })  : assert(projectGroupCardViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetThemeData = MetricsTheme.of(context).inactiveWidgetTheme;
    const padding = EdgeInsets.all(8.0);

    return PaddedCard(
      padding: const EdgeInsets.all(16.0),
      backgroundColor: widgetThemeData.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: padding,
            child: Text(
              projectGroupCardViewModel.name,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          Padding(
            padding: padding,
            child: Text(_projectGroupsCount),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: <Widget>[
                FlatButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text(CommonStrings.edit),
                  onPressed: () => _showProjectGroupDialog(context),
                ),
                FlatButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text(CommonStrings.delete),
                  onPressed: () => _showProjectGroupDeleteDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Provides a project groups count for the given [projectGroupViewModel].
  String get _projectGroupsCount {
    final projectsCount = projectGroupCardViewModel.projectsCount;

    if (projectsCount == 0) {
      return ProjectGroupsStrings.noProjects;
    }

    return ProjectGroupsStrings.getProjectsCount(projectsCount);
  }

  /// Shows a [ProjectGroupDeleteDialog] with an active project group.
  void _showProjectGroupDeleteDialog(BuildContext context) {
    Provider.of<ProjectGroupsNotifier>(context, listen: false)
        .setProjectGroupDeleteDialogViewModel(
      projectGroupCardViewModel.id,
    );

    showDialog(
      context: context,
      builder: (_) => ProjectGroupDeleteDialog(),
    );
  }

  /// Shows a [UpdateProjectGroupDialog] with an active project group.
  void _showProjectGroupDialog(BuildContext context) {
    Provider.of<ProjectGroupsNotifier>(context, listen: false)
        .setProjectGroupDialogViewModel(
      projectGroupCardViewModel.id,
    );

    showDialog(
      context: context,
      builder: (_) => UpdateProjectGroupDialog(),
    );
  }
}
