import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_tile_card.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_delete_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:provider/provider.dart';

/// A widget that represent [ProjectGroupCardViewModel].
class ProjectGroupCard extends StatelessWidget {
  /// Represents a data of a project that using in the [MetricsTileCard].
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    const padding = EdgeInsets.all(8.0);

    return MetricsTileCard(
      backgroundColor:
          themeNotifier.isDark ? Colors.grey[900] : Colors.grey[200],
      padding: const EdgeInsets.all(16.0),
      title: Text(
        projectGroupCardViewModel.name,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 1,
        style: const TextStyle(fontSize: 24.0),
      ),
      titlePadding: padding,
      subtitle: Text(_projectGroupsCount),
      subtitlePadding: padding,
      actionsPadding: const EdgeInsets.only(top: 24.0),
      actions: <Widget>[
        FlatButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text(CommonStrings.edit),
          onPressed: () => _showProjectGroupDialog(context),
        ),
        FlatButton.icon(
          icon: const Icon(Icons.delete_outline),
          label: const Text(CommonStrings.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return ProjectGroupDeleteDialog(
                  projectGroupId: projectGroupCardViewModel.id,
                  projectGroupName: projectGroupCardViewModel.name,
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Provides a project groups count for the given [projectGroupViewModel].
  String get _projectGroupsCount {
    return projectGroupCardViewModel.projectsCount == 0
        ? ProjectGroupsStrings.noProjects
        : ProjectGroupsStrings.getProjectsCount(
            projectGroupCardViewModel.projectsCount);
  }

  /// Shows a [ProjectGroupDialog] with an active project group.
  Future<void> _showProjectGroupDialog(BuildContext context) async {
    Provider.of<ProjectGroupsNotifier>(context, listen: false)
        .setActiveProjectGroup(
      projectGroupCardViewModel.id,
    );

    await showDialog(
      context: context,
      builder: (_) => ProjectGroupDialog(),
    );
  }
}
