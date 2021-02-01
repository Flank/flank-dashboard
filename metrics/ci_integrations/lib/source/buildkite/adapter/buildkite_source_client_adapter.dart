import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_builds_page.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:ci_integration/util/validator/number_validator.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [BuildkiteClient] to implement the [SourceClient]
/// interface.
class BuildkiteSourceClientAdapter with LoggerMixin implements SourceClient {
  /// A default number of instances to request in paginated requests.
  static const int defaultPerPage = 25;

  /// A [BuildkiteClient] instance to perform API calls.
  final BuildkiteClient buildkiteClient;

  /// Creates a new instance of the [BuildkiteSourceClientAdapter].
  ///
  /// Throws an [ArgumentError] if [buildkiteClient] is `null`.
  BuildkiteSourceClientAdapter({
    @required this.buildkiteClient,
  }) {
    ArgumentError.checkNotNull(buildkiteClient, 'buildkiteClient');
  }

  @override
  Future<List<BuildData>> fetchBuilds(
    String pipelineSlug,
    int fetchLimit,
  ) async {
    NumberValidator.checkGreaterThan(fetchLimit, 0);

    logger.info('Fetching builds...');
    return _fetchLatestBuilds(
      pipelineSlug,
      fetchLimit: fetchLimit,
    );
  }

  @override
  Future<List<BuildData>> fetchBuildsAfter(
    String pipelineSlug,
    BuildData build,
  ) async {
    ArgumentError.checkNotNull(build, 'build');
    final latestBuildNumber = build.buildNumber;
    logger.info('Fetching builds after build #$latestBuildNumber...');

    final firstBuildsPage = await _fetchBuildsPage(
      pipelineSlug,
      page: 1,
      perPage: 1,
    );

    final builds = firstBuildsPage.values ?? [];

    if (builds.isEmpty || builds.first.number <= latestBuildNumber) return [];

    return _fetchLatestBuilds(
      pipelineSlug,
      latestBuildNumber: latestBuildNumber,
    );
  }

  @override
  Future<Percent> fetchCoverage(BuildData build) async {
    ArgumentError.checkNotNull(build, 'build');

    final coverageArtifact = await _fetchCoverageArtifact(
      build.workflowName,
      build.buildNumber,
    );

    if (coverageArtifact == null) return null;

    final bytes = await _downloadArtifact(coverageArtifact);
    return _mapArtifactToCoverage(bytes);
  }

  /// Fetches the latest builds by the given [pipelineSlug].
  ///
  /// If the [latestBuildNumber] is not `null`, returns all builds with the
  /// [Build.buildNumber] greater than the given [latestBuildNumber].
  /// Otherwise, returns no more than [fetchLimit] latest builds.
  Future<List<BuildData>> _fetchLatestBuilds(
    String pipelineSlug, {
    int latestBuildNumber,
    int fetchLimit,
  }) async {
    final List<BuildData> result = [];
    bool hasNext = true;

    BuildkiteBuildsPage buildsPage = await _fetchBuildsPage(
      pipelineSlug,
      page: 1,
      perPage: defaultPerPage,
    );

    do {
      hasNext = buildsPage.hasNextPage;
      final builds = buildsPage.values;

      for (final build in builds) {
        if (latestBuildNumber != null && build.number <= latestBuildNumber) {
          hasNext = false;
          break;
        }

        if (build == null || build.blocked) {
          continue;
        } else {
          final buildData = await _mapBuildToBuildData(pipelineSlug, build);
          result.add(buildData);

          if (latestBuildNumber == null && result.length == fetchLimit) {
            hasNext = false;
            break;
          }
        }
      }

      if (hasNext) {
        final interaction = await buildkiteClient.fetchBuildsNext(buildsPage);
        buildsPage = _processInteraction(interaction);
      }
    } while (hasNext);

    return result;
  }

  /// Fetches a [BuildkiteBuildsPage] with the given parameters delegating them
  /// to the [BuildkiteClient.fetchBuilds] method.
  Future<BuildkiteBuildsPage> _fetchBuildsPage(
    String pipelineSlug, {
    int page,
    int perPage,
  }) async {
    final interaction = await buildkiteClient.fetchBuilds(
      pipelineSlug,
      state: BuildkiteBuildState.finished,
      page: page,
      perPage: perPage,
    );

    return _processInteraction(interaction);
  }

