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
import 'package:metrics/project_groups/presentation/model/project_group_view_model.dart';

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

  /// Holds the error message that occurred during the firestore writing operation.
  String _firestoreWriteErrorMessage;

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

  /// Provides an error description that occurred during the firestore writing operation.
  String get firestoreWriteErrorMessage => _firestoreWriteErrorMessage;

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
  Future<bool> saveProjectGroups(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  ) async {
    resetFirestoreWriteErrorMessage();

    try {
      if (projectGroupId == null) {
        await _addProjectGroupUseCase(
          AddProjectGroupParam(
            projectGroupName,
            projectIds,
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
      await _deleteProjectGroupUseCase(DeleteProjectGroupParam(projectGroupId));
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

  /// Listens to project group updates.
  void _projectGroupListener(List<ProjectGroup> newProjectGroups) {
    if (newProjectGroups == null) return;

    _projectGroupViewModels = newProjectGroups
        .map(
          (projectGroup) => ProjectGroupViewModel(
            id: projectGroup.id,
            name: projectGroup.name,
            projectIds: projectGroup.projectIds,
          ),
        )
        .toList();

    notifyListeners();
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
