import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics_core/src/domain/entities/project.dart';

/// Stub implementation of the [ProjectMetricsNotifier].
///
/// Provides test implementation of the [ProjectMetricsNotifier] methods.
class ProjectsNotifierStub extends ChangeNotifier implements ProjectsNotifier {
  final List<Project> _projects = const [
    Project(id: '1', name: 'name'),
    Project(id: '2', name: 'name2'),
  ];

  @override
  Future<void> subscribeToProjects() async {}

  @override
  String get errorMessage => null;

  @override
  Future<void> unsubscribeFromProjects() async {}

  @override
  List<Project> get projects => _projects;

  @override
  Future<void> updateProjectsSubscription({bool isLoggedIn}) async {}
}