  /// Maps the given [build] to the [BuildData] instance.
  Future<BuildData> _mapBuildToBuildData(
    String pipelineSlug,
    BuildkiteBuild build,
  ) async {
    return BuildData(
      buildNumber: build.number,
      startedAt: build.startedAt ?? build.finishedAt ?? DateTime.now(),
      buildStatus: _mapStateToBuildStatus(build.state),
      duration: _calculateJobDuration(build),
      workflowName: pipelineSlug,
      url: build.webUrl ?? '',
      apiUrl: build.apiUrl,
    );
  }

  /// Fetches an artifact with coverage data for the build with the given
  /// [buildNumber] of a pipeline with the given [pipelineSlug].
  ///
  /// Returns `null` if a coverage artifact is not found.
  Future<BuildkiteArtifact> _fetchCoverageArtifact(
    String pipelineSlug,
    int buildNumber,
  ) async {
    logger.info('Fetching coverage artifact for a build #$buildNumber...');
    final interaction = await buildkiteClient.fetchArtifacts(
      pipelineSlug,
      buildNumber,
      page: 1,
      perPage: defaultPerPage,
    );

    BuildkiteArtifactsPage page = _processInteraction(interaction);
    BuildkiteArtifact artifact;
    bool hasNext = false;

    do {
      final artifacts = page.values;
      artifact = artifacts.firstWhere(
        (artifact) => artifact.filename == 'coverage-summary.json',
        orElse: () => null,
      );

      hasNext = page.hasNextPage && artifact == null;

      if (hasNext) {
        final interaction = await buildkiteClient.fetchArtifactsNext(page);
        page = _processInteraction(interaction);
      }
    } while (hasNext);

    return artifact;
  }

  /// Downloads the given [artifact] using the [BuildkiteArtifact.downloadUrl].
  Future<Uint8List> _downloadArtifact(BuildkiteArtifact artifact) async {
    final interaction = await buildkiteClient.downloadArtifact(
      artifact.downloadUrl,
    );

    return _processInteraction(interaction);
  }

  /// Maps the given [artifactBytes] into the coverage [Percent] value.
  ///
  /// Returns `null` if either the given [artifactBytes] is `null` or
  /// JSON content parsing is failed.
  Percent _mapArtifactToCoverage(Uint8List artifactBytes) {
    if (artifactBytes == null) return null;

    try {
      logger.info('Parsing coverage artifact...');
      final coverageContent = utf8.decode(artifactBytes);
      final coverageJson = jsonDecode(coverageContent) as Map<String, dynamic>;
      final coverage = CoverageData.fromJson(coverageJson);

      return coverage?.percent;
    } on FormatException catch (_) {
      return null;
    }
  }

  /// Calculates a [Duration] of the given [build].
  ///
  /// Returns [Duration.zero] if either [BuildkiteBuild.startedAt] or
  /// [BuildkiteBuild.finishedAt] is `null`.
  Duration _calculateJobDuration(BuildkiteBuild build) {
    if (build.startedAt == null || build.finishedAt == null) {
      return Duration.zero;
    }

    return build.finishedAt.difference(build.startedAt);
  }

  /// Maps the given [state] to the [BuildStatus].
  BuildStatus _mapStateToBuildStatus(BuildkiteBuildState state) {
    switch (state) {
      case BuildkiteBuildState.passed:
        return BuildStatus.successful;
      case BuildkiteBuildState.failed:
        return BuildStatus.failed;
      default:
        return BuildStatus.unknown;
    }
  }

  /// Processes the given [interaction].
  ///
  /// Throws the [StateError], if the given interaction
  /// is [InteractionResult.isError]. Otherwise, returns
  /// its [InteractionResult.result].
  T _processInteraction<T>(InteractionResult<T> interaction) {
    if (interaction.isError) {
      throw StateError(interaction.message);
    }

    return interaction.result;
  }

  @override
  void dispose() {
    buildkiteClient.close();
  }
}
