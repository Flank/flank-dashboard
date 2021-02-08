// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_negative_button.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_neutral_button.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/toast/widgets/negative_toast.dart';
import 'package:metrics/common/presentation/toast/widgets/positive_toast.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';
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
  bool _isDeleting = false;

  /// A [ProjectGroupsNotifier] needed to reset the delete project
  /// group dialog view model on dispose.
  ProjectGroupsNotifier _projectGroupsNotifier;

  @override
  void initState() {
    _projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dialogTheme = MetricsTheme.of(context).deleteDialogTheme;
    final contentTextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .merge(dialogTheme.contentTextStyle);

    return Selector<ProjectGroupsNotifier, DeleteProjectGroupDialogViewModel>(
      selector: (_, state) => state.deleteProjectGroupDialogViewModel,
      builder: (_, deleteViewModel, ___) {
        final buttonText = _isDeleting
            ? ProjectGroupsStrings.deletingProjectGroup
            : ProjectGroupsStrings.delete;

        return InfoDialog(
          constraints: const BoxConstraints(
            minHeight: 262.0,
            maxWidth: 480.0,
          ),
          closeIconPadding: const EdgeInsets.only(top: 16.0, right: 16.0),
          closeIcon: SvgImage(
            'icons/close.svg',
            color: dialogTheme.closeIconColor,
            height: 24.0,
            width: 24.0,
          ),
          backgroundColor: dialogTheme.backgroundColor,
          padding: const EdgeInsets.all(40.0),
          title: Text(
            ProjectGroupsStrings.deleteProjectGroup,
            style: dialogTheme.titleTextStyle,
          ),
          titlePadding: const EdgeInsets.only(bottom: 16.0),
          contentPadding: const EdgeInsets.only(bottom: 64.0),
          content: RichText(
            text: TextSpan(
              text: ProjectGroupsStrings.deleteConfirmation,
              style: contentTextStyle,
              children: [
                TextSpan(
                  text: ' ${deleteViewModel.name} ',
                  style: contentTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ProjectGroupsStrings.deleteConfirmationQuestion,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: MetricsNeutralButton(
                  label: CommonStrings.cancel,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MetricsNegativeButton(
                  label: buttonText,
                  onPressed: _isDeleting
                      ? null
                      : () => _deleteProjectGroup(deleteViewModel),
                ),
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

    Toast toast;

    if (projectGroupSavingError == null) {
      Navigator.pop(context);
      final message = ProjectGroupsStrings.getDeletedProjectGroupMessage(
        projectGroupDeleteDialogViewModel.name,
      );
      toast = PositiveToast(message: message);
    } else {
      _setLoading(false);
      toast = NegativeToast(message: projectGroupSavingError);
    }

    showToast(context, toast);
  }

  /// Changes the [_isDeleting] state to the given [value].
  void _setLoading(bool value) {
    setState(() => _isDeleting = value);
  }

  @override
  void dispose() {
    _projectGroupsNotifier.resetDeleteProjectGroupDialogViewModel();
    super.dispose();
  }
}
