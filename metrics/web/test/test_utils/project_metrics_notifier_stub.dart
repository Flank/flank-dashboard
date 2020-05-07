import 'package:flutter/cupertino.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics_core/metrics_core.dart';

/// Stub implementation of the [ProjectMetricsNotifier].
///
/// Provides test implementation of the [ProjectMetricsNotifier] methods.
class ProjectMetricsNotifierStub extends ChangeNotifier
    implements ProjectMetricsNotifier {
  static const testProjectMetrics = ProjectMetricsData(
    projectId: '1',
    projectName: 'project',
    coverage: Percent(0.1),
    stability: Percent(0.2),
    buildNumberMetric: 0,
    averageBuildDurationInMinutes: 1,
    performanceMetrics: [],
    buildResultMetrics: [],
  );

  /// The list of [ProjectMetricsData].
  final List<ProjectMetricsData> _projectMetrics;

  /// Creates the [ProjectMetricsNotifierStub] with the given [projectsMetrics].
  ///
  /// If [projectsMetrics] is not passed or the `null`
  /// is passed the list containing [testProjectMetrics] used.
  ProjectMetricsNotifierStub({
    List<ProjectMetricsData> projectsMetrics,
  }) : _projectMetrics = projectsMetrics ?? const [testProjectMetrics];

  @override
  List<ProjectMetricsData> get projectsMetrics => _projectMetrics;

  @override
  Future<void> subscribeToProjects() async {}

  @override
  String get errorMessage => null;

  @override
  Future<void> unsubscribeFromProjects() async {}
}
