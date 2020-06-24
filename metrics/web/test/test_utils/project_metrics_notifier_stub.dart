import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/dashboard/presentation/models/project_metrics_data.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';

/// Stub implementation of the [ProjectMetricsNotifier].
///
/// Provides test implementation of the [ProjectMetricsNotifier] methods.
class ProjectMetricsNotifierStub extends ChangeNotifier
    implements ProjectMetricsNotifier {
  static const ProjectMetricsData testProjectMetrics = ProjectMetricsData(
    projectId: '1',
    projectName: 'project',
    coverage: CoverageViewModel(value: 0.1),
    stability: StabilityViewModel(value: 0.2),
    buildNumberMetric: 0,
    performanceSparkline: PerformanceSparklineViewModel(),
    buildResultMetrics: BuildResultMetricViewModel(),
  );

  /// The list of [ProjectMetricsData].
  final List<ProjectMetricsData> _projectMetrics;

  /// Creates the [ProjectMetricsNotifierStub] with the given [projectsMetrics].
  ///
  /// If [projectsMetrics] is not passed or the `null`
  /// is passed the list containing [testProjectMetrics] used.
  ProjectMetricsNotifierStub({
    List<ProjectMetricsData> projectsMetrics,
  }) : _projectMetrics = projectsMetrics;

  @override
  List<ProjectMetricsData> get projectsMetrics =>
      _projectMetrics ?? [testProjectMetrics];

  @override
  String get projectsErrorMessage => null;

  @override
  void filterByProjectName(String value) {}

  @override
  Future<void> unsubscribeFromBuildMetrics() async {
    return;
  }

  @override
  void updateProjects(
      List<ProjectModel> newProjectModels, String projectErrorMessage) {
    return;
  }
}
