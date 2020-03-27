import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:ci_integration/coverage_json_summary/model/coverage_json_summary.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [JenkinsClient] to fit [CiClient] contract.
class CiClientJenkinsAdapter extends CiClient {
  /// A Jenkins client instance used to perform API calls.
  final JenkinsClient jenkinsClient;

  /// Creates an instance of this adapter with the given [jenkinsClient].
  ///
  /// Throws [ArgumentError] if the given Jenkins client is `null`.
  CiClientJenkinsAdapter(this.jenkinsClient) {
    ArgumentError.checkNotNull(jenkinsClient, 'jenkinsClient');
  }

  /// Checks the given [interactionResult] to be [InteractionResult.isSuccess].
  ///
  /// Throws [StateError] with the message of [interactionResult] if this
  /// result is [InteractionResult.isError].
  void _checkInteractionIsSuccessful(InteractionResult interactionResult) {
    if (interactionResult.isError) {
      throw StateError(interactionResult.message);
    }
  }

  /// Maps the [result] of Jenkins build to the [BuildStatus].
  BuildStatus _mapJenkinsBuildResult(String result) {
    if (result == 'ABORTED') {
      return BuildStatus.cancelled;
    } else if (result == 'SUCCESS' || result == 'UNSTABLE') {
      return BuildStatus.successful;
    }

    return BuildStatus.failed;
  }

  /// Maps [jenkinsBuild] to the [BuildData] instance with coverage
  /// data fetching.
  Future<BuildData> _mapJenkinsBuild(
    String jobName,
    JenkinsBuild jenkinsBuild,
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

      _checkInteractionIsSuccessful(artifactContentFetchResult);

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

  /// Fetches builds for the project with given [projectId].
  ///
  /// The [limits] can be used to set a range-specifier for the request.
  /// The [minBuildNumber] is used to filter builds which number is less than
  /// or equal to this value. This allows to avoid fetching old builds since
  /// the range specifier in Jenkins API only provides ability to set fetch
  /// limits but not to filter data to fetch.
  Future<List<BuildData>> _fetchBuilds(
    String projectId, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
    int minBuildNumber,
  }) async {
    final newBuildsFetchResult =
        await jenkinsClient.fetchBuilds(projectId, limits: limits);

    _checkInteractionIsSuccessful(newBuildsFetchResult);

    final result = newBuildsFetchResult.result;

    final futures = result.builds
        .where((build) =>
            minBuildNumber == null ||
            minBuildNumber.isNegative ||
            build.number > minBuildNumber)
        .map((build) => _mapJenkinsBuild(result.name, build));

    return Future.wait(futures);
  }

  @override
  Future<List<BuildData>> fetchBuildsAfter(
    String projectId,
    BuildData build,
  ) async {
    ArgumentError.checkNotNull(build, 'build');

    final lastBuildFetchResult = await jenkinsClient.fetchBuilds(
      projectId,
      limits: JenkinsQueryLimits.endBefore(0),
    );

    _checkInteractionIsSuccessful(lastBuildFetchResult);

    final lastBuild = lastBuildFetchResult.result.lastBuild;
    final numberOfBuilds = lastBuild.number - build.buildNumber;
    return _fetchBuilds(
      projectId,
      limits: JenkinsQueryLimits.endBefore(numberOfBuilds),
      minBuildNumber: build.buildNumber,
    );
  }

  @override
  Future<List<BuildData>> fetchBuilds(String projectId) {
    return _fetchBuilds(projectId);
  }
}
