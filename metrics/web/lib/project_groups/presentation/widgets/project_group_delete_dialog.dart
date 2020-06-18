import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_delete_dialog_view_model.dart';
import 'package:provider/provider.dart';

/// The widget that displays a delete confirmation dialog.
class ProjectGroupDeleteDialog extends StatefulWidget {
  @override
  _ProjectGroupDeleteDialogState createState() =>
      _ProjectGroupDeleteDialogState();
}

class _ProjectGroupDeleteDialogState extends State<ProjectGroupDeleteDialog> {
  /// Indicates whether this widget is in the loading state or not.
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final dialogThemeData = MetricsTheme.of(context).dialogThemeData;

    return Selector<ProjectGroupsNotifier, ProjectGroupDeleteDialogViewModel>(
      selector: (_, state) => state.projectGroupDeleteDialogViewModel,
      builder: (_, projectGroupDeleteDialogViewModel, ___) {
        return InfoDialog(
          padding: dialogThemeData.padding,
          title: Text(
            ProjectGroupsStrings.getDeleteTextConfirmation(
              projectGroupDeleteDialogViewModel.name,
            ),
            style: const TextStyle(fontSize: 16.0),
          ),
          titlePadding: dialogThemeData.titlePadding,
          actionsAlignment: MainAxisAlignment.end,
          contentPadding: dialogThemeData.contentPadding,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(CommonStrings.cancel),
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: _isLoading
                  ? null
                  : () => _deleteProjectGroup(
                        projectGroupDeleteDialogViewModel,
                      ),
              child: Text(
                _isLoading
                    ? ProjectGroupsStrings.deletingProjectGroup
                    : ProjectGroupsStrings.deleteProjectGroup,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Starts deleting process of a project group.
  Future<void> _deleteProjectGroup(
    ProjectGroupDeleteDialogViewModel projectGroupDeleteDialogViewModel,
  ) async {
    setState(() => _isLoading = true);

    await Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    ).deleteProjectGroup(projectGroupDeleteDialogViewModel.id);

    setState(() => _isLoading = false);

    final projectGroupSavingError = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    ).projectGroupSavingError;

    if (projectGroupSavingError == null) {
      Navigator.pop(context);
    }
  }
}
