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
  /// Indicates whether this add project group card is disabled.
  final bool isEnabled;

  /// Creates a new [AddProjectGroupCard] instance.
  ///
  /// [isEnabled] defaults to `true`.
  const AddProjectGroupCard({this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    final theme = isEnabled
        ? MetricsTheme.of(context).addProjectGroupCardTheme.enabledStyle
        : MetricsTheme.of(context).addProjectGroupCardTheme.disabledStyle;

    final iconPath = isEnabled ? 'icons/add.svg' : 'icons/disabled_add.svg';

    return Container(
      width: 270.0,
      height: 156.0,
      child: PaddedCard(
        backgroundColor: theme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: HandCursor(
          child: InkWell(
            onTap: isEnabled ? () => _showProjectGroupDialog(context) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  iconPath,
                  width: 32.0,
                  height: 32.0,
                  color: Colors.red,
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
