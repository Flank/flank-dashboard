import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/project_group_add_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/project_group_delete_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/project_group_update_param.dart';
import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:metrics/project_groups/presentation/model/project_group_view_model.dart';

import '../../../common/presentation/strings/common_strings.dart';
import '../../../common/presentation/strings/common_strings.dart';

class ProjectGroupsNotifier extends ChangeNotifier {
  final ReceiveProjectGroupUpdates _receiveProjectGroupUpdates;
  final UpdateProjectGroupUseCase _updateProjectGroupUseCase;
  final DeleteProjectGroupUseCase _deleteProjectGroupUseCase;
  final AddProjectGroupUseCase _addProjectGroupUseCase;

  List<ProjectGroupViewModel> _projectGroupViewModels;

  StreamSubscription _projectGroupsSubscription;

  String _errorMessage;

  String _firestoreWriteErrorMessage;

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

  List<ProjectGroupViewModel> get projectGroupViewModels =>
      _projectGroupViewModels;

  String get errorMessage => _errorMessage;

  String get firestoreWriteErrorMessage => _firestoreWriteErrorMessage;

  Future<void> subscribeToProjectGroups() async {
    final projectGroupsStream = _receiveProjectGroupUpdates();
    _errorMessage = null;
    await _projectGroupsSubscription?.cancel();

    _projectGroupsSubscription = projectGroupsStream.listen(
      _projectGroupListener,
      onError: _errorHandler,
    );
  }

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

  Future<bool> deleteProjectGroup(String projectGroupId) async {
    resetFirestoreWriteErrorMessage();

    try {
      await _deleteProjectGroupUseCase(ProjectGroupDeleteParam(projectGroupId));
    } catch (e) {
      _firestoreWriteErrorHandler(e);
    }

    return _firestoreWriteErrorMessage == null;
  }

  void resetFirestoreWriteErrorMessage() {
    _firestoreWriteErrorMessage = null;
    notifyListeners();
  }

  Future<bool> saveProjectGroups(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  ) async {
    resetFirestoreWriteErrorMessage();

    try {
      if (projectGroupId == null) {
        await _addProjectGroupUseCase(
          ProjectGroupAddParam(
            projectGroupName,
            projectIds,
          ),
        );
      } else {
        await _updateProjectGroupUseCase(
          ProjectGroupUpdateParam(
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

  Future<void> unsubscribeFromProjectGroups() async {
    await _cancelSubscriptions();
    notifyListeners();
  }

  Future<void> _cancelSubscriptions() async {
    await _projectGroupsSubscription?.cancel();
    _projectGroupViewModels = null;
  }

  void _errorHandler(error) {
    if (error is PlatformException) {
      _errorMessage = error.message;
      return notifyListeners();
    }

    _errorMessage = CommonStrings.unknownErrorMessage;
    notifyListeners();
  }

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
