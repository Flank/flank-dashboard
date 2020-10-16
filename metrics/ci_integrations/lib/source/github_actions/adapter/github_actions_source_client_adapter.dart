import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_duration.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/coverage_json_summary.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/archive/archive_util.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [GithubActionsClient] to implement the [SourceClient]
/// interface.
class GithubActionsSourceClientAdapter implements SourceClient {
  /// A fetch limit for Github Actions API calls.
  static const int fetchLimit = 25;

  /// A [GithubActionsClient] instance to perform API calls.
  final GithubActionsClient githubActionsClient;

  /// An [ArchiveHelper] to work with the compressed responses data.
  final ArchiveHelper archiveHelper;

  /// Creates a new instance of the [GithubActionsSourceClientAdapter].
  ///
  /// Throws an [ArgumentError] if either the given [githubActionsClient] or
  /// [archiveHelper] is `null`.
  GithubActionsSourceClientAdapter({
    this.githubActionsClient,
    this.archiveHelper,
  }) {
    ArgumentError.checkNotNull(githubActionsClient, 'githubActionsClient');
    ArgumentError.checkNotNull(archiveHelper, 'archiveUtil');
  }

  @override
  Future<List<BuildData>> fetchBuilds(String workflowIdentifier) async {
    final runsPage = await _fetchRunsPage(
      workflowIdentifier: workflowIdentifier,
      status: RunStatus.completed,
      perPage: fetchLimit,
      page: 1,
    );

    final runs = runsPage.values;

    return _mapRunsToBuildData(
      runs: runs,
      workflowIdentifier: workflowIdentifier,
    );
  }

  @override
  Future<List<BuildData>> fetchBuildsAfter(
    String workflowIdentifier,
    BuildData build,
  ) async {
    final initialRunsPage = await _fetchRunsPage(
      workflowIdentifier: workflowIdentifier,
      status: RunStatus.completed,
      perPage: 1,
      page: 1,
    );

    final initialRuns = initialRunsPage?.values;
    if (initialRuns == null || initialRuns.isEmpty) return [];

    final lastRunNumber = initialRuns.first.number;
    final lastBuildNumber = build.buildNumber;

    if (lastRunNumber <= lastBuildNumber) return [];

    final runsAfter = await _fetchRunsAfter(
      workflowIdentifier: workflowIdentifier,
      lastRunNumber: lastBuildNumber,
    );

    return _mapRunsToBuildData(
      runs: runsAfter,
      workflowIdentifier: workflowIdentifier,
    );
  }

  /// Fetches a list of [WorkflowRun]s that have the [WorkflowRun.number]
  /// greater than the given [lastRunNumber].
  Future<List<WorkflowRun>> _fetchRunsAfter({
    String workflowIdentifier,
    int lastRunNumber,
  }) async {
    WorkflowRunsPage page = await _fetchRunsPage(
      workflowIdentifier: workflowIdentifier,
      status: RunStatus.completed,
      perPage: fetchLimit,
      page: 1,
    );

    final List<WorkflowRun> result = [];
    bool hasNext = false;

    do {
      final runs = page.values;

      for (final run in runs) {
        if (run.number <= lastRunNumber) {
          return result;
        }

        result.add(run);
      }

      hasNext = page.hasNextPage;

      if (hasNext) {
        final interaction = await githubActionsClient.fetchNextRunsPage(page);
        _throwIfInteractionUnsuccessful(interaction);

        page = interaction.result;
      }
    } while (hasNext);

    return result;
  }

  /// Fetches a [WorkflowRunsPage] with the given parameters delegating them to
  /// the [GithubActionsClient.fetchWorkflowRuns] method.
  Future<WorkflowRunsPage> _fetchRunsPage({
    String workflowIdentifier,
    RunStatus status,
    int perPage,
    int page,
  }) async {
    final interaction = await githubActionsClient.fetchWorkflowRuns(
      workflowIdentifier,
      status: status,
      perPage: perPage,
      page: page,
    );

    _throwIfInteractionUnsuccessful(interaction);

    return interaction.result;
  }

