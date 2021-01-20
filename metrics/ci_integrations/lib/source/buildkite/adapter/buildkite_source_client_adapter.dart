import 'dart:async';
import 'dart:convert';

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_builds_page.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [BuildkiteClient] to implement the [SourceClient]
/// interface.
class BuildkiteSourceClientAdapter implements SourceClient {
  /// A fetch limit for Buildkite API calls.
  static const int fetchLimit = 25;

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
  Future<List<BuildData>> fetchBuilds(String pipelineSlug) async {
    return _fetchLatestBuilds(pipelineSlug);
  }

  @override
  Future<List<BuildData>> fetchBuildsAfter(
    String pipelineSlug,
    BuildData build,
  ) async {
    ArgumentError.checkNotNull(build, 'build');
    final latestBuildNumber = build.buildNumber;
    Logger.logInfo(
      'BuildkiteSourceClientAdapter: Fetch builds after build #$latestBuildNumber...',
    );

    final firstBuildsPage = await _fetchBuildsPage(
      pipelineSlug,
      page: 1,
      perPage: 1,
    );

    final builds = firstBuildsPage.values ?? [];

    if (builds.isEmpty || builds.first.number <= latestBuildNumber) return [];

    return _fetchLatestBuilds(pipelineSlug, latestBuildNumber);
  }

  /// Fetches the latest builds by the given [pipelineSlug].
  ///
  /// If the [latestBuildNumber] is not `null`, returns all builds with the
  /// [Build.buildNumber] greater than the given [latestBuildNumber]. Otherwise,
  /// returns no more than the latest [fetchLimit] builds.
  Future<List<BuildData>> _fetchLatestBuilds(
    String pipelineSlug, [
    int latestBuildNumber,
  ]) async {
    final List<BuildData> result = [];
    bool hasNext = true;

    BuildkiteBuildsPage buildsPage = await _fetchBuildsPage(
      pipelineSlug,
      page: 1,
      perPage: fetchLimit,
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
        Logger.logInfo(
          'BuildkiteSourceClientAdapter: Fetching next builds page...',
        );
        final interaction = await buildkiteClient.fetchBuildsNext(
          buildsPage,
        );
        _throwIfInteractionUnsuccessful(interaction);
        buildsPage = interaction.result;
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

    _throwIfInteractionUnsuccessful(interaction);

    return interaction.result;
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
      coverage: await _fetchCoverage(pipelineSlug, build),
    );
  }

  /// Fetches the coverage for the given [build] of a pipeline with the given
  /// [pipelineSlug].
  ///
  /// Returns `null` if the code coverage artifact for the given build
  /// is not found.
  Future<Percent> _fetchCoverage(
    String pipelineSlug,
    BuildkiteBuild build,
  ) async {
    Logger.logInfo(
      'BuildkiteSourceClientAdapter: Searching coverage artifact for a build number #${build.number}...',
    );
    final interaction = await buildkiteClient.fetchArtifacts(
      pipelineSlug,
      build.number,
      page: 1,
      perPage: fetchLimit,
    );
    _throwIfInteractionUnsuccessful(interaction);

    BuildkiteArtifactsPage page = interaction.result;
    bool hasNext = false;

    do {
      final artifacts = page.values;

      final coverageArtifact = artifacts.firstWhere(
        (artifact) => artifact.filename == 'coverage-summary.json',
        orElse: () => null,
      );

      if (coverageArtifact != null) {
        return _mapArtifactToCoverage(coverageArtifact);
      }

      hasNext = page.hasNextPage;

      if (hasNext) {
        Logger.logInfo(
          'BuildkiteSourceClientAdapter: Fetching next artifacts page...',
        );
        final interaction = await buildkiteClient.fetchArtifactsNext(page);
        _throwIfInteractionUnsuccessful(interaction);

        page = interaction.result;
      }
    } while (hasNext);

    return null;
  }

  /// Maps the given [artifact] to the coverage [Percent] value.
  ///
  /// Returns `null` if either the coverage file is not found or
  /// JSON content parsing is failed.
  Future<Percent> _mapArtifactToCoverage(BuildkiteArtifact artifact) async {
    Logger.logInfo(
      'BuildkiteSourceClientAdapter: Downloading coverage artifact from the url: ${artifact.downloadUrl}',
    );

    final interaction =
        await buildkiteClient.downloadArtifact(artifact.downloadUrl);

    _throwIfInteractionUnsuccessful(interaction);

    final artifactBytes = interaction.result;

    if (artifactBytes == null) return null;

    try {
      Logger.logInfo(
        'BuildkiteSourceClientAdapter: Parsing coverage artifact...',
      );
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

  /// Throws a [StateError] with the message of [interactionResult] if this
  /// result is [InteractionResult.isError].
  void _throwIfInteractionUnsuccessful(InteractionResult interactionResult) {
    if (interactionResult.isError) {
      throw StateError(interactionResult.message);
    }
  }

  @override
  void dispose() {
    buildkiteClient.close();
  }
}
