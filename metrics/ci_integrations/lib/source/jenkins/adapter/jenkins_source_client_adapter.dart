import 'dart:async';

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_result.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_query_limits.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for the [JenkinsClient] to implement the [SourceClient] interface.
class JenkinsSourceClientAdapter with LoggerMixin implements SourceClient {
  /// A Jenkins client instance used to perform API calls.
  final JenkinsClient jenkinsClient;

  /// Creates an instance of this adapter with the given [jenkinsClient].
  ///
  /// Throws an [ArgumentError] if the given [JenkinsClient] is `null`.
  JenkinsSourceClientAdapter(this.jenkinsClient) {
    ArgumentError.checkNotNull(jenkinsClient, 'jenkinsClient');
  }

  @override
  Future<List<BuildData>> fetchBuildsAfter(
    String projectId,
    BuildData build,
  ) async {
    ArgumentError.checkNotNull(build, 'build');

    final buildingJob = await _fetchBuilds(
      projectId,
      limits: JenkinsQueryLimits.endBefore(0),
    );

    final lastBuild = buildingJob.lastBuild;
    final numberOfBuilds = lastBuild.number - build.buildNumber;

    logger.info('Fetching builds after build #${lastBuild.number}...');

    if (numberOfBuilds <= 0) return [];

    final builds = await _fetchLatestBuilds(
      projectId,
      numberOfBuilds,
      build.buildNumber,
    );

    return _processJenkinsBuilds(
      builds,
      buildingJob.name,
      startAfterBuildNumber: build.buildNumber,
    );
  }

  @override
  Future<List<BuildData>> fetchBuilds(
    String projectId,
    int fetchLimit,
  ) async {
    logger.info('Fetching builds...');
    final buildingJob = await _fetchBuilds(
      projectId,
      limits: JenkinsQueryLimits.endBefore(fetchLimit),
    );

    return _processJenkinsBuilds(
      buildingJob.builds,
      buildingJob.name,
    );
  }

  @override
  Future<Percent> fetchCoverage(BuildData build) async {
    return Future.value(build.coverage);
  }

  /// Fetches builds data for the project with given [projectId].
  ///
  /// The [limits] can be used to set a range-specifier for the request.
  Future<JenkinsBuildingJob> _fetchBuilds(
    String projectId, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) async {
    logger.info('Fetching builds for the project $projectId...');
    final newBuildsFetchResult =
        await jenkinsClient.fetchBuilds(projectId, limits: limits);
    _throwIfInteractionUnsuccessful(newBuildsFetchResult);
    return newBuildsFetchResult.result;
  }

  /// Fetches latest builds for the project with the given [projectId] which
  /// are not synchronized.
  ///
  /// The [numberOfBuilds] is used to indicate the number of builds to fetch
  /// first. The [startFromBuildNumber] is used as the build number indicating
  /// the last synchronized build.
  Future<List<JenkinsBuild>> _fetchLatestBuilds(
    String projectId,
    int numberOfBuilds,
    int startFromBuildNumber,
  ) async {
    int _numberOfBuilds = numberOfBuilds;

    List<JenkinsBuild> builds;
    while (builds == null) {
      final buildingJob = await _fetchBuilds(
        projectId,
        limits: JenkinsQueryLimits.endAt(_numberOfBuilds),
      );

      final _builds = buildingJob.builds;
      if (_builds.isEmpty ||
          _builds.first.number == buildingJob.firstBuild.number) {
        builds = _builds;
      } else {
        final _earliestBuild = _builds.first;
        final difference = _earliestBuild.number - startFromBuildNumber;

        if (difference <= 0) {
          builds = buildingJob.builds;
        } else {
          _numberOfBuilds += difference;
        }
      }
    }

    return builds;
  }

  /// Throws a [StateError] with the message of [interactionResult] if this
  /// result is [InteractionResult.isError].
  void _throwIfInteractionUnsuccessful(InteractionResult interactionResult) {
    if (interactionResult.isError) {
      throw StateError(interactionResult.message);
    }
  }

  /// Processes the given [builds] to the list of [BuildData]s.
  ///
  /// The [jobName] is used to identify a building job for the builds.
  /// The [startAfterBuildNumber] is used to filter builds which number is less
  /// than or equal to this value. This allows to avoid processing old builds
  /// since the range specifier in Jenkins API only provides an ability to set
  /// the fetch limits but not to filter data to fetch.
  Future<List<BuildData>> _processJenkinsBuilds(
    List<JenkinsBuild> builds,
    String jobName, {
    int startAfterBuildNumber,
  }) {
    final buildDataFutures = builds.where((build) {
      return _checkBuildFinishedAndInRange(build, startAfterBuildNumber);
    }).map((build) => _mapJenkinsBuild(jobName, build));

    return Future.wait(buildDataFutures);
  }

  /// Checks a [build] to be not [JenkinsBuild.building] and
  /// satisfy a [minBuildNumber] parameter.
  ///
  /// The [minBuildNumber] is ignored if `null` or [num.isNegative].
  bool _checkBuildFinishedAndInRange(JenkinsBuild build, int minBuildNumber) {
    final buildNumberValid = minBuildNumber == null ||
        minBuildNumber.isNegative ||
        build.number > minBuildNumber;
    return !build.building && buildNumberValid;
  }

  /// Maps the given [jenkinsBuild] to the [BuildData] instance.
  Future<BuildData> _mapJenkinsBuild(
    String jobName,
    JenkinsBuild jenkinsBuild,
  ) async {
    logger.info('Mapping build to build data...');

    return BuildData(
      buildNumber: jenkinsBuild.number,
      startedAt: jenkinsBuild.timestamp ?? DateTime.now(),
      buildStatus: _mapJenkinsBuildResult(jenkinsBuild.result),
      duration: jenkinsBuild.duration ?? Duration.zero,
      workflowName: jobName,
      url: jenkinsBuild.url ?? '',
      coverage: await _fetchCoverage(jenkinsBuild),
    );
  }

  /// Fetches the code coverage for the given [build].
  ///
  /// Returns `null` if the code coverage artifact for the given build
  /// is not found.
  Future<Percent> _fetchCoverage(JenkinsBuild build) async {
    logger.info('Fetching coverage artifact for a build #${build.number}...');
    final coverageArtifact = build.artifacts.firstWhere(
      (artifact) => artifact.fileName == 'coverage-summary.json',
      orElse: () => null,
    );

    CoverageData coverage;

    if (coverageArtifact != null) {
      final artifactContentFetchResult =
          await jenkinsClient.fetchArtifactByRelativePath(
        build.url,
        coverageArtifact.relativePath,
      );

      _throwIfInteractionUnsuccessful(artifactContentFetchResult);

      final artifactContent = artifactContentFetchResult.result;
      coverage = CoverageData.fromJson(artifactContent);
    }

    return coverage?.percent;
  }

  /// Maps the [result] of a [JenkinsBuild] to the [BuildStatus].
  BuildStatus _mapJenkinsBuildResult(JenkinsBuildResult result) {
    switch (result) {
      case JenkinsBuildResult.success:
        return BuildStatus.successful;
      case JenkinsBuildResult.failure:
        return BuildStatus.failed;
      default:
        return BuildStatus.unknown;
    }
  }

  @override
  void dispose() {
    jenkinsClient.close();
  }
}
