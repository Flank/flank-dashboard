import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/presentation/model/adapter/build_number_chart_point_adapter.dart';
import 'package:metrics/features/dashboard/presentation/model/adapter/performance_chart_point_adapter.dart';

/// The store for the project metrics
///
/// Stores the coverage and build metrics
class ProjectMetricsStore {
  final GetProjectCoverage _getCoverage;
  final GetBuildMetrics _getBuildMetrics;
  List<PerformanceChartPointAdapter> _projectPerformanceMetric;
  List<BuildsNumberChartPointAdapter> _projectBuildMetric;
  int _averageBuildTime;
  int _totalBuildNumber;
  Coverage _coverage;

  /// Creates the project metrics store.
  ///
  /// The [_getCoverage] and [_getBuildMetrics] use cases should not be null
  ProjectMetricsStore(this._getCoverage, this._getBuildMetrics)
      : assert(
          _getCoverage != null && _getBuildMetrics != null,
          'The use cases should not be null',
        );

  Coverage get coverage => _coverage;

  List<PerformanceChartPointAdapter> get projectPerformanceMetric =>
      _projectPerformanceMetric;

  List<BuildsNumberChartPointAdapter> get projectBuildMetric =>
      _projectBuildMetric;

  int get averageBuildTime => _averageBuildTime;

  int get totalBuildNumber => _totalBuildNumber;

  /// Load the coverage metric
  Future getCoverage(String projectId) async {
    _coverage = await _getCoverage(ProjectIdParam(projectId: projectId));
  }

  /// Loads the build metrics
  Future getBuildMetrics(String projectId) async {
    final projectBuilds = await _getBuildMetrics(
      ProjectIdParam(projectId: projectId),
    );

    final averageBuildTime = projectBuilds
            .map((build) => build.duration)
            .reduce((value, element) => value + element)
            .inMinutes /
        projectBuilds.length;

    final buildsTimeRange =
        projectBuilds.map((build) => _trimToDay(build.startedAt)).toSet();

    _totalBuildNumber = projectBuilds.length;
    _averageBuildTime = averageBuildTime.round();

    _projectPerformanceMetric = projectBuilds
        .map((build) => PerformanceChartPointAdapter(build))
        .toList()
          ..sort((prev, next) => prev.x.compareTo(next.x));

    _projectBuildMetric = buildsTimeRange.map((day) {
      final builds =
          projectBuilds.where((build) => _trimToDay(build.startedAt) == day);

      return BuildsNumberChartPointAdapter(day, builds.length);
    }).toList();
  }

  /// Trims the date to include only the year, month and day
  DateTime _trimToDay(DateTime buildDate) =>
      DateTime(buildDate.year, buildDate.month, buildDate.day);
}
