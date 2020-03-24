import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/features/dashboard/domain/entities/core/build.dart';
import 'package:metrics/features/dashboard/domain/entities/core/build_status.dart';
import 'package:metrics/features/dashboard/domain/entities/core/percent.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/builds_on_date.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/util/date.dart';
import 'package:rxdart/rxdart.dart';

/// Provides an ability to get the [DashboardProjectMetrics] updates.
class ReceiveProjectMetricsUpdates
    implements UseCase<Stream<DashboardProjectMetrics>, ProjectIdParam> {
  static const int numberOfLastBuilds = 14;

  final MetricsRepository _repository;

  /// Creates the [ReceiveProjectMetricsUpdates] use case with given [MetricsRepository].
  ReceiveProjectMetricsUpdates(this._repository);

  @override
  Stream<DashboardProjectMetrics> call(ProjectIdParam params) {
    final projectId = params.projectId;

    final lastBuildsStream = _repository.latestProjectBuildsStream(
      projectId,
      numberOfLastBuilds,
    );

    final weekStartDate = _getWeekStartDate();
    final projectBuildsInPeriod = _repository.projectBuildsFromDateStream(
      projectId,
      weekStartDate,
    );

    return CombineLatestStream.combine2(
      lastBuildsStream,
      projectBuildsInPeriod,
      _mergeBuilds,
    ).map((builds) => _mapToBuildMetrics(
          builds,
          projectId,
        ));
  }

  /// Merges 2 [List]s of [Build]s into a single list by id.
  List<Build> _mergeBuilds(
    List<Build> latestBuilds,
    List<Build> buildsInPeriod,
  ) {
    final builds = buildsInPeriod.toList();

    for (final latestBuild in latestBuilds) {
      if (buildsInPeriod.any((build) => build.id == latestBuild.id)) continue;

      builds.add(latestBuild);
    }

    builds.sort((prev, next) => prev.startedAt.compareTo(next.startedAt));

    return builds;
  }

  /// Creates the [DashboardProjectMetrics] from the list of [Build]s.
  DashboardProjectMetrics _mapToBuildMetrics(
    List<Build> builds,
    String projectId,
  ) {
    if (builds == null || builds.isEmpty) {
      return DashboardProjectMetrics(
        projectId: projectId,
      );
    }

    List<Build> latestBuilds = builds;

    if (latestBuilds.length > numberOfLastBuilds) {
      latestBuilds = latestBuilds.sublist(
        latestBuilds.length - numberOfLastBuilds,
      );
    }

    final buildNumberMetrics = _getBuildNumberMetrics(builds);
    final buildResultMetrics = _getBuildResultMetrics(latestBuilds);
    final performanceMetrics = _getPerformanceMetrics(latestBuilds);
    final stability = _getStability(latestBuilds);
    final coverage = _getCoverage(builds);

    return DashboardProjectMetrics(
      projectId: projectId,
      buildNumberMetrics: buildNumberMetrics,
      performanceMetrics: performanceMetrics,
      buildResultMetrics: buildResultMetrics,
      coverage: coverage,
      stability: stability,
    );
  }

  /// Gets the coverage of the last successful build in [builds].
  Percent _getCoverage(List<Build> builds) {
    final lastSuccessfulBuild = builds.lastWhere(
      (build) => build.buildStatus == BuildStatus.successful,
      orElse: () => null,
    );

    if (lastSuccessfulBuild == null) return const Percent(0.0);

    return lastSuccessfulBuild.coverage;
  }

  /// Creates the [PerformanceMetric] from [builds].
  PerformanceMetric _getPerformanceMetrics(
    List<Build> builds,
  ) {
    final averageBuildDuration = _getAverageBuildDuration(builds);
    final buildPerformanceSet = DateTimeSet<BuildPerformance>();

    if (builds.isEmpty) {
      return PerformanceMetric(
        buildsPerformance: buildPerformanceSet,
      );
    }

    for (final build in builds) {
      buildPerformanceSet.add(BuildPerformance(
        duration: build.duration,
        date: build.startedAt,
      ));
    }

    return PerformanceMetric(
      buildsPerformance: buildPerformanceSet,
      averageBuildDuration: averageBuildDuration,
    );
  }

  /// Calculates the average build time of [builds].
  Duration _getAverageBuildDuration(List<Build> builds) {
    if (builds.isEmpty) return const Duration();

    return builds.fold<Duration>(
            const Duration(), (value, element) => value + element.duration) ~/
        builds.length;
  }

  /// Calculates the [BuildNumberMetric] from [builds].
  BuildNumberMetric _getBuildNumberMetrics(List<Build> builds) {
    final Map<DateTime, int> buildNumberMap = {};

    final weekStartDate = _getWeekStartDate();
    final thisWeekBuilds = builds
        .where((element) => element.startedAt.isAfter(weekStartDate))
        .toList();

    final buildsOnDateSet = DateTimeSet<BuildsOnDate>();

    if (thisWeekBuilds.isEmpty) {
      return BuildNumberMetric(
        buildsOnDateSet: buildsOnDateSet,
      );
    }

    for (final build in thisWeekBuilds) {
      final dayOfBuild = build.startedAt.date;

      if (buildNumberMap.containsKey(dayOfBuild)) {
        buildNumberMap[dayOfBuild]++;
      } else {
        buildNumberMap[dayOfBuild] = 1;
      }
    }

    for (final entry in buildNumberMap.entries) {
      buildsOnDateSet.add(BuildsOnDate(
        date: entry.key,
        numberOfBuilds: entry.value,
      ));
    }

    return BuildNumberMetric(
      buildsOnDateSet: buildsOnDateSet,
      totalNumberOfBuilds: thisWeekBuilds.length,
    );
  }

  /// Creates the [BuildResultMetric] from the list of [builds].
  BuildResultMetric _getBuildResultMetrics(List<Build> builds) {
    if (builds.isEmpty) return const BuildResultMetric();

    final buildResults = builds.map((build) {
      return BuildResult(
        date: build.startedAt,
        duration: build.duration,
        buildStatus: build.buildStatus,
        url: build.url,
      );
    }).toList();

    return BuildResultMetric(buildResults: buildResults);
  }

  /// Calculates the stability metric from list of [builds].
  Percent _getStability(List<Build> builds) {
    if (builds.isEmpty) return const Percent(0.0);

    final successfulBuilds = builds.where(
      (build) => build.buildStatus == BuildStatus.successful,
    );

    return Percent(successfulBuilds.length / builds.length);
  }

  /// Gets the date of Monday of this week.
  DateTime _getWeekStartDate() {
    final timestamp = DateTime.now();

    return timestamp.subtract(Duration(days: timestamp.weekday - 1)).date;
  }
}
