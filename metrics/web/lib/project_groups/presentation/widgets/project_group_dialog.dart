import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
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
          closeIcon: Image.network(
            'icons/close.svg',
            height: 24.0,
            width: 24.0,
          ),
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
                  child: MetricsTextFormField(
                    controller: _groupNameController,
                    hint: ProjectGroupsStrings.nameYourGroup,
                    validator: ProjectGroupNameValidator.validate,
                  ),
                ),
              ),
              Flexible(
                child: DecoratedContainer(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: dialogTheme.contentBorderColor),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
                        child: MetricsTextFormField(
                          onChanged: _projectGroupsNotifier.filterByProjectName,
                          prefixIcon: Image.network(
                            'icons/search.svg',
                            width: 20.0,
                            height: 20.0,
                          ),
                          hint: CommonStrings.searchForProject,
                        ),
                      ),
                      Expanded(
                        child: ProjectCheckboxList(),
                      ),
                    ],
                  ),
                ),
              ),
              Selector<ProjectGroupsNotifier, String>(
                selector: (_, state) => state.projectSelectionErrorMessage,
                builder: (_, projectsErrorMessage, __) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: projectsErrorMessage == null
                        ? Text(
                            _getCounterText(projectGroup),
                            style: dialogTheme.counterTextStyle,
                          )
                        : Text(
                            projectsErrorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            Expanded(
              child: MetricsPositiveButton(
                label: buttonText,
                onPressed:
                    _isLoading ? null : () => _actionCallback(projectGroup),
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
    if (!_formKey.currentState.validate() ||
        _projectGroupsNotifier.projectSelectionErrorMessage != null) return;

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
