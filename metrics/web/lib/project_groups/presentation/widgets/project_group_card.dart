import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/icon_label_button.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/delete_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/update_project_group_dialog.dart';
import 'package:provider/provider.dart';

/// A widget that represents [ProjectGroupCardViewModel].
class ProjectGroupCard extends StatelessWidget {
  /// A [ProjectGroupCardViewModel] with project group data to display.
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
    const _buttonIconPadding = EdgeInsets.only(right: 6.0);
    final _buttonBorderRadius = BorderRadius.circular(4.0);
    final theme = MetricsTheme.of(context).projectGroupCardTheme;

    return Container(
      width: 270.0,
      height: 156.0,
      child: PaddedCard(
        padding: const EdgeInsets.all(24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(color: theme.borderColor),
        ),
        backgroundColor: theme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                projectGroupCardViewModel.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.titleStyle,
              ),
            ),
            Text(
              _projectGroupsCount,
              style: theme.subtitleStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconLabelButton(
                    onPressed: () => _showProjectGroupDialog(context),
                    borderRadius: _buttonBorderRadius,
                    iconPadding: _buttonIconPadding,
                    icon: Icon(
                      Icons.edit,
                      size: 20.0,
                      color: theme.primaryColor,
                    ),
                    label: CommonStrings.edit,
                    labelStyle: TextStyle(
                      color: theme.primaryColor,
                    ),
                  ),
                  IconLabelButton(
                    onPressed: () => _showProjectGroupDeleteDialog(context),
                    borderRadius: _buttonBorderRadius,
                    iconPadding: _buttonIconPadding,
                    icon: Icon(
                      Icons.delete,
                      size: 20.0,
                      color: theme.accentColor,
                    ),
                    label: CommonStrings.delete,
                    labelStyle: TextStyle(
                      color: theme.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Provides a project groups count for the given [projectGroupViewModel].
  String get _projectGroupsCount {
    final projectsCount = projectGroupCardViewModel.projectsCount;

    if (projectsCount == null || projectsCount == 0) {
      return ProjectGroupsStrings.noProjects;
    }

    return ProjectGroupsStrings.getProjectsCount(projectsCount);
  }

  /// Shows a [DeleteProjectGroupDialog] with an active project group.
  void _showProjectGroupDeleteDialog(BuildContext context) {
    Provider.of<ProjectGroupsNotifier>(context, listen: false)
        .setProjectGroupDeleteDialogViewModel(
      projectGroupCardViewModel.id,
    );

    showDialog(
      context: context,
      builder: (_) => DeleteProjectGroupDialog(),
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
