import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:metrics/project_groups/presentation/view_models/delete_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rxdart/rxdart.dart';

/// The [ChangeNotifier] that holds [ProjectGroup]s data.
class ProjectGroupsNotifier extends ChangeNotifier {
  /// Provides an ability to receive project group updates.
  final ReceiveProjectGroupUpdates _receiveProjectGroupUpdates;

  /// Provides an ability to update the project group.
  final UpdateProjectGroupUseCase _updateProjectGroupUseCase;

  /// Provides an ability to delete the project group.
  final DeleteProjectGroupUseCase _deleteProjectGroupUseCase;

  /// Provides an ability to add the project group.
  final AddProjectGroupUseCase _addProjectGroupUseCase;

  /// A [PublishSubject] that provides an ability to filter projects by the name.
  final _projectNameFilterSubject = PublishSubject<String>();

  /// The stream subscription needed to be able to stop listening
  /// to the project group updates.
  StreamSubscription _projectGroupsSubscription;

  /// Holds the error message that occurred during updating projects data.
  String _projectsErrorMessage;

  /// Holds the [ProjectGroupPersistentStoreErrorMessage] that occurred
  /// during loading project groups data.
  PersistentStoreErrorMessage _projectGroupsErrorMessage;

  /// Holds the [ProjectGroupPersistentStoreErrorMessage] that occurred
  /// during the project group saving.
  PersistentStoreErrorMessage _projectGroupSavingError;

  /// A [List] that holds all loaded [ProjectGroup].
  List<ProjectGroup> _projectGroups;

  /// A [List] that holds view models of all loaded [ProjectGroup].
  List<ProjectGroupCardViewModel> _projectGroupCardViewModels;

  /// A [List] that holds view models of all loaded [Project].
  List<ProjectCheckboxViewModel> _projectCheckboxViewModels;

  /// Holds the data for a project group dialog.
  ProjectGroupDialogViewModel _projectGroupDialogViewModel;

  /// Holds the data for a project group delete dialog.
  DeleteProjectGroupDialogViewModel _deleteProjectGroupDialogViewModel;

  /// An optional filter value that represents a part (or full) project name
  /// used to limit the displayed data.
  String _projectNameFilter;

  /// Provides an error description that occurred during loading project groups data.
  String get projectGroupsErrorMessage => _projectGroupsErrorMessage?.message;

  /// Provides an error description that occurred during loading projects data.
  String get projectsErrorMessage => _projectsErrorMessage;

  /// Provides an error description that occurred during the
  /// project group saving operation.
  String get projectGroupSavingError => _projectGroupSavingError?.message;

  /// Provides a list of [ProjectCheckboxViewModel], filtered by the project name filter.
  List<ProjectCheckboxViewModel> get projectCheckboxViewModels {
    if (_projectNameFilter == null || _projectCheckboxViewModels == null) {
      return _projectCheckboxViewModels;
    }

    return _projectCheckboxViewModels
        .where((project) => project.name
            .toLowerCase()
            .contains(_projectNameFilter.toLowerCase()))
        .toList();
  }

  /// Provides a list of project group card view models.
  List<ProjectGroupCardViewModel> get projectGroupCardViewModels =>
      _projectGroupCardViewModels;

  /// Provides data for a project group dialog.
  ProjectGroupDialogViewModel get projectGroupDialogViewModel =>
      _projectGroupDialogViewModel;

  /// Provides data for a project group delete dialog.
  DeleteProjectGroupDialogViewModel get deleteProjectGroupDialogViewModel =>
      _deleteProjectGroupDialogViewModel;

