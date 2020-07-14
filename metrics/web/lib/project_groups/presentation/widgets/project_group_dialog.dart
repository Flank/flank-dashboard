import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/clearable_text_form_field.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_name_validator.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/project_group_dialog_strategy.dart';
import 'package:provider/provider.dart';

/// A widget that displays a dialog with the project group form and uses
/// the given [ProjectGroupDialogStrategy].
class ProjectGroupDialog extends StatefulWidget {
  /// A [ProjectGroupDialogStrategy] strategy applied to this dialog.
  final ProjectGroupDialogStrategy strategy;

  /// Creates a new instance of the [ProjectGroupDialog]
  /// with the given [strategy].
  ///
  /// The [strategy] must not be null.
  const ProjectGroupDialog({
    Key key,
    @required this.strategy,
  })  : assert(strategy != null),
        super(key: key);

  @override
  _ProjectGroupDialogState createState() => _ProjectGroupDialogState();
}

class _ProjectGroupDialogState extends State<ProjectGroupDialog> {
  /// A text editing controller for a group name.
  final TextEditingController _groupNameController = TextEditingController();

  /// A global key that uniquely identifies the [Form] widget
  /// and allows accessing form validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// A [ChangeNotifier] that holds the project groups state.
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

    _groupNameController.text =
        _projectGroupsNotifier?.projectGroupDialogViewModel?.name;
  }

  @override
  Widget build(BuildContext context) {
    final dialogTheme = MetricsTheme.of(context).projectGroupDialogTheme;
    final strategy = widget.strategy;

    return Selector<ProjectGroupsNotifier, ProjectGroupDialogViewModel>(
      selector: (_, state) => state.projectGroupDialogViewModel,
      builder: (_, projectGroup, __) {
        final buttonText = _isLoading ? strategy.loadingText : strategy.text;

        return InfoDialog(
          closeIconPadding: const EdgeInsets.only(top: 16.0, right: 16.0),
          backgroundColor: dialogTheme.backgroundColor,
          padding: const EdgeInsets.all(40.0),
          title: Text(
            strategy.title,
            style: dialogTheme.titleTextStyle,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 32.0),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Form(
                  key: _formKey,
                  child: ClearableTextFormField(
                    textStyle: dialogTheme.groupNameTextStyle,
                    validator: ProjectGroupNameValidator.validate,
                    inputDecoration: const InputDecoration(
                      hintText: ProjectGroupsStrings.nameYourGroup,
                    ),
                    controller: _groupNameController,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: dialogTheme.contentBorderColor),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          onChanged: _projectGroupsNotifier.filterByProjectName,
                          style: dialogTheme.searchForProjectTextStyle,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: CommonStrings.searchForProject,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ProjectCheckboxList(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  _getCounterText(projectGroup),
                  style: dialogTheme.counterTextStyle,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Expanded(
              child: HandCursor(
                child: RaisedButton(
                  color: dialogTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onPressed:
                      _isLoading ? null : () => _actionCallback(projectGroup),
                  child: Text(
                    buttonText,
                    style: dialogTheme.actionsTextStyle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Returns a text to display as a counter for the selected projects.
  String _getCounterText(ProjectGroupDialogViewModel projectGroup) {
    final selectedProjectIds = projectGroup.selectedProjectIds;

    if (selectedProjectIds.isEmpty) return '';

    return ProjectGroupsStrings.getSelectedCount(selectedProjectIds.length);
  }

  /// A callback for this dialog action button.
  Future<void> _actionCallback(ProjectGroupDialogViewModel projectGroup) async {
    if (!_formKey.currentState.validate()) return;

    _setLoading(true);

    await widget.strategy.action(
      _projectGroupsNotifier,
      projectGroup.id,
      _groupNameController.text,
      projectGroup.selectedProjectIds,
    );

    final projectGroupSavingError =
        _projectGroupsNotifier.projectGroupSavingError;

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

  @override
  void dispose() {
    _projectGroupsNotifier.resetFilterName();
    _groupNameController.dispose();
    super.dispose();
  }
}
