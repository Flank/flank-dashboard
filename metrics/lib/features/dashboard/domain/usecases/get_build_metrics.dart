import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/entities/build_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/build_number_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/build_result_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/performance_metric.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';

/// [UseCase] to load the project metrics.
class GetBuildMetrics implements UseCase<BuildMetrics, ProjectIdParam> {
  static const int maxNumberOfBuildResults = 14;
  final MetricsRepository _repository;

  GetBuildMetrics(this._repository);

  @override
  Future<BuildMetrics> call(ProjectIdParam param) async {
    final builds = await _repository.getProjectBuilds(param.projectId);

    final averageBuildTime = _getAverageBuildTime(builds);
    final performanceMetrics = _getPerformanceMetrics(builds);
    final buildNumberMetrics = _getBuildNumberMetrics(builds);
    final buildResultMetrics = _getBuildResultMetrics(builds);

    return BuildMetrics(
      buildNumberMetrics: buildNumberMetrics,
      performanceMetrics: performanceMetrics,
      buildResultMetrics: buildResultMetrics,
      averageBuildTime: averageBuildTime,
      totalBuildNumber: builds.length,
    );
  }

  /// Calculates the average build time.
  Duration _getAverageBuildTime(List<Build> builds) {
    final buildDurations = builds.map((build) => build.duration).toList();

    return buildDurations.reduce((value, element) => value + element) ~/
        builds.length;
  }

  /// Creates the [PerformanceMetric] list from [Build] list.
  List<PerformanceMetric> _getPerformanceMetrics(List<Build> builds) {
    return builds
        .map(
          (build) => PerformanceMetric(
            duration: build.duration,
            date: build.startedAt,
          ),
        )
        .toList();
  }

  /// Calculates the [BuildNumberMetric] list from the [Build] list.
  List<BuildNumberMetric> _getBuildNumberMetrics(List<Build> builds) {
    final Map<DateTime, int> buildNumberMap = {};

    for (final build in builds) {
      final dayOfBuild = _trimToDay(build.startedAt);

      if (buildNumberMap.containsKey(dayOfBuild)) {
        buildNumberMap[dayOfBuild]++;
      } else {
        buildNumberMap[dayOfBuild] = 1;
      }
    }

    final List<BuildNumberMetric> buildNumberMetrics =
        buildNumberMap.entries.map((entry) {
      return BuildNumberMetric(
        date: entry.key,
        numberOfBuilds: entry.value,
      );
    }).toList();

    return buildNumberMetrics;
  }

  /// Creates the list of [BuildResultMetric]s from the list of [Build]s.
  List<BuildResultMetric> _getBuildResultMetrics(List<Build> builds) {
    List<Build> latestBuilds = builds.toList();

    if (latestBuilds.length > maxNumberOfBuildResults) {
      latestBuilds = latestBuilds.sublist(
        latestBuilds.length - maxNumberOfBuildResults,
      );
    }

    return latestBuilds.map((build) {
      return BuildResultMetric(
        date: build.startedAt,
        duration: build.duration,
        result: build.result,
        url: build.url,
      );
    }).toList();
  }

  /// Trims the date to include only the year, month and day.
  DateTime _trimToDay(DateTime buildDate) =>
      DateTime(buildDate.year, buildDate.month, buildDate.day);
}