  /// Creates a new instance of the [ProjectGroupsNotifier].
  ///
  /// The given use cases must not be null.
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
          'The use cases must not be null',
        ) {
    _subscribeToProjectsNameFilter();
  }

  /// Subscribes to a projects name filter.
  void _subscribeToProjectsNameFilter() {
    _projectNameFilterSubject
        .debounceTime(DurationConstants.debounce)
        .listen((value) {
      _projectNameFilter = value;
      notifyListeners();
    });
  }

  /// Adds projects filter using [value] provided.
  void filterByProjectName(String value) {
    _projectNameFilterSubject.add(value);
  }

  /// Initiates the [DeleteProjectGroupDialogViewModel] using
  /// the given [projectGroupId].
  void initDeleteProjectGroupDialogViewModel(String projectGroupId) {
    final projectGroup = _projectGroups.firstWhere(
      (projectGroup) => projectGroup.id == projectGroupId,
      orElse: () => null,
    );

    if (projectGroup == null) return;

    _deleteProjectGroupDialogViewModel = DeleteProjectGroupDialogViewModel(
      id: projectGroup?.id,
      name: projectGroup?.name,
    );

    notifyListeners();
  }

  /// Sets the [DeleteProjectGroupDialogViewModel] to null.
  void resetDeleteProjectGroupDialogViewModel() {
    _deleteProjectGroupDialogViewModel = null;
  }

  /// Initiates the [ProjectGroupDialogViewModel] using the given [projectGroupId].
  void initProjectGroupDialogViewModel([String projectGroupId]) {
    final projectGroup = _projectGroups.firstWhere(
      (projectGroup) => projectGroup.id == projectGroupId,
      orElse: () => null,
    );

    final projectIds = projectGroup?.projectIds ?? [];

    _projectCheckboxViewModels = _projectCheckboxViewModels
        .map(
          (project) => ProjectCheckboxViewModel(
            id: project.id,
            name: project.name,
            isChecked: projectIds?.contains(project.id),
          ),
        )
        .toList();

    _projectGroupDialogViewModel = ProjectGroupDialogViewModel(
      id: projectGroup?.id,
      name: projectGroup?.name,
      selectedProjectIds: List<String>.from(projectIds),
    );

    notifyListeners();
  }

  /// Sets the [ProjectGroupDialogViewModel] to null.
  void resetProjectGroupDialogViewModel() {
    _projectGroupDialogViewModel = null;
  }

  /// Sets the project name filter to null.
  void resetFilterName() {
    _projectNameFilter = null;
  }

  /// Changes a checked status to an opposite for the [ProjectCheckboxViewModel]
  /// by the [projectId].
  void toggleProjectCheckedStatus({String projectId}) {
    if (projectId == null) return;

    final projectIds = _projectGroupDialogViewModel.selectedProjectIds;
    final isChecked = projectIds.contains(projectId);

    if (isChecked) {
      projectIds.remove(projectId);
    } else {
      projectIds.add(projectId);
    }

    final projectIndex = _projectCheckboxViewModels
        .indexWhere((project) => project.id == projectId);

    final project = _projectCheckboxViewModels[projectIndex];

    _projectCheckboxViewModels[projectIndex] = ProjectCheckboxViewModel(
      id: project.id,
      name: project.name,
      isChecked: !isChecked,
    );

    _projectGroupDialogViewModel = ProjectGroupDialogViewModel(
      id: _projectGroupDialogViewModel.id,
      name: _projectGroupDialogViewModel.name,
      selectedProjectIds: projectIds,
    );

    notifyListeners();
  }

  /// Subscribes to project groups.
  Future<void> subscribeToProjectGroups() async {
    final projectGroupsStream = _receiveProjectGroupUpdates();
    _projectGroupsErrorMessage = null;
    await _projectGroupsSubscription?.cancel();
    _projectGroupsSubscription = projectGroupsStream.listen(
      _projectGroupsListener,
      onError: _errorHandler,
    );
  }

  /// Unsubscribes from project groups.
  Future<void> unsubscribeFromProjectGroups() async {
    await _cancelSubscriptions();
    notifyListeners();
  }

  /// Creates the project group data with the given [projectGroupId],
  /// [projectGroupName], and [projectIds].
  Future<void> addProjectGroup(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  ) async {
    _resetProjectGroupSavingErrorMessage();

    try {
      await _addProjectGroupUseCase(
        AddProjectGroupParam(
          projectGroupName: projectGroupName,
          projectIds: projectIds,
        ),
      );
    } on PersistentStoreException catch (exception) {
      _projectGroupSavingErrorHandler(exception.code);
    }
  }

  /// Updates the project group data with the given [projectGroupId],
  /// [projectGroupName], and [projectIds].
  Future<void> updateProjectGroup(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  ) async {
    _resetProjectGroupSavingErrorMessage();

    try {
      await _updateProjectGroupUseCase(
        UpdateProjectGroupParam(
          projectGroupId,
          projectGroupName,
          projectIds,
        ),
      );
    } on PersistentStoreException catch (exception) {
      _projectGroupSavingErrorHandler(exception.code);
    }
  }

  /// Deletes the project group with the given [projectGroupId].
  Future<void> deleteProjectGroup(String projectGroupId) async {
    _resetProjectGroupSavingErrorMessage();

    try {
      await _deleteProjectGroupUseCase(
        DeleteProjectGroupParam(projectGroupId: projectGroupId),
      );
    } on PersistentStoreException catch (exception) {
      _projectGroupSavingErrorHandler(exception.code);
    }
  }

  /// Resets the [projectGroupSavingErrorMessage].
  void _resetProjectGroupSavingErrorMessage() {
    _projectGroupSavingError = null;
    notifyListeners();
  }

  /// Sets current project with a loading error message to the given [projects]
  /// and [projectsErrorMessage] respectively.
  void setProjects(
    List<ProjectModel> projects, [
    String projectsErrorMessage,
  ]) {
    _projectsErrorMessage = projectsErrorMessage;

    _refreshProjectCheckboxViewModels(projects);
  }

  /// Refreshes a [ProjectCheckboxViewModel] using the given [projects].
  void _refreshProjectCheckboxViewModels(List<ProjectModel> projects) {
    if (projects == null) {
      _projectCheckboxViewModels = null;
      notifyListeners();
      return;
    }

    final projectIds = _projectGroupDialogViewModel?.selectedProjectIds ?? [];
    _projectCheckboxViewModels = projects
        .map((project) => ProjectCheckboxViewModel(
              id: project.id,
              name: project.name,
              isChecked: projectIds.contains(project.id),
            ))
        .toList();
    notifyListeners();
  }

  /// Updates the current project groups with the given [newProjectGroups] list.
  void _projectGroupsListener(List<ProjectGroup> newProjectGroups) {
    if (newProjectGroups == null) return;

    _projectGroups = newProjectGroups;
    _projectGroupCardViewModels = newProjectGroups
        .map((project) => ProjectGroupCardViewModel(
              id: project.id,
              name: project.name,
              projectsCount: project.projectIds.length,
            ))
        .toList();

    notifyListeners();
  }

  /// Cancels created subscription.
  Future<void> _cancelSubscriptions() async {
    await _projectGroupsSubscription?.cancel();
    _projectGroups = null;
  }

  /// Handles an [error] occurred in project groups stream.
  void _errorHandler(error) {
    if (error is PersistentStoreException) {
      _projectGroupsErrorMessage = PersistentStoreErrorMessage(
        error.code,
      );

      notifyListeners();
    }
  }

  /// Handles an error occurred during saving the project group.
  void _projectGroupSavingErrorHandler(PersistentStoreErrorCode code) {
    _projectGroupSavingError = PersistentStoreErrorMessage(code);
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    _projectNameFilterSubject.close();
    super.dispose();
  }
}
