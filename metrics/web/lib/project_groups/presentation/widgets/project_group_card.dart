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
  final ProjectGroupCardViewModel projectGroupCardViewModel;

  /// Creates the [ProjectGroupCard].
  ///
  /// [projectGroupViewModel] should not be null.
  ///
  /// [projectGroupViewModel] represents project group data for UI.
  const ProjectGroupCard({
    Key key,
    @required this.projectGroupCardViewModel,
  })  : assert(projectGroupCardViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
      titlePadding: const EdgeInsets.all(8.0),
      subtitle: Text(_projectGroupsCount),
      subtitlePadding: const EdgeInsets.all(8.0),
      actionsPadding: const EdgeInsets.only(top: 24.0),
      actions: <Widget>[
        Expanded(
          child: FlatButton.icon(
            onPressed: () {
              Provider.of<ProjectGroupsNotifier>(context, listen: false)
                  .generateActiveProjectGroupViewModel(
                      projectGroupCardViewModel.id);

              showDialog(
                context: context,
                builder: (_) => ProjectGroupDialog(),
              );
            },
            icon: Icon(Icons.edit),
            label: const Text(CommonStrings.edit),
          ),
        ),
        Expanded(
          child: FlatButton.icon(
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
            icon: const Icon(Icons.delete_outline),
            label: const Text(CommonStrings.delete),
          ),
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
}
