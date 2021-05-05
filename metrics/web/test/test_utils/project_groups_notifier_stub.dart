// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/project_groups/presentation/models/project_group_model.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/delete_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';

/// Stub implementation of the [ProjectGroupsNotifier].
///
/// Provides test implementation of the [ProjectGroupsNotifier] methods.
class ProjectGroupsNotifierStub extends ChangeNotifier
    implements ProjectGroupsNotifier {
  /// A test [ProjectCheckboxViewModel]s used in tests.
  static const _projectCheckboxViewModels = [
    ProjectCheckboxViewModel(id: '1', name: 'name1', isChecked: false),
    ProjectCheckboxViewModel(id: '2', name: 'name2', isChecked: false),
  ];

  /// A test [ProjectGroupCardViewModel]s used in tests.
  static const _projectGroupCardViewModels = [
    ProjectGroupCardViewModel(id: '1', name: 'name1', projectsCount: 1),
    ProjectGroupCardViewModel(id: '2', name: 'name2', projectsCount: 2),
  ];

  /// A test [ProjectGroupDialogViewModel] used in tests.
  final _projectGroupDialogViewModel = ProjectGroupDialogViewModel(
    id: '1',
    name: 'name1',
    selectedProjectIds: UnmodifiableListView([]),
  );

  /// A test [DeleteProjectGroupDialogViewModel] used in tests.
  final _deleteProjectGroupDialogViewModel =
      const DeleteProjectGroupDialogViewModel(
    id: '1',
    name: 'name1',
  );

  @override
  bool get hasConfiguredProjects => true;

  @override
  List<ProjectCheckboxViewModel> get projectCheckboxViewModels =>
      _projectCheckboxViewModels;

  @override
  List<ProjectGroupCardViewModel> get projectGroupCardViewModels =>
      _projectGroupCardViewModels;

  @override
  ProjectGroupDialogViewModel get projectGroupDialogViewModel =>
      _projectGroupDialogViewModel;

  @override
  List<ProjectGroupModel> get projectGroupModels => null;

  @override
  String get projectNameFilter => null;

  @override
  String get projectGroupsErrorMessage => null;

  @override
  String get projectsErrorMessage => null;

  @override
  String get projectGroupSavingError => null;

  @override
  DeleteProjectGroupDialogViewModel get deleteProjectGroupDialogViewModel =>
      _deleteProjectGroupDialogViewModel;

  @override
  Future<void> deleteProjectGroup(String projectGroupId) async {}

  @override
  void filterByProjectName(String value) {}

  @override
  Future<void> addProjectGroup(
    String projectGroupName,
    List<String> projectIds,
  ) async {}

  @override
  void resetFilterName() {}

  @override
  Future<void> subscribeToProjectGroups() async {}

  @override
  Future<void> unsubscribeFromProjectGroups() async {}

  @override
  Future<void> updateProjectGroup(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  ) async {}

  @override
  void initDeleteProjectGroupDialogViewModel(String projectGroupId) {}

  @override
  void initProjectGroupDialogViewModel([String projectGroupId]) {}

  @override
  void resetDeleteProjectGroupDialogViewModel() {}

  @override
  void resetProjectGroupDialogViewModel() {}

  @override
  void setProjects(List<ProjectModel> projects,
      [String projectsErrorMessage]) {}

  @override
  void toggleProjectCheckedStatus(String projectId) {}
}
