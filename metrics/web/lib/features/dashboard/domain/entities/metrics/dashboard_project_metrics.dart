import 'package:equatable/equatable.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represent the main project metrics available for users
/// to have a quick understanding of project status.
class DashboardProjectMetrics extends Equatable {
  final String projectId;
  final BuildNumberMetric buildNumberMetrics;
  final PerformanceMetric performanceMetrics;
  final BuildResultMetric buildResultMetrics;
  final Percent coverage;
  final Percent stability;

  @override
  List<Object> get props => [
        projectId,
        buildNumberMetrics,
        performanceMetrics,
        buildResultMetrics,
        coverage,
        stability,
      ];

  /// Creates the [DashboardProjectMetrics].
  ///
  /// [projectId] is the unique identifier of the project these metrics belong to.
  /// [buildNumberMetrics] is the [BuildNumberMetric] of project with [projectId].
  /// [performanceMetrics] is the [PerformanceMetric] of project with [projectId].
  /// [buildResultMetrics] is the [BuildResultMetric] of project with [projectId].
  /// [coverage] is the test coverage percent of the project with [projectId].
  /// [stability] is the percentage of successful builds to loaded builds.
  const DashboardProjectMetrics({
    this.projectId,
    this.buildNumberMetrics = const BuildNumberMetric(),
    this.performanceMetrics = const PerformanceMetric(),
    this.buildResultMetrics = const BuildResultMetric(),
    this.coverage = const Percent(0.0),
    this.stability = const Percent(0.0),
  });
}
