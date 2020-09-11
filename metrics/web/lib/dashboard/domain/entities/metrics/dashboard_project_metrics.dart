import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/project_build_status_metrics.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represent the main project metrics available for users
/// to have a quick understanding of project status.
class DashboardProjectMetrics extends Equatable {
  /// A unique identifier of the project these metrics belong to.
  final String projectId;

  /// A status of the build of the project these metrics belong to.
  final ProjectBuildStatusMetrics projectBuildStatusMetrics;

  /// A [BuildNumberMetrics] of project with [projectId].
  final BuildNumberMetrics buildNumberMetrics;

  /// A [PerformanceMetrics] of project with [projectId].
  final PerformanceMetrics performanceMetrics;

  /// A [BuildResultMetrics] of project with [projectId].
  final BuildResultMetrics buildResultMetrics;

  /// A test coverage percent of the project with [projectId].
  final Percent coverage;

  /// A percentage of successful builds to loaded builds.
  final Percent stability;

  @override
  List<Object> get props => [
        projectId,
        projectBuildStatusMetrics,
        buildNumberMetrics,
        performanceMetrics,
        buildResultMetrics,
        coverage,
        stability,
      ];

  /// Creates the [DashboardProjectMetrics].
  const DashboardProjectMetrics({
    this.projectId,
    this.projectBuildStatusMetrics,
    this.buildNumberMetrics,
    this.performanceMetrics,
    this.buildResultMetrics,
    this.coverage,
    this.stability,
  });
}
