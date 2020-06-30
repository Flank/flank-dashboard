import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';

/// Represents a view model of the metrics of the project.
class ProjectMetricsTileViewModel extends Equatable {
  /// The unique identifier of the project this view model belongs to.
  final String projectId;

  /// The name of the project this view model belongs to.
  final String projectName;

  /// The coverage circle percentage view model.
  final CoverageViewModel coverage;

  /// The stability circle percentage view model.
  final StabilityViewModel stability;

  /// The build number scorecard metrics view model.
  final BuildNumberScorecardViewModel buildNumberMetric;

  /// The performance sparkline graph view model.
  final PerformanceSparklineViewModel performanceSparkline;

  /// The build result bar graph view model.
  final BuildResultMetricViewModel buildResultMetrics;

  @override
  List<Object> get props => [
        projectId,
        projectName,
        coverage,
        stability,
        buildNumberMetric,
        performanceSparkline,
        buildResultMetrics,
      ];

  /// Creates the [ProjectMetricsTileViewModel].
  ///
  /// The [coverage] defaults to [CoverageViewModel].
  /// The [stability] defaults to [StabilityViewModel].
  const ProjectMetricsTileViewModel({
    this.projectId,
    this.projectName,
    this.coverage = const CoverageViewModel(),
    this.stability = const StabilityViewModel(),
    this.buildNumberMetric,
    this.performanceSparkline,
    this.buildResultMetrics,
  });

  /// Creates a copy of this [ProjectMetricsTileViewModel] but with
  /// the given fields replaced with the new values.
  ProjectMetricsTileViewModel copyWith({
    String projectId,
    String projectName,
    CoverageViewModel coverage,
    StabilityViewModel stability,
    BuildNumberScorecardViewModel buildNumberMetric,
    PerformanceSparklineViewModel performanceSparkline,
    BuildResultMetricViewModel buildResultMetrics,
  }) {
    return ProjectMetricsTileViewModel(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      coverage: coverage ?? this.coverage,
      stability: stability ?? this.stability,
      buildNumberMetric: buildNumberMetric ?? this.buildNumberMetric,
      performanceSparkline: performanceSparkline ?? this.performanceSparkline,
      buildResultMetrics: buildResultMetrics ?? this.buildResultMetrics,
    );
  }
}
