import 'package:flutter/foundation.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/active_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_selector_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// Stub implementation of the [ProjectGroupsNotifier].
///
/// Provides test implementation of the [ProjectGroupsNotifier] methods.
class ProjectGroupsNotifierStub extends ChangeNotifier
    implements ProjectGroupsNotifier {
  final List<ProjectGroup> _projectGroups = const [
    ProjectGroup(id: '1', name: 'name', projectIds: []),
    ProjectGroup(id: '2', name: 'name2', projectIds: []),
  ];

  final ActiveProjectGroupDialogViewModel
      _testActiveProjectGroupDialogViewModel =
      ActiveProjectGroupDialogViewModel(
    id: null,
    name: null,
    selectedProjectIds: [],
  );

  @override
  List<ProjectGroup> get projectGroups => _projectGroups;

  ActiveProjectGroupDialogViewModel _activeProjectGroupDialogViewModel;

  @override
  ActiveProjectGroupDialogViewModel get activeProjectGroupDialogViewModel =>
      _activeProjectGroupDialogViewModel ??
      _testActiveProjectGroupDialogViewModel;

  @override
  Future<bool> deleteProjectGroup(String projectGroupId) async {}

  @override
  List<Project> get filteredProjects => null;

  @override
  String get firestoreWriteErrorMessage => null;

  @override
  void generateActiveProjectGroupViewModel([String projectGroupId]) {
    if (projectGroupId == null) {
      _activeProjectGroupDialogViewModel = ActiveProjectGroupDialogViewModel(
        id: null,
        name: null,
        selectedProjectIds: [],
      );
    } else {
      _activeProjectGroupDialogViewModel = ActiveProjectGroupDialogViewModel(
        id: '1',
        name: 'name',
        selectedProjectIds: [],
      );
    }

    notifyListeners();
  }

  @override
  List<ProjectGroupCardViewModel> get projectGroupViewModels => null;

  @override
  String get projectsErrorMessage => null;

  @override
  void resetFirestoreWriteErrorMessage() {}

  @override
  Future<bool> saveProjectGroup(String projectGroupId, String projectGroupName,
      List<String> projectIds) async {}

  @override
  Future<void> subscribeToProjectGroups() async {}

  @override
  void toggleProjectCheckedStatus({String projectId, bool isChecked}) {}

  @override
  Future<void> unsubscribeFromProjectGroups() async {}

  @override
  String get errorMessage => null;

  @override
  void filterByProjectName(String value) {}

  @override
  void updateProjects(List<Project> projects, String errorMessage) {}

  @override
  List<ProjectSelectorViewModel> get projectSelectorViewModels => null;
}
