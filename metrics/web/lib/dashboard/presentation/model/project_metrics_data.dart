import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_metric_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represents a presentation model of the metrics of the project.
@immutable
class ProjectMetricsData {
  final String projectId;
  final String projectName;
  final Percent coverage;
  final Percent stability;
  final int buildNumberMetric;
  final PerformanceMetricViewModel performanceMetrics;
  final BuildResultMetricViewModel buildResultMetrics;

  /// Creates the [ProjectMetricsData].
  ///
  /// [projectId] is the unique identifier of the project these metrics belong to.
  /// [projectName] is the name of the project these metrics belongs to.
  /// [coverage] is the tests code coverage of the project.
  /// [stability] is the percentage of the successful builds to total builds of the project.
  /// [buildNumberMetric] is the metric that represents the number of builds.
  /// [performanceMetrics] is metric that represents the duration of the builds.
  /// [buildResultMetrics] is the metric that represents the results of the builds.
  const ProjectMetricsData({
    this.projectId,
    this.projectName,
    this.coverage,
    this.stability,
    this.buildNumberMetric,
    this.performanceMetrics = const PerformanceMetricViewModel(),
    this.buildResultMetrics = const BuildResultMetricViewModel(),
  });

  /// Creates a copy of this project metrics but with the given fields replaced with the new values.
  ProjectMetricsData copyWith({
    String projectId,
    String projectName,
    Percent coverage,
    Percent stability,
    int buildNumberMetric,
    PerformanceMetricViewModel performanceMetrics,
    BuildResultMetricViewModel buildResultMetrics,
  }) {
    return ProjectMetricsData(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      coverage: coverage ?? this.coverage,
      stability: stability ?? this.stability,
      buildNumberMetric: buildNumberMetric ?? this.buildNumberMetric,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
      buildResultMetrics: buildResultMetrics ?? this.buildResultMetrics,
    );
  }
}