  /// Maps the given [runs] to a list of [BuildData]s.
  ///
  /// A [workflowIdentifier] is either a workflow id or a name of the file
  /// that defines the workflow.
  Future<List<BuildData>> _mapRunsToBuildData({
    String workflowIdentifier,
    List<WorkflowRun> runs,
  }) async {
    final buildFutures = runs.map(
      (run) => _mapRunToBuildData(
        workflowIdentifier: workflowIdentifier,
        run: run,
      ),
    );

    return Future.wait(buildFutures);
  }

  /// Fetches the coverage for the given [run].
  ///
  /// Returns `null` if the coverage file is not found.
  Future<Percent> _fetchCoverage(WorkflowRun run) async {
    final artifactsInteraction = await githubActionsClient.fetchRunArtifacts(
      run.id,
      perPage: fetchLimit,
      page: 1,
    );
    _throwIfInteractionUnsuccessful(artifactsInteraction);

    WorkflowRunArtifactsPage page = artifactsInteraction.result;
    bool hasNext = false;

    do {
      final artifacts = page.values;

      final coverageArtifact = artifacts.firstWhere(
        (artifact) => artifact.name == 'coverage-summary.json',
        orElse: () => null,
      );

      if (coverageArtifact != null) {
        return _mapArtifactToCoverage(coverageArtifact);
      }

      hasNext = page.hasNextPage;

      if (hasNext) {
        final interaction =
            await githubActionsClient.fetchNextRunArtifactsPage(page);
        _throwIfInteractionUnsuccessful(interaction);

        page = interaction.result;
      }
    } while (hasNext);

    return null;
  }

  /// Fetches the [WorkflowRunDuration] of the given [run].
  Future<Duration> _fetchRunDuration(WorkflowRun run) async {
    final interaction = await githubActionsClient.fetchRunDuration(run.id);

    _throwIfInteractionUnsuccessful(interaction);

    return interaction.result.duration;
  }

  /// Maps the given [artifact] to the coverage [Percent] value.
  ///
  /// Returns `null` if the coverage file is not found.
  Future<Percent> _mapArtifactToCoverage(WorkflowRunArtifact artifact) async {
    final interaction =
        await githubActionsClient.downloadRunArtifactZip(artifact.downloadUrl);
    _throwIfInteractionUnsuccessful(interaction);

    final artifactBytes = interaction.result;
    final artifactArchive = archiveHelper.decodeArchive(artifactBytes);

    final coverageFile = archiveHelper.getFile(
      artifactArchive,
      'coverage-summary.json',
    );

    final coverageContent = utf8.decode(coverageFile.content as Uint8List);
    final coverageJson = jsonDecode(coverageContent) as Map<String, dynamic>;
    final coverage = CoverageJsonSummary.fromJson(coverageJson);

    return coverage?.total?.branches?.percent;
  }

  /// Maps the given [run] to the [BuildData] instance.
  ///
  /// A [workflowIdentifier] is either a workflow id or a name of the file
  /// that defines the workflow.
  Future<BuildData> _mapRunToBuildData({
    String workflowIdentifier,
    WorkflowRun run,
  }) async {
    return BuildData(
      buildNumber: run.number,
      startedAt: run.createdAt,
      buildStatus: _mapConclusionToBuildStatus(run.conclusion),
      duration: await _fetchRunDuration(run),
      workflowName: workflowIdentifier,
      url: run.url,
      coverage: await _fetchCoverage(run),
    );
  }

  /// Maps the given [conclusion] to the [BuildStatus].
  BuildStatus _mapConclusionToBuildStatus(RunConclusion conclusion) {
    switch (conclusion) {
      case RunConclusion.success:
        return BuildStatus.successful;
      case RunConclusion.skipped:
        return BuildStatus.cancelled;
      case RunConclusion.cancelled:
        return BuildStatus.cancelled;
      default:
        return BuildStatus.failed;
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
    githubActionsClient.close();
  }
}
