import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/clearable_text_form_field.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_name_validator.dart';
import 'package:metrics/project_groups/presentation/view_models/selected_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_selection_list.dart';
import 'package:provider/provider.dart';

/// A dialog that using for adding project group.
class AddProjectGroupDialog extends StatefulWidget {
  @override
  AddProjectGroupDialogState createState() => AddProjectGroupDialogState();
}

class AddProjectGroupDialogState extends State<AddProjectGroupDialog> {
  /// Controls the group name text being edited.
  final TextEditingController _groupNameController = TextEditingController();

  /// Global key that uniquely identifies the [Form] widget and allows validation of the form.
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

    _groupNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(vertical: 12.0);

    return Selector<ProjectGroupsNotifier, SelectedProjectGroupDialogViewModel>(
      selector: (_, state) => state.selectedProjectGroupDialogViewModel,
      builder: (_, activeProjectGroupDialogViewModel, ___) {
        final createGroupButtonText = _isLoading
            ? ProjectGroupsStrings.creatingProjectGroup
            : ProjectGroupsStrings.createGroup;

        return InfoDialog(
          padding: const EdgeInsets.all(32.0),
          title: const Text(
            ProjectGroupsStrings.addProjectGroup,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          titlePadding: padding,
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
              Container(
                height: 250.0,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: _projectGroupsNotifier.filterByProjectName,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: CommonStrings.searchForProject,
                      ),
                    ),
                    Flexible(
                      child: ProjectSelectionList(),
                    ),
                  ],
                ),
              ),
              Text(
                activeProjectGroupDialogViewModel.selectedProjectIds.isNotEmpty
                    ? ProjectGroupsStrings.getSelectedCount(
                        activeProjectGroupDialogViewModel
                            .selectedProjectIds.length,
                      )
                    : '',
              ),
            ],
          ),
          contentPadding: padding,
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => _addProjectGroup(
                              activeProjectGroupDialogViewModel,
                            ),
                    child: Text(createGroupButtonText),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: padding,
        );
      },
    );
  }

  /// Add given project group.
  Future<void> _addProjectGroup(
    SelectedProjectGroupDialogViewModel selectedProjectGroupDialogViewModel,
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
