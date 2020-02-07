import 'dart:math';

import 'package:metrics/features/dashboard/domain/entities/build_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';

/// The store for the project metrics.
///
/// Stores the [Coverage] and [BuildMetrics].
class ProjectMetricsStore {
  final GetProjectCoverage _getCoverage;
  final GetBuildMetrics _getBuildMetrics;
  List<Point<int>> _projectPerformanceMetrics;
  List<Point<int>> _projectBuildNumberMetrics;
  List<BuildResultBarData> _projectBuildResultMetrics;
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

  List<Point<int>> get projectPerformanceMetrics => _projectPerformanceMetrics;

  List<Point<int>> get projectBuildNumberMetrics => _projectBuildNumberMetrics;

  List<BuildResultBarData> get projectBuildResultMetrics =>
      _projectBuildResultMetrics;

  int get averageBuildTime => _buildMetrics?.averageBuildTime?.inMinutes;

  int get totalBuildNumber => _buildMetrics?.totalBuildNumber;

  /// Load the coverage metric.
  Future<void> getCoverage(String projectId) async {
    _coverage = await _getCoverage(ProjectIdParam(projectId: projectId));
  }

  /// Loads the build metrics.
  Future<void> getBuildMetrics(String projectId) async {
    _buildMetrics = await _getBuildMetrics(
      ProjectIdParam(projectId: projectId),
    );

    if (_buildMetrics == null) return;

    _getPerformanceMetrics();
    _getBuildNumberMetrics();
    _getBuildResultMetrics();
  }

  /// Creates the [_projectBuildNumberMetrics] from [_buildMetrics].
  void _getBuildNumberMetrics() {
    final buildNumberMetrics = _buildMetrics.buildNumberMetrics ?? [];

    if (buildNumberMetrics.isEmpty) {
      _projectBuildNumberMetrics = [];
      return;
    }

    _projectBuildNumberMetrics = buildNumberMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.numberOfBuilds,
      );
    }).toList();
  }

  /// Creates the [_projectPerformanceMetrics] from [_buildMetrics].
  void _getPerformanceMetrics() {
    final performanceMetrics = _buildMetrics.performanceMetrics ?? [];

    if (performanceMetrics.isEmpty) {
      _projectPerformanceMetrics = [];
      return;
    }

    _projectPerformanceMetrics = performanceMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.duration.inMilliseconds,
      );
    }).toList();
  }

  /// Creates the [_projectBuildResultMetrics] from [_buildMetrics].
  void _getBuildResultMetrics() {
    final buildResults = _buildMetrics.buildResultMetrics ?? [];

    if (buildResults.isEmpty) {
      _projectBuildResultMetrics = [];
      return;
    }

    _projectBuildResultMetrics = buildResults.map((result) {
      return BuildResultBarData(
        url: result.url,
        result: result.result,
        value: result.duration.inMilliseconds,
      );
    }).toList();
  }
}
