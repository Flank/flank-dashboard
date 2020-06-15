import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrics/common/domain/usecases/receive_project_updates.dart';
import 'package:metrics_core/metrics_core.dart';

/// The [ChangeNotifier] that holds [Project]s data.
class ProjectsNotifier extends ChangeNotifier {

  /// Creates a new instance of the [ProjectsNotifier].
  ProjectsNotifier(
    this._receiveProjectsUpdates,
  ) : assert(
          _receiveProjectsUpdates != null,
          'The use case must not be null',
        );

  /// Provides an ability to receive project updates.
  final ReceiveProjectUpdates _receiveProjectsUpdates;

  /// The stream subscription needed to be able to stop listening
  /// to the project updates.
  StreamSubscription _projectsSubscription;

  /// Holds a list of projects.
  List<Project> _projects;

  /// Holds the error message that occurred during loading projects data.
  String _projectsErrorMessage;

  /// Provides an error description that occurred during loading projects data.
  String get projectsErrorMessage => _projectsErrorMessage;

  /// A list of projects.
  List<Project> get projects => _projects;

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
    _projects = projects;
    notifyListeners();
  }

  /// Saves the error [String] representation to [_errorMessage].
  void _errorHandler(error) {
    if (error is PlatformException) {
      _projectsErrorMessage = error.message;
      notifyListeners();
    }
  }

  /// Cancels created projects subscription.
  Future<void> _cancelSubscription() async {
    await _projectsSubscription?.cancel();
    _projects = null;
  }

  @override
  void dispose() {
    _cancelSubscription(); 
    super.dispose();
  }
}
