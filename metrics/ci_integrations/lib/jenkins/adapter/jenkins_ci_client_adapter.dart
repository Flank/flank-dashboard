import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:ci_integration/coverage_json_summary/model/coverage_json_summary.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [JenkinsClient] to fit [CiClient] contract.
class JenkinsCiClientAdapter implements CiClient {
  /// A Jenkins client instance used to perform API calls.
  final JenkinsClient jenkinsClient;

  /// Creates an instance of this adapter with the given [jenkinsClient].
  ///
  /// Throws [ArgumentError] if the given Jenkins client is `null`.
  JenkinsCiClientAdapter(this.jenkinsClient) {
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
    int numberOfBuilds = lastBuild.number - build.buildNumber;

    if (numberOfBuilds <= 0) return [];

    List<JenkinsBuild> builds;
    while (builds == null) {
      final buildingJob = await _fetchBuilds(
        projectId,
        limits: JenkinsQueryLimits.endAt(numberOfBuilds),
      );

      final _builds = buildingJob.builds;
      if (_builds.first.number == buildingJob.firstBuild.number ||
          _builds.isEmpty) {
        builds = _builds;
      } else {
        final _earliestBuild = _builds.first;
        final difference = _earliestBuild.number - build.buildNumber;

        if (difference <= 0) {
          builds = buildingJob.builds;
        } else {
          numberOfBuilds += difference;
        }
      }
    }

    return _processJenkinsBuilds(
      builds,
      buildingJob.name,
      startFromBuildNumber: build.buildNumber,
    );
  }

  @override
  Future<List<BuildData>> fetchBuilds(String projectId) async {
    final buildingJob = await _fetchBuilds(projectId);
    return _processJenkinsBuilds(
      buildingJob.builds,
      buildingJob.name,
    );
  }

  /// Fetches builds data for the project with given [projectId].
  ///
  /// The [limits] can be used to set a range-specifier for the request.
  Future<JenkinsBuildingJob> _fetchBuilds(
    String projectId, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) async {
    final newBuildsFetchResult =
        await jenkinsClient.fetchBuilds(projectId, limits: limits);
    _throwIfInteractionUnsuccessful(newBuildsFetchResult);
    return newBuildsFetchResult.result;
  }

  /// Checks the given [interactionResult] to be [InteractionResult.isSuccess].
  ///
  /// Throws [StateError] with the message of [interactionResult] if this
  /// result is [InteractionResult.isError].
  void _throwIfInteractionUnsuccessful(InteractionResult interactionResult) {
    if (interactionResult.isError) {
      throw StateError(interactionResult.message);
    }
  }

  /// Processes the given [builds] to the list of [BuildData]s.
  ///
  /// The [jobName] is used to identify a building job for the builds.
  /// The [startFromBuildNumber] is used to filter builds which number is less
  /// than or equal to this value. This allows to avoid fetching old builds
  /// since the range specifier in Jenkins API only provides ability to set
  /// fetch limits but not to filter data to fetch.
  Future<List<BuildData>> _processJenkinsBuilds(
    List<JenkinsBuild> builds,
    String jobName, {
    int startFromBuildNumber,
  }) {
    final buildDataFutures = builds
        .where((build) =>
            _checkBuildFinishedAndInRange(build, startFromBuildNumber))
        .map((build) => _mapJenkinsBuild(build, jobName));

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

  /// Maps [jenkinsBuild] to the [BuildData] instance with coverage
  /// data fetching.
  Future<BuildData> _mapJenkinsBuild(
    JenkinsBuild jenkinsBuild,
    String jobName,
  ) async {
    final coverageArtifact = jenkinsBuild.artifacts.firstWhere(
      (artifact) => artifact.fileName == 'coverage-summary.json',
      orElse: () => null,
    );

    CoverageJsonSummary coverage;

    if (coverageArtifact != null) {
      final artifactContentFetchResult =
          await jenkinsClient.fetchArtifactByRelativePath(
        jenkinsBuild.url,
        coverageArtifact.relativePath,
      );

      _throwIfInteractionUnsuccessful(artifactContentFetchResult);

      final artifactContent = artifactContentFetchResult.result;
      coverage = CoverageJsonSummary.fromJson(artifactContent);
    }

    return BuildData(
      buildNumber: jenkinsBuild.number,
      startedAt: jenkinsBuild.timestamp,
      buildStatus: _mapJenkinsBuildResult(jenkinsBuild.result),
      duration: jenkinsBuild.duration,
      workflowName: jobName,
      url: jenkinsBuild.url,
      coverage: coverage?.total?.branches?.percent,
    );
  }

  /// Maps the [result] of [JenkinsBuild] to the [BuildStatus].
  BuildStatus _mapJenkinsBuildResult(JenkinsBuildResult result) {
    switch (result) {
      case JenkinsBuildResult.aborted:
        return BuildStatus.cancelled;
      case JenkinsBuildResult.unstable:
        return BuildStatus.successful;
      case JenkinsBuildResult.success:
        return BuildStatus.successful;
      default:
        return BuildStatus.failed;
    }
  }
}
