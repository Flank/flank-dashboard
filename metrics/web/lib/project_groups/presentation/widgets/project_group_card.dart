import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/icon_label_button.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/delete_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/edit_project_group_dialog.dart';
import 'package:provider/provider.dart';

/// A widget that represents [ProjectGroupCardViewModel].
class ProjectGroupCard extends StatefulWidget {
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
  _ProjectGroupCardState createState() => _ProjectGroupCardState();
}

class _ProjectGroupCardState extends State<ProjectGroupCard> {
  /// The length of the icon box side.
  static const double _iconBoxSide = 20.0;

  @override
  Widget build(BuildContext context) {
    const _buttonIconPadding = EdgeInsets.only(right: 8.0);
    final _buttonBorderRadius = BorderRadius.circular(4.0);
    final theme = MetricsTheme.of(context).projectGroupCardTheme;

    return TappableArea(
      builder: (context, isHovered) {
        return MetricsCard(
          decoration: BoxDecoration(
            border: Border.all(color: theme.borderColor),
            borderRadius: BorderRadius.circular(4.0),
            color: isHovered ? theme.hoverColor : theme.backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 24.0),
                      child: Text(
                        widget.projectGroupCardViewModel.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.titleStyle,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(minHeight: 16.0),
                    child: Text(
                      _projectGroupsCount,
                      style: theme.subtitleStyle,
                    ),
                  ),
                ],
              ),
              if (isHovered)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconLabelButton(
                      onPressed: () => _showProjectGroupDialog(context),
                      borderRadius: _buttonBorderRadius,
                      iconPadding: _buttonIconPadding,
                      icon: Image.network(
                        'icons/edit.svg',
                        width: _iconBoxSide,
                        height: _iconBoxSide,
                        fit: BoxFit.contain,
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
                      icon: Image.network(
                        'icons/delete.svg',
                        width: _iconBoxSide,
                        height: _iconBoxSide,
                        fit: BoxFit.contain,
                        color: theme.accentColor,
                      ),
                      label: CommonStrings.delete,
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  /// Provides a project groups count for the given [projectGroupViewModel].
  String get _projectGroupsCount {
    final projectsCount = widget.projectGroupCardViewModel.projectsCount;

    if (projectsCount == null || projectsCount == 0) {
      return ProjectGroupsStrings.noProjects;
    }

    return ProjectGroupsStrings.getProjectsCount(projectsCount);
  }

  /// Shows a [DeleteProjectGroupDialog] with an active project group.
  Future<void> _showProjectGroupDeleteDialog(BuildContext context) async {
    final projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );

    projectGroupsNotifier.initDeleteProjectGroupDialogViewModel(
      widget.projectGroupCardViewModel.id,
    );

    if (projectGroupsNotifier.deleteProjectGroupDialogViewModel == null) return;

    await showDialog(
      context: context,
      builder: (_) => DeleteProjectGroupDialog(),
    );

    projectGroupsNotifier.resetDeleteProjectGroupDialogViewModel();
  }

  /// Shows a [EditProjectGroupDialog] with an active project group.
  Future<void> _showProjectGroupDialog(BuildContext context) async {
    final projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );

    projectGroupsNotifier.initProjectGroupDialogViewModel(
      widget.projectGroupCardViewModel.id,
    );

    if (projectGroupsNotifier.projectGroupDialogViewModel == null) return;

    await showDialog(
      context: context,
      builder: (_) => EditProjectGroupDialog(),
    );

    projectGroupsNotifier.resetProjectGroupDialogViewModel();
  }
}
