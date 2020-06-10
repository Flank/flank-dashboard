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
  final List<ProjectGroup> _testProjectGroups = const [
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

  final List<ProjectSelectorViewModel> _testProjectSelectorViewModels = [
    ProjectSelectorViewModel(id: '1', name: 'name1', isChecked: true),
    ProjectSelectorViewModel(id: '2', name: 'name2', isChecked: false),
  ];

  List<ProjectGroup> _projectGroups;

  ActiveProjectGroupDialogViewModel _activeProjectGroupDialogViewModel;

  List<ProjectSelectorViewModel> _projectSelectorViewModels;

  @override
  List<ProjectGroup> get projectGroups => _projectGroups ?? _testProjectGroups;

  @override
  List<ProjectSelectorViewModel> get projectSelectorViewModels =>
      _projectSelectorViewModels ?? _testProjectSelectorViewModels;

  @override
  ActiveProjectGroupDialogViewModel get activeProjectGroupDialogViewModel =>
      _activeProjectGroupDialogViewModel ??
      _testActiveProjectGroupDialogViewModel;

  @override
  Future<bool> deleteProjectGroup(String projectGroupId) async => null;

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
  String get projectsErrorMessage => null;

  @override
  void resetFirestoreWriteErrorMessage() {}

  @override
  Future<bool> saveProjectGroup(String projectGroupId, String projectGroupName,
      List<String> projectIds) async {
    return null;
  }

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
  List<ProjectGroupCardViewModel> get projectGroupCardViewModels => null;

  @override
  void subscribeToProjectsNameFilter() {}
}
