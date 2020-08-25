import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:provider/provider.dart';

/// An [AddProjectGroupCard] widget that displays a button card.
class AddProjectGroupCard extends StatelessWidget {
  /// Creates a new [AddProjectGroupCard] instance.
  const AddProjectGroupCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectGroupsNotifier, bool>(
      selector: (_, notifier) => notifier.hasConfiguredProjects,
      builder: (context, hasConfiguredProjects, _) {
        final theme = hasConfiguredProjects
            ? MetricsTheme.of(context)
                .addProjectGroupCardTheme
                .attentionLevel
                .positiveStyle
            : MetricsTheme.of(context)
                .addProjectGroupCardTheme
                .attentionLevel
                .inactiveStyle;

        final asset =
            hasConfiguredProjects ? 'icons/add.svg' : 'icons/disabled-add.svg';

        return Container(
          width: 270.0,
          height: 156.0,
          child: PaddedCard(
            backgroundColor: theme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: HandCursor(
              child: InkWell(
                onTap: hasConfiguredProjects
                    ? () => _showProjectGroupDialog(context)
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      asset,
                      width: 32.0,
                      height: 32.0,
                      color: theme.iconColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        ProjectGroupsStrings.createGroup,
                        style: theme.labelStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shows a [AddProjectGroupDialog] with an active project group.
  Future<void> _showProjectGroupDialog(BuildContext context) async {
    final projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );

    projectGroupsNotifier.initProjectGroupDialogViewModel();

    if (projectGroupsNotifier.projectGroupDialogViewModel == null) return;

    await showDialog(
      context: context,
      child: AddProjectGroupDialog(),
    );

    projectGroupsNotifier.resetProjectGroupDialogViewModel();
  }
}
