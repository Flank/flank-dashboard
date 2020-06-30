import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';

/// Stub implementation of the [ProjectMetricsNotifier].
///
/// Provides test implementation of the [ProjectMetricsNotifier] methods.
class ProjectMetricsNotifierStub extends ChangeNotifier
    implements ProjectMetricsNotifier {
  static const ProjectMetricsTileViewModel testProjectMetrics =
      ProjectMetricsTileViewModel(
    projectId: '1',
    projectName: 'project',
    coverage: CoverageViewModel(value: 0.1),
    stability: StabilityViewModel(value: 0.2),
    buildNumberMetric: BuildNumberScorecardViewModel(numberOfBuilds: 0),
    performanceSparkline: PerformanceSparklineViewModel(),
    buildResultMetrics: BuildResultMetricViewModel(),
  );

  /// The list of [ProjectMetricsTileViewModel]s.
  final List<ProjectMetricsTileViewModel> _projectMetrics;

  /// Creates the [ProjectMetricsNotifierStub] with the given [projectsMetrics].
  ///
  /// If [projectsMetrics] is not passed or the `null`
  /// is passed the list containing [testProjectMetrics] used.
  ProjectMetricsNotifierStub({
    List<ProjectMetricsTileViewModel> projectsMetrics,
  }) : _projectMetrics = projectsMetrics;

  @override
  List<ProjectMetricsTileViewModel> get projectsMetricsTileViewModels =>
      _projectMetrics ?? [testProjectMetrics];

  @override
  String get projectsErrorMessage => null;

  @override
  void filterByProjectName(String value) {}

  @override
  Future<void> setProjects(
      List<ProjectModel> newProjectModels, String projectErrorMessage) async {
    return;
  }
}
