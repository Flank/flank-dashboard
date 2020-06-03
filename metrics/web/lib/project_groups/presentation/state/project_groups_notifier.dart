import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:metrics/project_groups/presentation/view_models/active_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_selector_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// The [ChangeNotifier] that holds the project groups state.
///
/// Stores the [ProjectGroupViewModel]s.
class ProjectGroupsNotifier extends ChangeNotifier {
  /// Provides an ability to receive project group updates.
  final ReceiveProjectGroupUpdates _receiveProjectGroupUpdates;

  /// Provides an ability to update the project group.
  final UpdateProjectGroupUseCase _updateProjectGroupUseCase;

  /// Provides an ability to delete the project group.
  final DeleteProjectGroupUseCase _deleteProjectGroupUseCase;

  /// Provides an ability to add the project group.
  final AddProjectGroupUseCase _addProjectGroupUseCase;

  /// A [List] that holds [ProjectGroupViewModel]s
  List<ProjectGroupViewModel> _projectGroupViewModels;

  /// The stream subscription needed to be able to stop listening
  /// to the project group updates.
  StreamSubscription _projectGroupsSubscription;

  /// Holds the error message that occurred during loading project groups data.
  String _errorMessage;

  String _projectsErrorMessage;

  /// Holds the error message that occurred during the firestore writing operation.
  String _firestoreWriteErrorMessage;

  /// Holds a list of projects.
  List<Project> _projects;

  List<ProjectGroup> _projectGroups;

  /// Optional filter value that represents a part (or full) project name used to limit the displayed data.
  String _projectNameFilter;

  /// Creates the project groups store.
  ///
  /// The provided use cases should not be null.
  ProjectGroupsNotifier(
    this._receiveProjectGroupUpdates,
    this._addProjectGroupUseCase,
    this._updateProjectGroupUseCase,
    this._deleteProjectGroupUseCase,
  ) : assert(
          _receiveProjectGroupUpdates != null &&
              _addProjectGroupUseCase != null &&
              _updateProjectGroupUseCase != null &&
              _deleteProjectGroupUseCase != null,
          'The use cases should not be null',
        );

  /// Provides a list of [ProjectGroupViewModel].
  List<ProjectGroupViewModel> get projectGroupViewModels =>
      _projectGroupViewModels;

  /// Provides an error description that occurred during loading project groups data.
  String get errorMessage => _errorMessage;

  String get projectsErrorMessage => _projectsErrorMessage;

  /// Provides an error description that occurred during the firestore writing operation.
  String get firestoreWriteErrorMessage => _firestoreWriteErrorMessage;

  /// A list of projects.
  List<Project> get filteredProjects {
    if (_projectNameFilter == null || _projects == null) {
      return _projects;
    }

    return _projects
        .where((project) => project.name
        .toLowerCase()
        .contains(_projectNameFilter.toLowerCase()))
        .toList();
  }

  List<ProjectGroup> get projectGroups => _projectGroups;

  ActiveProjectGroupDialogViewModel _activeProjectGroupDialogViewModel;
  ActiveProjectGroupDialogViewModel get activeProjectGroupDialogViewModel =>
      _activeProjectGroupDialogViewModel;

  /// Adds project metrics filter using [value] provided.
  void filterByProjectName(String value) {
    _projectNameFilter = value;

    final projectIds = _activeProjectGroupDialogViewModel.projectIds;
    final projectSelectorViewModels = filteredProjects
        .map(
          (project) => ProjectSelectorViewModel(
        id: project.id,
        name: project.name,
        isChecked: projectIds.contains(project.id),
      ),
    )
        .toList();

    _activeProjectGroupDialogViewModel = ActiveProjectGroupDialogViewModel(
      id: _activeProjectGroupDialogViewModel.id,
      name: _activeProjectGroupDialogViewModel.name,
      projectSelectorViewModels: projectSelectorViewModels,
      projectIds: projectIds,
    );

    notifyListeners();
  }

  void generateActiveProjectGroupViewModel([String projectGroupId]) {
    final projectGroup = _projectGroups.firstWhere(
      (projectGroup) => projectGroup.id == projectGroupId,
      orElse: () => null,
    );

    final projectIds = projectGroup?.projectIds ?? [];
    final projectSelectorViewModels = _projects
        .map(
          (project) => ProjectSelectorViewModel(
            id: project.id,
            name: project.name,
            isChecked: projectIds.contains(project.id),
          ),
        )
        .toList();

    _activeProjectGroupDialogViewModel = ActiveProjectGroupDialogViewModel(
      id: projectGroup?.id,
      name: projectGroup?.name,
      projectSelectorViewModels: projectSelectorViewModels,
      projectIds: projectIds,
    );

    notifyListeners();
  }

