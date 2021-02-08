// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/base/presentation/widgets/value_form_field.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_inactive_button.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/toast/widgets/negative_toast.dart';
import 'package:metrics/common/presentation/toast/widgets/positive_toast.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_name_validator.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_projects_validator.dart';
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

  /// Indicates whether the action button is active.
  final ValueNotifier<bool> _isActionButtonActive = ValueNotifier<bool>(false);

  /// Indicates whether this widget is in the loading state or not.
  bool _isLoading = false;

  /// The initial [ProjectGroupDialogViewModel] instance.
  ProjectGroupDialogViewModel _initialViewModel;

  /// A [DeepCollectionEquality] instance used to check the equality of two lists.
  final _equality = const DeepCollectionEquality.unordered();

  @override
  void initState() {
    super.initState();

    _projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );

    _subscribeToProjectErrors();

    _groupNameController.text =
        _projectGroupsNotifier?.projectGroupDialogViewModel?.name;

    _initialViewModel = _projectGroupsNotifier.projectGroupDialogViewModel;

    _subscribeToProjectGroupDialogChanges();
  }

  /// Subscribes to project group dialog changes.
  void _subscribeToProjectGroupDialogChanges() {
    _updateActionButtonState();

    _projectGroupsNotifier.addListener(_updateActionButtonState);
    _groupNameController.addListener(_updateActionButtonState);
  }

  /// Subscribes to project errors.
  void _subscribeToProjectErrors() {
    final errorMessage = _projectGroupsNotifier.projectsErrorMessage;

    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showToast(context, NegativeToast(message: errorMessage));
      });
    }

    _projectGroupsNotifier.addListener(_projectsErrorListener);
  }

  /// Shows the [NegativeToast] with an error message
  /// if the projects error message is not null.
  void _projectsErrorListener() {
    final errorMessage = _projectGroupsNotifier.projectsErrorMessage;

    if (errorMessage != null) {
      showToast(context, NegativeToast(message: errorMessage));
    }
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
          constraints: const BoxConstraints(
            maxWidth: 480.0,
            maxHeight: 726.0,
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
            strategy.title,
            style: dialogTheme.titleTextStyle,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 32.0),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MetricsTextFormField(
                    controller: _groupNameController,
                    hint: ProjectGroupsStrings.nameYourGroup,
                    validator: ProjectGroupNameValidator.validate,
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
                            onChanged:
                                _projectGroupsNotifier.filterByProjectName,
                            prefixIconBuilder: (context, color) {
                              return SvgImage(
                                'icons/search.svg',
                                width: 20.0,
                                height: 20.0,
                                color: color,
                              );
                            },
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
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ValueFormField(
                    autovalidateMode: AutovalidateMode.always,
                    value: projectGroup.selectedProjectIds,
                    validator: ProjectGroupProjectsValidator.validate,
                    builder: (state) {
                      if (state.hasError) {
                        return Text(
                          state.errorText,
                          style: dialogTheme.errorTextStyle,
                        );
                      }

                      return Text(
                        _getCounterText(projectGroup),
                        style: dialogTheme.counterTextStyle,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isActionButtonActive,
                builder: (context, isActionButtonActive, _) {
                  if (isActionButtonActive) {
                    return MetricsPositiveButton(
                      label: buttonText,
                      onPressed: _isLoading
                          ? null
                          : () => _actionCallback(projectGroup),
                    );
                  }

                  return MetricsInactiveButton(
                    label: buttonText,
                  );
                },
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

  /// Updates the state of the action button depending on the
  /// project group dialog values selected by user.
  void _updateActionButtonState() {
    final groupName = _groupNameController.value.text;
    final dialogViewModel = _projectGroupsNotifier?.projectGroupDialogViewModel;
    final List<String> selectedProjectIds = dialogViewModel?.selectedProjectIds;

    if (selectedProjectIds != null &&
        selectedProjectIds.isNotEmpty &&
        _dataIsChanged(groupName, selectedProjectIds)) {
      final groupNameErrorMessage =
          ProjectGroupNameValidator.validate(groupName);
      final selectedProjectIdsErrorMessage =
          ProjectGroupProjectsValidator.validate(selectedProjectIds);

      _isActionButtonActive.value = groupNameErrorMessage == null &&
          selectedProjectIdsErrorMessage == null;
    } else {
      _isActionButtonActive.value = false;
    }
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

    Toast toast;

    if (projectGroupSavingError == null) {
      Navigator.pop(context);
      final message = widget.strategy.getSuccessfulActionMessage(
        _groupNameController.text,
      );
      toast = PositiveToast(message: message);
    } else {
      _setLoading(false);
      toast = NegativeToast(message: projectGroupSavingError);
    }

    showToast(context, toast);
  }

  /// Returns `true` if the data of this dialog is changed,
  /// otherwise, returns `false`.
  bool _dataIsChanged(String groupName, List<String> selectedProjectIds) {
    final initialGroupName = _initialViewModel.name;
    final initialProjectIds = _initialViewModel.selectedProjectIds;

    final groupNameChanged = groupName != initialGroupName;
    final selectedProjectIdsChanged =
        !_equality.equals(initialProjectIds, selectedProjectIds);

    return groupNameChanged || selectedProjectIdsChanged;
  }

  /// Changes the [_isLoading] state to the given [value].
  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  @override
  void dispose() {
    _projectGroupsNotifier.resetFilterName();
    _projectGroupsNotifier.removeListener(_updateActionButtonState);
    _groupNameController.removeListener(_updateActionButtonState);
    _groupNameController.dispose();
    _projectGroupsNotifier.removeListener(_projectsErrorListener);
    _isActionButtonActive.dispose();
    super.dispose();
    _projectGroupsNotifier.resetProjectGroupDialogViewModel();
  }
}
