import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represent the main project metrics available for users
/// to have a quick understanding of project status.
class DashboardProjectMetrics extends Equatable {
  /// A unique identifier of the project these metrics belong to.
  final String projectId;

  /// A status of the last build of the project these metrics belong to.
  final BuildStatus lastBuildStatus;

  /// A [BuildNumberMetric] of project with [projectId].
  final BuildNumberMetric buildNumberMetrics;

  /// A [PerformanceMetric] of project with [projectId].
  final PerformanceMetric performanceMetrics;

  /// A [BuildResultMetric] of project with [projectId].
  final BuildResultMetric buildResultMetrics;

  /// A test coverage percent of the project with [projectId].
  final Percent coverage;

  /// A percentage of successful builds to loaded builds.
  final Percent stability;

  @override
  List<Object> get props => [
        projectId,
        lastBuildStatus,
        buildNumberMetrics,
        performanceMetrics,
        buildResultMetrics,
        coverage,
        stability,
      ];

  /// Creates the [DashboardProjectMetrics].
  ///
  /// The [buildNumberMetrics] defaults to an empty [BuildNumberMetric].
  /// The [performanceMetrics] defaults to an empty [PerformanceMetric].
  /// The [buildResultMetrics] defaults to an empty [BuildResultMetric].
  const DashboardProjectMetrics({
    this.projectId,
    this.lastBuildStatus,
    this.buildNumberMetrics = const BuildNumberMetric(),
    this.performanceMetrics = const PerformanceMetric(),
    this.buildResultMetrics = const BuildResultMetric(),
    this.coverage,
    this.stability,
  });
}
