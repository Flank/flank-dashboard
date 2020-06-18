import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/clearable_text_form_field.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_name_validator.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list.dart';
import 'package:provider/provider.dart';

/// The widget that displays a dialog with the form for adding project group.
class AddProjectGroupDialog extends StatefulWidget {
  @override
  _AddProjectGroupDialogState createState() => _AddProjectGroupDialogState();
}

class _AddProjectGroupDialogState extends State<AddProjectGroupDialog> {
  /// A group name text editing controller.
  final TextEditingController _groupNameController = TextEditingController();

  /// A global key that uniquely identifies the [Form] widget
  /// and allows validation of the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// The [ChangeNotifier] that holds the project groups state.
  ProjectGroupsNotifier _projectGroupsNotifier;

  /// Indicates whether this widget is in the loading state or not.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogThemeData = MetricsTheme.of(context).dialogThemeData;

    return Selector<ProjectGroupsNotifier, ProjectGroupDialogViewModel>(
      selector: (_, state) => state.projectGroupDialogViewModel,
      builder: (_, projectGroupDialogViewModel, ___) {
        final createGroupButtonText = _isLoading
            ? ProjectGroupsStrings.creatingProjectGroup
            : ProjectGroupsStrings.createGroup;

        return InfoDialog(
          padding: dialogThemeData.padding,
          title: Text(
            ProjectGroupsStrings.addProjectGroup,
            style: dialogThemeData.titleTextStyle,
          ),
          titlePadding: dialogThemeData.titlePadding,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: ClearableTextFormField(
                  validator: ProjectGroupNameValidator.validate,
                  label: ProjectGroupsStrings.nameYourGroup,
                  controller: _groupNameController,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(ProjectGroupsStrings.chooseProjectToAdd),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        onChanged: _projectGroupsNotifier.filterByProjectName,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: CommonStrings.searchForProject,
                        ),
                      ),
                      Flexible(
                        child: ProjectCheckboxList(),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                projectGroupDialogViewModel.selectedProjectIds.isNotEmpty
                    ? ProjectGroupsStrings.getSelectedCount(
                        projectGroupDialogViewModel.selectedProjectIds.length,
                      )
                    : '',
              ),
            ],
          ),
          contentPadding: dialogThemeData.contentPadding,
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () => _addProjectGroup(
                            projectGroupDialogViewModel,
                          ),
                  child: Text(createGroupButtonText),
                ),
              ],
            ),
          ],
          actionsPadding: dialogThemeData.actionsPadding,
        );
      },
    );
  }

  /// Adds the given project group.
  Future<void> _addProjectGroup(
    ProjectGroupDialogViewModel selectedProjectGroupDialogViewModel,
  ) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    await _projectGroupsNotifier.addProjectGroup(
      selectedProjectGroupDialogViewModel.id,
      _groupNameController.text,
      selectedProjectGroupDialogViewModel.selectedProjectIds,
    );

    setState(() => _isLoading = false);

    final projectGroupSavingError = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    ).projectGroupSavingError;

    if (projectGroupSavingError == null) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _projectGroupsNotifier.resetFilterName();
    _groupNameController.dispose();
    super.dispose();
  }
}
