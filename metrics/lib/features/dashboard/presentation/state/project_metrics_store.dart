import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/presentation/model/adapter/build_point_adapter.dart';
import 'package:metrics/features/dashboard/presentation/model/adapter/performance_point_adapter.dart';

import '../../domain/entities/coverage.dart';

class ProjectMetricsStore {
  final GetProjectCoverage _getCoverage;
  final GetBuildMetrics _getBuildMetrics;
  List<PerformancePointAdapter> _projectPerformanceMetric;
  List<BuildPointAdapter> _projectBuildMetric;
  int _averageBuildTime;
  int _totalBuildNumber;
  Coverage _coverage;

  ProjectMetricsStore(this._getCoverage, this._getBuildMetrics);

  Coverage get coverage => _coverage;

  List<PerformancePointAdapter> get projectPerformanceMetric =>
      _projectPerformanceMetric;

  List<BuildPointAdapter> get projectBuildMetric => _projectBuildMetric;

  int get averageBuildTime => _averageBuildTime;

  int get totalBuildNumber => _totalBuildNumber;

  Future getCoverage(String projectId) async {
    _coverage = await _getCoverage(ProjectIdParam(projectId: projectId));
  }

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
        .map((build) => PerformancePointAdapter(build))
        .toList()
          ..sort((prev, next) => prev.x.compareTo(next.x));

    _projectBuildMetric = buildsTimeRange.map((day) {
      final builds =
          projectBuilds.where((build) => _trimToDay(build.startedAt) == day);

      return BuildPointAdapter(day, builds.length);
    }).toList();
  }

  DateTime _trimToDay(DateTime buildDate) =>
      DateTime(buildDate.year, buildDate.month, buildDate.day);
}
