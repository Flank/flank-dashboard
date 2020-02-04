import 'dart:math';

import 'package:metrics/features/dashboard/domain/entities/build_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';

/// The store for the project metrics.
///
/// Stores the [Coverage] and [BuildMetrics].
class ProjectMetricsStore {
  final GetProjectCoverage _getCoverage;
  final GetBuildMetrics _getBuildMetrics;
  List<Point<int>> _projectPerformanceMetric;
  List<Point<int>> _projectBuildNumberMetric;
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

  int get averageBuildTime => _buildMetrics.averageBuildTime.inMinutes;

  int get totalBuildNumber => _buildMetrics.totalBuildNumber;

  /// Load the coverage metric.
  Future getCoverage(String projectId) async {
    _coverage = await _getCoverage(ProjectIdParam(projectId: projectId));
  }

  /// Loads the build metrics.
  Future getBuildMetrics(String projectId) async {
    _buildMetrics = await _getBuildMetrics(
      ProjectIdParam(projectId: projectId),
    );

    _projectPerformanceMetric = _buildMetrics.performanceMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.duration.inMilliseconds,
      );
    }).toList();

    _projectBuildNumberMetric = _buildMetrics.buildNumberMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.numberOfBuilds,
      );
    }).toList();
  }
}
