import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
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
    return Selector<ProjectGroupsNotifier, DeleteProjectGroupDialogViewModel>(
      selector: (_, state) => state.deleteProjectGroupDialogViewModel,
      builder: (_, deleteViewModel, ___) {
        final buttonText = _isLoading
            ? ProjectGroupsStrings.deletingProjectGroup
            : ProjectGroupsStrings.deleteProjectGroup;

        return InfoDialog(
          padding: const EdgeInsets.all(24.0),
          title: Text(
            ProjectGroupsStrings.getDeleteTextConfirmation(
              deleteViewModel.name,
            ),
            style: const TextStyle(fontSize: 16.0),
          ),
          actionsAlignment: MainAxisAlignment.end,
          contentPadding: const EdgeInsets.symmetric(vertical: 32.0),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: HandCursor(
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(CommonStrings.cancel),
                ),
              ),
            ),
            HandCursor(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: _isLoading
                    ? null
                    : () => _deleteProjectGroup(deleteViewModel),
                child: Text(buttonText),
              ),
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

    final projectGroupSavingError = notifier.projectGroupSavingError;

    if (projectGroupSavingError == null) {
      Navigator.pop(context);
    } else {
      _setLoading(false);
    }
  }

  /// Changes the [_isLoading] state to the given [value].
  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
