// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/project_build_status_metric.dart';
import 'package:metrics/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rxdart/rxdart.dart';

/// Provides an ability to get the [DashboardProjectMetrics] updates.
class ReceiveProjectMetricsUpdates
    implements UseCase<Stream<DashboardProjectMetrics>, ProjectIdParam> {
  /// A number of builds to load for chart metrics.
  static const int buildsToLoadForChartMetrics = 30;

  /// A [Duration] of a loading period for builds.
  static const Duration buildsLoadingPeriod = Duration(days: 6);

  final MetricsRepository _repository;

  /// Creates the [ReceiveProjectMetricsUpdates] use case with given [MetricsRepository].
  ///
  /// [MetricsRepository] must not be null.
  ReceiveProjectMetricsUpdates(this._repository) : assert(_repository != null);

  @override
  Stream<DashboardProjectMetrics> call(ProjectIdParam params) {
    final projectId = params.projectId;

    final lastBuildsStream = _repository.latestProjectBuildsStream(
      projectId,
      buildsToLoadForChartMetrics,
    );

    final lastSuccessfulBuildStream = _repository.lastSuccessfulBuildStream(
      projectId,
    );

    return CombineLatestStream.combine2(
      lastBuildsStream,
      lastSuccessfulBuildStream,
      _mergeBuilds,
    ).map((builds) => _mapToBuildMetrics(
          builds,
          projectId,
        ));
  }

  /// Merges 2 [List]s of [Build]s into a single list by id.
  List<Build> _mergeBuilds(
    List<Build> latestBuilds,
    List<Build> lastSuccessfulBuild,
  ) {
    final buildsSet = LinkedHashSet<Build>(
      equals: (build1, build2) => build1?.id == build2?.id,
      hashCode: (build) => build?.id.hashCode,
    );

    buildsSet.addAll(latestBuilds);
    buildsSet.addAll(lastSuccessfulBuild);

    final builds = buildsSet.toList();

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

    final lastBuilds = _getLastBuilds(
      builds,
      buildsToLoadForChartMetrics,
    );

    final projectBuildStatusMetric = ProjectBuildStatusMetric(
      status: builds.last.buildStatus,
    );
    final buildResultMetrics = _getBuildResultMetrics(lastBuilds);

    final lastFinishedBuilds = _getFinishedBuilds(lastBuilds);
    final stability = _getStability(lastFinishedBuilds);

    final coverage = _getCoverage(builds);

    return DashboardProjectMetrics(
      projectId: projectId,
      projectBuildStatusMetric: projectBuildStatusMetric,
      buildResultMetrics: buildResultMetrics,
      coverage: coverage,
      stability: stability,
    );
  }

  /// Returns last [numberOfBuilds] from [builds].
  List<Build> _getLastBuilds(List<Build> builds, int numberOfBuilds) {
    List<Build> latestBuilds = builds;

    if (latestBuilds.length > numberOfBuilds) {
      latestBuilds = latestBuilds.sublist(
        latestBuilds.length - numberOfBuilds,
      );
    }

    return latestBuilds;
  }

  /// Gets the coverage of the last successful build in [builds].
  Percent _getCoverage(List<Build> builds) {
    final lastSuccessfulBuild = builds.lastWhere(
      (build) => build.buildStatus == BuildStatus.successful,
      orElse: () => null,
    );

    if (lastSuccessfulBuild == null) return null;

    return lastSuccessfulBuild.coverage;
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
    if (builds.isEmpty) return null;

    final successfulBuilds = builds.where(
      (build) => build.buildStatus == BuildStatus.successful,
    );

    return Percent(successfulBuilds.length / builds.length);
  }

  /// Creates a [List] of finished [Build]s from the given [builds].
  ///
  /// A finished [Build] is a build with the [Build.buildStatus] not equal to
  /// the [BuildStatus.inProgress].
  List<Build> _getFinishedBuilds(List<Build> builds) {
    return builds
        .where((build) => build.buildStatus != BuildStatus.inProgress)
        .toList();
  }
}
