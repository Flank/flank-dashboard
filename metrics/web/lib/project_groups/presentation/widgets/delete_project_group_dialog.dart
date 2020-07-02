import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/delete_project_group_dialog_view_model.dart';
import 'package:provider/provider.dart';

/// The widget that displays a delete confirmation dialog.
class DeleteProjectGroupDialog extends StatefulWidget {
  @override
  _DeleteProjectGroupDialogState createState() =>
      _DeleteProjectGroupDialogState();
}

class _DeleteProjectGroupDialogState extends State<DeleteProjectGroupDialog> {
  /// Indicates whether this widget is in the loading state or not.
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final dialogThemeData = MetricsTheme.of(context).dialogThemeData;

    return Selector<ProjectGroupsNotifier, DeleteProjectGroupDialogViewModel>(
      selector: (_, state) => state.deleteProjectGroupDialogViewModel,
      builder: (_, deleteViewModel, ___) {
        final buttonText = _isLoading
            ? ProjectGroupsStrings.deletingProjectGroup
            : ProjectGroupsStrings.deleteProjectGroup;

        return InfoDialog(
          padding: dialogThemeData.padding,
          title: Text(
            ProjectGroupsStrings.getDeleteTextConfirmation(
              deleteViewModel.name,
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
                  : () => _deleteProjectGroup(deleteViewModel),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  /// Starts deleting process of a project group.
  Future<void> _deleteProjectGroup(
    DeleteProjectGroupDialogViewModel projectGroupDeleteDialogViewModel,
  ) async {
    final notifier = Provider.of<ProjectGroupsNotifier>(context, listen: false);

    _setLoading(true);

    await notifier.deleteProjectGroup(projectGroupDeleteDialogViewModel.id);

    _setLoading(false);

    final projectGroupSavingError = notifier.projectGroupSavingError;

    if (projectGroupSavingError == null) {
      Navigator.pop(context);
    }
  }

  /// Changes the [_isLoading] state to the given [value].
  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
