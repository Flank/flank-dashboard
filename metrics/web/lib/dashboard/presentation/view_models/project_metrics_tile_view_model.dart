// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';

/// Represents a view model of the metrics of the project.
class ProjectMetricsTileViewModel extends Equatable {
  /// A unique identifier of the project this view model belongs to.
  final String projectId;

  /// A name of the project this view model belongs to.
  final String projectName;

  /// A project build status view model.
  final ProjectBuildStatusViewModel buildStatus;

  /// A coverage circle percentage view model.
  final CoverageViewModel coverage;

  /// A stability circle percentage view model.
  final StabilityViewModel stability;

  /// A build number scorecard metric view model.
  final BuildNumberScorecardViewModel buildNumberMetric;

  /// A performance sparkline graph view model.
  final PerformanceSparklineViewModel performanceSparkline;

  /// A build result bar graph view model.
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
  /// The [buildStatus] defaults to [ProjectBuildStatusViewModel].
  const ProjectMetricsTileViewModel({
    this.projectId,
    this.projectName,
    this.buildStatus = const ProjectBuildStatusViewModel(),
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
    ProjectBuildStatusViewModel buildStatus,
  }) {
    return ProjectMetricsTileViewModel(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      coverage: coverage ?? this.coverage,
      stability: stability ?? this.stability,
      buildNumberMetric: buildNumberMetric ?? this.buildNumberMetric,
      performanceSparkline: performanceSparkline ?? this.performanceSparkline,
      buildResultMetrics: buildResultMetrics ?? this.buildResultMetrics,
      buildStatus: buildStatus ?? this.buildStatus,
    );
  }
}
