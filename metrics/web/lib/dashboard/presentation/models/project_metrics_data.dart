import 'dart:math';

import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/dashboard/presentation/models/build_result_bar_data.dart';

/// Represents a presentation model of the metrics of the project.
@immutable
class ProjectMetricsData {
  final String projectId;
  final String projectName;
  final CoverageViewModel coverage;
  final StabilityViewModel stability;
  final int buildNumberMetric;
  final int averageBuildDurationInMinutes;
  final List<Point<int>> performanceMetrics;
  final List<BuildResultBarData> buildResultMetrics;

  /// Creates the [ProjectMetricsData].
  ///
  /// [projectId] is the unique identifier of the project these metrics belong to.
  /// [projectName] is the name of the project these metrics belongs to.
  /// [coverage] is the view model represents the tests code coverage of the project.
  /// [stability] is the view model represents the percentage of the successful builds to total builds of the project.
  /// [buildNumberMetric] is the metric that represents the number of builds.
  /// [averageBuildDurationInMinutes] is the average duration in minutes of the single build.
  /// [performanceMetrics] is metric that represents the duration of the builds.
  /// [buildResultMetrics] is the metric that represents the results of the builds.
  const ProjectMetricsData({
    this.projectId,
    this.projectName,
    this.coverage = const CoverageViewModel(),
    this.stability = const StabilityViewModel(),
    this.buildNumberMetric,
    this.averageBuildDurationInMinutes,
    this.performanceMetrics,
    this.buildResultMetrics,
  });

  /// Creates a copy of this project metrics but with the given fields replaced with the new values.
  ProjectMetricsData copyWith({
    String projectId,
    String projectName,
    CoverageViewModel coverage,
    StabilityViewModel stability,
    int buildNumberMetric,
    int averageBuildDurationInMinutes,
    List<Point<int>> performanceMetrics,
    List<BuildResultBarData> buildResultMetrics,
  }) {
    return ProjectMetricsData(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      coverage: coverage ?? this.coverage,
      stability: stability ?? this.stability,
      buildNumberMetric: buildNumberMetric ?? this.buildNumberMetric,
      averageBuildDurationInMinutes:
          averageBuildDurationInMinutes ?? this.averageBuildDurationInMinutes,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
      buildResultMetrics: buildResultMetrics ?? this.buildResultMetrics,
    );
  }
}
