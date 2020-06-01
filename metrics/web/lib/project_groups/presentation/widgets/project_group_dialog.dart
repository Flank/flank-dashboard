import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/clearable_text_field.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/dashboard/presentation/widgets/project_search_input.dart';
import 'package:metrics/project_groups/presentation/view_model/project_group_view_model.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/util/project_group_validation_util.dart';
import 'package:provider/provider.dart';

/// A dialog that using for updating or creating project group data.
class ProjectGroupDialog extends StatefulWidget {
  final ProjectGroupViewModel projectGroupViewModel;

  /// Creates the [ProjectGroupDialog].
  ///
  /// [projectGroupViewModel] represents project group data for UI.
  const ProjectGroupDialog({
    this.projectGroupViewModel,
  });

  @override
  _ProjectGroupDialogState createState() => _ProjectGroupDialogState();
}

class _ProjectGroupDialogState extends State<ProjectGroupDialog> {
  /// Controls the group name text being edited.
  final TextEditingController _groupNameController = TextEditingController();

  /// Global key that uniquely identifies the [Form] widget and allows validation of the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Contains a list of project ids related with the given [projectGroupViewModel].
  List<String> _projectIds = [];

  /// Controls loading state.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.projectGroupViewModel != null) {
      _groupNameController.text = widget.projectGroupViewModel?.name;
      _projectIds = [...widget.projectGroupViewModel?.projectIds];
    }

    _groupNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MetricsDialog(
        padding: const EdgeInsets.all(32.0),
        maxWidth: 500.0,
        title: Text(
          widget.projectGroupViewModel == null
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
            ClearableTextFormField(
              validator: ProjectGroupValidationUtil.validateProjectGroupName,
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
                  ProjectSearchInput(),
                  Flexible(
                    child: Consumer<ProjectGroupsNotifier>(
                      builder: (_, projectGroupsNotifier, __) {
                        if (projectGroupsNotifier.errorMessage != null) {
                          return Container(); //error loading
                        }

                        final projects =
                            projectGroupsNotifier.projects;

                        if (projects == null) return Container(); // no projects

                        if (projects.isEmpty) {
                          return Container(); // empty projects
                          // return const _DashboardTablePlaceholder(
                          //   text: DashboardStrings.noConfiguredProjects,
                          // );
                        }

                        return ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return CheckboxListTile(
                              title: Text(
                                project.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _projectIds.contains(project.id),
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    _projectIds.add(project.id);
                                  } else {
                                    _projectIds.remove(project.id);
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _projectIds.isNotEmpty
                  ? ProjectGroupsStrings.getSelectedCount(_projectIds.length)
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
                  onPressed: _isLoading ? null : () => _saveProjectGroups(),
                  child: Text(
                    widget.projectGroupViewModel == null
                        ? ProjectGroupsStrings.createGroup
                        : ProjectGroupsStrings.saveChanges,
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
  }

  /// Starts save project group process.
  Future<void> _saveProjectGroups() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final projectGroupNotifier =
        Provider.of<ProjectGroupsNotifier>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final isSuccess = await projectGroupNotifier.saveProjectGroups(
      widget.projectGroupViewModel?.id,
      _groupNameController.text,
      _projectIds,
    );
    setState(() {
      _isLoading = false;
    });

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