  void toggleProjectCheckedStatus({String projectId, bool isChecked}) {
    final projectIds = List<String>.from(_activeProjectGroupDialogViewModel.projectIds);
    if (isChecked) {
      projectIds.add(projectId);
    } else {
      projectIds.remove(projectId);
    }

    final projectSelectorViewModels = _projects
        .map(
          (project) => ProjectSelectorViewModel(
            id: project.id,
            name: project.name,
            isChecked: projectIds.contains(project.id),
          ),
        )
        .toList();

    _activeProjectGroupDialogViewModel = ActiveProjectGroupDialogViewModel(
      id: _activeProjectGroupDialogViewModel.id,
      name: _activeProjectGroupDialogViewModel.name,
      projectSelectorViewModels: projectSelectorViewModels,
      projectIds: projectIds,
    );

    notifyListeners();
  }

  /// Subscribes to project groups.
  Future<void> subscribeToProjectGroups() async {
    final projectGroupsStream = _receiveProjectGroupUpdates();
    _errorMessage = null;
    await _projectGroupsSubscription?.cancel();

    _projectGroupsSubscription = projectGroupsStream.listen(
      _projectGroupListener,
      onError: _errorHandler,
    );
  }

  /// Unsubscribes from project groups.
  Future<void> unsubscribeFromProjectGroups() async {
    await _cancelSubscriptions();
    notifyListeners();
  }

  /// Saves project group data into Firestore with the given [projectGroupName],
  /// [projectIds].
  ///
  /// If [projectIds] is null, a new project group is added,
  /// otherwise existing ones are updated.
  Future<bool> saveProjectGroup(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  ) async {
    resetFirestoreWriteErrorMessage();

    try {
      if (projectGroupId == null) {
        await _addProjectGroupUseCase(
          AddProjectGroupParam(
            projectGroupName: projectGroupName,
            projectIds: projectIds,
          ),
        );
      } else {
        await _updateProjectGroupUseCase(
          UpdateProjectGroupParam(
            projectGroupId,
            projectGroupName,
            projectIds,
          ),
        );
      }
    } catch (e) {
      _firestoreWriteErrorHandler(e);
    }

    return _firestoreWriteErrorMessage == null;
  }

  /// Deletes project group data from Firestore with the given [projectGroupId].
  Future<bool> deleteProjectGroup(String projectGroupId) async {
    resetFirestoreWriteErrorMessage();

    try {
      await _deleteProjectGroupUseCase(
        DeleteProjectGroupParam(projectGroupId: projectGroupId),
      );
    } catch (e) {
      _firestoreWriteErrorHandler(e);
    }

    return _firestoreWriteErrorMessage == null;
  }

  /// Set [_firestoreWriteErrorMessage] to null.
  void resetFirestoreWriteErrorMessage() {
    _firestoreWriteErrorMessage = null;
    notifyListeners();
  }

  /// Update list of projects.
  void updateProjects(List<Project> projects, String errorMessage) {
    _projects = projects;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  /// Listens to project group updates.
  void _projectGroupListener(List<ProjectGroup> newProjectGroups) {
    if (newProjectGroups == null) return;

    _projectGroups = newProjectGroups;

    notifyListeners();

    // _projectGroupViewModels = newProjectGroups
    // .map(
    //   (projectGroup) => ProjectGroupViewModel(
    //     id: projectGroup.id,
    //     name: projectGroup.name,
    //     projectIds: projectGroup.projectIds,
    //   ),
    // )
    // .toList();

    // we need to regenerate a list of project view models ( but all data will reset)
    // if (_editProjectGroupViewModel != null) {
    //   generateEditProjectGroupViewModel(_editProjectGroupViewModel.id);
    // }
  }

  /// Cancels created subscription.
  Future<void> _cancelSubscriptions() async {
    await _projectGroupsSubscription?.cancel();
    _projectGroupViewModels = null;
  }

  /// Saves the error [String] representation to [_errorMessage].
  void _errorHandler(error) {
    if (error is PlatformException) {
      _errorMessage = error.message;
      return notifyListeners();
    }

    _errorMessage = CommonStrings.unknownErrorMessage;
    notifyListeners();
  }

  /// Saves the error [String] representation to [_firestoreWriteErrorMessage].
  void _firestoreWriteErrorHandler(error) {
    _firestoreWriteErrorMessage = CommonStrings.unknownErrorMessage;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }
}

class ProjectGroupCardViewModel {
  final String id;
  final String name;
  final int projectsCount;

  ProjectGroupCardViewModel({
    this.id,
    this.name,
    this.projectsCount,
  });
}
