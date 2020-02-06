import 'dart:math';

import 'package:metrics/features/dashboard/domain/entities/build_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/build_result_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/presentation/config/dashboard_config.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';

/// The store for the project metrics.
///
/// Stores the [Coverage] and [BuildMetrics].
class ProjectMetricsStore {
  final GetProjectCoverage _getCoverage;
  final GetBuildMetrics _getBuildMetrics;
  List<Point<int>> _projectPerformanceMetric;
  List<Point<int>> _projectBuildNumberMetric;
  List<BuildResultBarData> _projectBuildResultMetric;
  BuildMetrics _buildMetrics;
  Coverage _coverage;

  /// Creates the project metrics store.
  ///
  /// The [_getCoverage] and [_getBuildMetrics] use cases should not be null.
  ProjectMetricsStore(this._getCoverage, this._getBuildMetrics)
      : assert(
          _getCoverage != null && _getBuildMetrics != null,
          'The use cases should not be null',
        );

  Coverage get coverage => _coverage;

  List<Point<int>> get projectPerformanceMetric => _projectPerformanceMetric;

  List<Point<int>> get projectBuildMetric => _projectBuildNumberMetric;

  List<BuildResultBarData> get projectBuildResultMetric =>
      _projectBuildResultMetric;

  int get averageBuildTime => _buildMetrics.averageBuildTime.inMinutes;

  int get totalBuildNumber => _buildMetrics.totalBuildNumber;

  /// Load the coverage metric.
  Future<void> getCoverage(String projectId) async {
    _coverage = await _getCoverage(ProjectIdParam(projectId: projectId));
  }

  /// Loads the build metrics.
  Future<void> getBuildMetrics(String projectId) async {
    _buildMetrics = await _getBuildMetrics(
      ProjectIdParam(projectId: projectId),
    );

    _getPerformanceMetrics();
    _getBuildNumberMetrics();
    _getBuildResultMetrics();
  }

  /// Creates the [_projectBuildNumberMetric] from [_buildMetrics].
  void _getBuildNumberMetrics() {
    final buildNumberMetrics = _buildMetrics.buildNumberMetrics ?? [];

    if (buildNumberMetrics.isEmpty) {
      _projectBuildNumberMetric = [];
      return;
    }

    _projectBuildNumberMetric = buildNumberMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.numberOfBuilds,
      );
    }).toList();
  }

  /// Creates the [_projectPerformanceMetric] from [_buildMetrics].
  void _getPerformanceMetrics() {
    final performanceMetrics = _buildMetrics.performanceMetrics ?? [];

    if (performanceMetrics.isEmpty) {
      _projectPerformanceMetric = [];
      return;
    }

    _projectPerformanceMetric = performanceMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.duration.inMilliseconds,
      );
    }).toList();
  }

  /// Creates the [_projectBuildResultMetric] from [_buildMetrics].
  void _getBuildResultMetrics() {
    List<BuildResultMetric> buildResults =
        _buildMetrics.buildResultMetrics ?? [];

    if (buildResults.isEmpty) {
      _projectBuildResultMetric = [];
      return;
    }

    if (buildResults.length > DashboardConfig.maxNumberOfBuildResults) {
      buildResults = buildResults.sublist(
        buildResults.length - DashboardConfig.maxNumberOfBuildResults,
      );
    }

    _projectBuildResultMetric = buildResults.map((result) {
      return BuildResultBarData(
        url: result.url,
        result: result.result,
        value: result.duration.inMilliseconds,
      );
    }).toList();
  }
}
