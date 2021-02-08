// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/domain/usecases/receive_project_updates.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// The [ChangeNotifier] that holds [Project]s data.
class ProjectsNotifier extends ChangeNotifier {
  /// Provides an ability to receive project updates.
  final ReceiveProjectUpdates _receiveProjectsUpdates;

  /// The stream subscription needed to be able to stop listening
  /// to the project updates.
  StreamSubscription _projectsSubscription;

  /// Holds a list of project models.
  List<ProjectModel> _projectModels;

  /// Holds the [PersistentStoreErrorMessage] that occurred during loading
  /// projects data.
  PersistentStoreErrorMessage _projectsErrorMessage;

  /// Provides an error description that occurred during loading projects data.
  String get projectsErrorMessage => _projectsErrorMessage?.message;

  /// A list of project models.
  List<ProjectModel> get projectModels => _projectModels;

  /// Creates a new instance of the [ProjectsNotifier].
  ProjectsNotifier(
    this._receiveProjectsUpdates,
  ) : assert(
          _receiveProjectsUpdates != null,
          'The use case must not be null',
        );

  /// Subscribes to projects updates.
  Future<void> subscribeToProjects() async {
    final projectsStream = _receiveProjectsUpdates();
    _projectsErrorMessage = null;
    await _projectsSubscription?.cancel();

    _projectsSubscription = projectsStream.listen(
      _projectsListener,
      onError: _errorHandler,
    );
  }

  /// Unsubscribes from projects.
  Future<void> unsubscribeFromProjects() async {
    await _cancelSubscription();
    notifyListeners();
  }

  /// Listens to project updates.
  void _projectsListener(List<Project> projects) {
    if (projects == null) return;

    _projectModels = projects
        .map(
          (project) => ProjectModel(id: project.id, name: project.name),
        )
        .toList();

    notifyListeners();
  }

  /// Handles an [error] occurred in projects stream.
  void _errorHandler(error) {
    if (error is PersistentStoreException) {
      _projectsErrorMessage = PersistentStoreErrorMessage(error.code);
      notifyListeners();
    }
  }

  /// Cancels created projects subscription.
  Future<void> _cancelSubscription() async {
    await _projectsSubscription?.cancel();
    _projectModels = null;
  }

  @override
  void dispose() {
    _cancelSubscription();
    super.dispose();
  }
}
