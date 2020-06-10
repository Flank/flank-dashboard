import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics_core/metrics_core.dart';

/// The [ChangeNotifier] that holds the projects state.
///
/// Stores the [Project]s data.
class ProjectsNotifier extends ChangeNotifier {

  /// Creates the projects store.
  ///
  /// The provided use cases should not be null.
  ProjectsNotifier(
    this._receiveProjectsUpdates,
  ) : assert(
          _receiveProjectsUpdates != null,
          'The use case should not be null',
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

  /// Subscribes to projects and its metrics.
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

  Future<void> updateProjectsSubscription({bool isLoggedIn}) async {
    if (isLoggedIn) {
      await subscribeToProjects();
    } else {
      await unsubscribeFromProjects();
    }
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
