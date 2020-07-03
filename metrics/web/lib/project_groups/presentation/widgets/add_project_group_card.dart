import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:provider/provider.dart';

/// An [AddProjectGroupCard] widget that displays a button card.
class AddProjectGroupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).addProjectGroupCardTheme;

    return Container(
      width: 270.0,
      height: 156.0,
      child: PaddedCard(
        backgroundColor: theme.backgroundColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: InkWell(
          onTap: () => _showProjectGroupDialog(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'icons/add.svg',
                width: 32.0,
                height: 32.0,
                color: theme.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  ProjectGroupsStrings.addProjectGroup,
                  style: theme.titleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a [AddProjectGroupDialog] with an active project group.
  void _showProjectGroupDialog(BuildContext context) {
    Provider.of<ProjectGroupsNotifier>(context, listen: false)
        .setProjectGroupDialogViewModel();

    showDialog(
      context: context,
      child: AddProjectGroupDialog(),
    );
  }
}
