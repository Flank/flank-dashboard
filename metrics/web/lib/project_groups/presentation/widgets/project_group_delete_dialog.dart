import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:provider/provider.dart';

/// A dialog that using for deleting project group data.
class ProjectGroupDeleteDialog extends StatefulWidget {
  final String projectGroupId;
  final String projectGroupName;

  /// Creates the [ProjectGroupDeleteDialog].
  ///
  /// [projectGroupViewModel] represents project group data for UI.
  const ProjectGroupDeleteDialog({
    @required this.projectGroupId,
    @required this.projectGroupName,
  });

  @override
  _ProjectGroupDeleteDialogState createState() =>
      _ProjectGroupDeleteDialogState();
}

class _ProjectGroupDeleteDialogState extends State<ProjectGroupDeleteDialog> {
  /// Controls the loading state.
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MetricsDialog(
      maxWidth: 500.0,
      padding: const EdgeInsets.all(32.0),
      title: Text(
        ProjectGroupsStrings.getDeleteTextConfirmation(widget.projectGroupName),
        style: const TextStyle(fontSize: 16.0),
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 12.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 32.0),
      actionsAlignment: MainAxisAlignment.end,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(CommonStrings.cancel),
          ),
        ),
        Container(
          height: 50.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: _isLoading ? null : () => _deleteProjectGroup(),
            child: Text(
              _isLoading
                  ? ProjectGroupsStrings.deletingProjectGroup
                  : ProjectGroupsStrings.deleteProjectGroup,
            ),
          ),
        ),
      ],
    );
  }

  /// Starts deleting process of a project group.
  Future<void> _deleteProjectGroup() async {
    final projectGroupNotifier =
        Provider.of<ProjectGroupsNotifier>(context, listen: false);

    setState(() => _isLoading = true);

    final isSuccess =
        await projectGroupNotifier.deleteProjectGroup(widget.projectGroupId);

    if (isSuccess) {
      Navigator.pop(context);
    }
  }
}
