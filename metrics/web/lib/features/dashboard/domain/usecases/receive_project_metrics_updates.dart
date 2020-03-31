import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
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
import 'package:metrics_core/metrics_core.dart';
import 'package:rxdart/rxdart.dart';

/// Provides an ability to get the [DashboardProjectMetrics] updates.
class ReceiveProjectMetricsUpdates
    implements UseCase<Stream<DashboardProjectMetrics>, ProjectIdParam> {
  static const int numberOfBuildResults = 14;
  static const Duration buildMetricsLoadingPeriod = Duration(days: 7);
  static const Duration averageBuildDurationCalculationPeriod =
      Duration(days: 14);

  final MetricsRepository _repository;

  /// Creates the [ReceiveProjectMetricsUpdates] use case with given [MetricsRepository].
  ReceiveProjectMetricsUpdates(this._repository);

  @override
  Stream<DashboardProjectMetrics> call(ProjectIdParam params) {
    final projectId = params.projectId;

    final lastBuildsStream = _repository.latestProjectBuildsStream(
      projectId,
      numberOfBuildResults,
    );

    final projectBuildsInPeriod = _repository.projectBuildsFromDateStream(
      projectId,
      DateTime.now().subtract(averageBuildDurationCalculationPeriod),
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

    final buildNumberMetrics = _getBuildNumberMetrics(builds);
    final buildResultMetrics = _getBuildResultMetrics(builds);
    final performanceMetrics = _getPerformanceMetrics(builds);
    final stability = _getStability(builds);

    return DashboardProjectMetrics(
      projectId: projectId,
      buildNumberMetrics: buildNumberMetrics,
      performanceMetrics: performanceMetrics,
      buildResultMetrics: buildResultMetrics,
      coverage: builds.last.coverage,
      stability: stability,
    );
  }

  /// Creates the [PerformanceMetric] from [builds].
  PerformanceMetric _getPerformanceMetrics(
    List<Build> builds,
  ) {
    final averageBuildTime = _getAverageBuildTime(builds);
    final buildsInPeriod = _getBuildsInPeriod(
      builds,
      buildMetricsLoadingPeriod,
    );

    final buildPerformanceSet = DateTimeSet<BuildPerformance>();

    if (buildsInPeriod.isEmpty) {
      return PerformanceMetric(
        buildsPerformance: buildPerformanceSet,
      );
    }

    for (final build in buildsInPeriod) {
      buildPerformanceSet.add(BuildPerformance(
        duration: build.duration,
        date: build.startedAt,
      ));
    }

    return PerformanceMetric(
      buildsPerformance: buildPerformanceSet,
      averageBuildDuration: averageBuildTime,
    );
  }

  /// Calculates the average build time of [builds].
  Duration _getAverageBuildTime(List<Build> builds) {
    final buildsInPeriod = _getBuildsInPeriod(
      builds,
      averageBuildDurationCalculationPeriod,
    );

    if (buildsInPeriod.isEmpty) return const Duration();

    return buildsInPeriod.fold<Duration>(
            const Duration(), (value, element) => value + element.duration) ~/
        builds.length;
  }

  /// Calculates the [BuildNumberMetric] from [builds].
  BuildNumberMetric _getBuildNumberMetrics(List<Build> builds) {
    final Map<DateTime, int> buildNumberMap = {};

    final buildsInPeriod = _getBuildsInPeriod(
      builds,
      buildMetricsLoadingPeriod,
    );

    final buildsOnDateSet = DateTimeSet<BuildsOnDate>();

    if (buildsInPeriod.isEmpty) {
      return BuildNumberMetric(
        buildsOnDateSet: buildsOnDateSet,
      );
    }

    for (final build in buildsInPeriod) {
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
      totalNumberOfBuilds: buildsInPeriod.length,
    );
  }

  /// Creates the [BuildResultMetric] from the list of [builds].
  BuildResultMetric _getBuildResultMetrics(List<Build> builds) {
    if (builds.isEmpty) return const BuildResultMetric();

    List<Build> latestBuilds = builds;

    if (latestBuilds.length > numberOfBuildResults) {
      latestBuilds = latestBuilds.sublist(
        latestBuilds.length - numberOfBuildResults,
      );
    }

    final buildResults = latestBuilds.map((build) {
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
    final buildsInPeriod = _getBuildsInPeriod(
      builds,
      buildMetricsLoadingPeriod,
    );

    if (buildsInPeriod.isEmpty) return const Percent(0.0);

    final successfulBuilds = buildsInPeriod.where(
      (build) => build.buildStatus == BuildStatus.successful,
    );

    return Percent(successfulBuilds.length / buildsInPeriod.length);
  }

  /// Gets all builds in [period] from given [builds].
  Iterable<Build> _getBuildsInPeriod(List<Build> builds, Duration period) {
    final periodStartDate = DateTime.now().subtract(period);

    return builds
        .where((element) => element.startedAt.isAfter(periodStartDate))
        .toList();
  }
}
