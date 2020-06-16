import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:provider/provider.dart';

/// A project group delete confirmation dialog.
class ProjectGroupDeleteDialog extends StatefulWidget {
  /// A project's group identifier.
  final String projectGroupId;

  /// A project's group name.
  final String projectGroupName;

  /// Creates the [ProjectGroupDeleteDialog] with the given [projectGroupId] and
  /// the [projectGroupName].
  ///
  /// The [projectGroupId] and the [projectGroupName] must not be null.
  const ProjectGroupDeleteDialog({
    @required this.projectGroupId,
    @required this.projectGroupName,
  })  : assert(projectGroupId != null),
        assert(projectGroupName != null);

  @override
  _ProjectGroupDeleteDialogState createState() =>
      _ProjectGroupDeleteDialogState();
}

class _ProjectGroupDeleteDialogState extends State<ProjectGroupDeleteDialog> {
   /// Indicates whether this widget is in the loading state or not.
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
      content: Container(),
      contentPadding: const EdgeInsets.symmetric(vertical: 32.0),
      actionsAlignment: MainAxisAlignment.end,
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
