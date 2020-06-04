import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:metrics/dashboard/presentation/widgets/project_search_input.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/util/project_group_validation_util.dart';
import 'package:metrics/project_groups/presentation/view_models/active_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_selector_list.dart';
import 'package:provider/provider.dart';

/// A dialog that using for updating or creating project group data.
class ProjectGroupDialog extends StatefulWidget {
  @override
  ProjectGroupDialogState createState() => ProjectGroupDialogState();
}

class ProjectGroupDialogState extends State<ProjectGroupDialog> {
  /// Controls the group name text being edited.
  final TextEditingController _groupNameController = TextEditingController();

  /// Global key that uniquely identifies the [Form] widget and allows validation of the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// A [ProjectGroupsNotifier] needed to set text editing controller text and
  /// filter projects.
  ProjectGroupsNotifier _projectGroupsNotifier;

  /// Controls loading state.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );

    _groupNameController.text =
        _projectGroupsNotifier.activeProjectGroupDialogViewModel?.name;

    _groupNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectGroupsNotifier, ActiveProjectGroupDialogViewModel>(
      selector: (_, state) => state.activeProjectGroupDialogViewModel,
      builder: (_, activeProjectGroupDialogViewModel, ___) {
        final createGroupButtonText = _isLoading
            ? ProjectGroupsStrings.creatingProjectGroup
            : ProjectGroupsStrings.createGroup;
        final editGroupButtonText = _isLoading
            ? ProjectGroupsStrings.savingProjectGroup
            : ProjectGroupsStrings.saveChanges;

        return Form(
          key: _formKey,
          child: MetricsDialog(
            padding: const EdgeInsets.all(32.0),
            maxWidth: 500.0,
            title: Text(
              activeProjectGroupDialogViewModel.id == null
                  ? ProjectGroupsStrings.addProjectGroup
                  : ProjectGroupsStrings.editProjectGroup,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            titlePadding: const EdgeInsets.symmetric(vertical: 12.0),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MetricsTextFormField(
                  validator:
                      ProjectGroupValidationUtil.validateProjectGroupName,
                  label: ProjectGroupsStrings.nameYourStrings,
                  controller: _groupNameController,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
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
                      ProjectSearchInput(
                        onFilter: _projectGroupsNotifier.filterByProjectName,
                      ),
                      Flexible(
                        child: ProjectSelectorList(),
                      ),
                    ],
                  ),
                ),
                Text(
                  activeProjectGroupDialogViewModel
                          .selectedProjectIds.isNotEmpty
                      ? ProjectGroupsStrings.getSelectedCount(
                          activeProjectGroupDialogViewModel
                              .selectedProjectIds.length,
                        )
                      : '',
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
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
                          : () => _saveProjectGroups(
                              activeProjectGroupDialogViewModel),
                      child: Text(
                        activeProjectGroupDialogViewModel.id == null
                            ? createGroupButtonText
                            : editGroupButtonText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Selector<ProjectGroupsNotifier, String>(
                      selector: (_, state) => state.firestoreWriteErrorMessage,
                      builder: (_, firestoreWriteErrorMessage, __) {
                        if (firestoreWriteErrorMessage == null) {
                          return const Text('');
                        }

                        return Text(
                          firestoreWriteErrorMessage,
                          style: const TextStyle(color: Colors.red),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
            actionsPadding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
        );
      },
    );
  }

  /// Starts save project group process.
  Future<void> _saveProjectGroups(
      ActiveProjectGroupDialogViewModel
          activeProjectGroupDialogViewModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final isSuccess =
        await Provider.of<ProjectGroupsNotifier>(context, listen: false)
            .saveProjectGroup(
      activeProjectGroupDialogViewModel.id,
      _groupNameController.text,
      activeProjectGroupDialogViewModel.selectedProjectIds,
    );

    if (isSuccess) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}
