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
    final widgetThemeData = MetricsTheme.of(context).inactiveWidgetTheme;
    const symmetricPadding = EdgeInsets.symmetric(vertical: 4.0);

    return InkWell(
      onTap: () => _showProjectGroupDialog(context),
      child: PaddedCard(
        backgroundColor: widgetThemeData.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Padding(
              padding: symmetricPadding,
              child: Icon(
                Icons.add,
                size: 72.0,
              ),
            ),
            Padding(
              padding: symmetricPadding,
              child: Text(
                ProjectGroupsStrings.addProjectGroup,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ],
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
