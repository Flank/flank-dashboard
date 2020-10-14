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
  /// A fetch limit for the paginated requests.
  static const int perPageLimit = 25;

  /// A [GithubActionsClient] instance to perform API calls.
  final GithubActionsClient githubActionsClient;

  /// An [ArchiveUtil] to work with compressed coverage files.
  final ArchiveUtil archiveUtil;

  /// Creates a new instance of the [GithubActionsSourceClientAdapter].
  ///
  /// Throws an [ArgumentError] if either the given [githubActionsClient] or
  /// [archiveUtil] is `null`.
  GithubActionsSourceClientAdapter({
    this.githubActionsClient,
    this.archiveUtil,
  }) {
    ArgumentError.checkNotNull(githubActionsClient, 'githubActionsClient');
    ArgumentError.checkNotNull(archiveUtil, 'archiveUtil');
  }

  @override
  Future<List<BuildData>> fetchBuilds(String workflowIdentifier) async {
    final runsPage = await _fetchRunsPage(
      workflowIdentifier: workflowIdentifier,
      status: RunStatus.completed,
      perPage: perPageLimit,
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

    final lastRunNumber = initialRunsPage.values.first.number;
    final lastBuildNumber = build.buildNumber;

    if (lastRunNumber <= lastBuildNumber) return [];

    final runsAfter = await _fetchRunsAfter(
      workflowIdentifier: workflowIdentifier,
      lastBuildNumber: lastBuildNumber,
    );

    return _mapRunsToBuildData(
      runs: runsAfter,
      workflowIdentifier: workflowIdentifier,
    );
  }

  /// Fetches a list of [WorkflowRun]s that have the [WorkflowRun.runNumber]
  /// greater than the given [lastBuildNumber].
  Future<List<WorkflowRun>> _fetchRunsAfter({
    String workflowIdentifier,
    int lastBuildNumber,
  }) async {
    WorkflowRunsPage page = await _fetchRunsPage(
      workflowIdentifier: workflowIdentifier,
      status: RunStatus.completed,
      perPage: perPageLimit,
      page: 1,
    );

    final List<WorkflowRun> result = [];
    bool hasNext = false;

    do {
      final runs = page.values;

      for (final run in runs) {
        if (run.number <= lastBuildNumber) {
          return result;
        }

        result.add(run);
      }

      hasNext = page.hasNextPage;

      if (hasNext) {
        final pageInteraction =
            await githubActionsClient.fetchNextRunsPage(page);
        _throwIfInteractionUnsuccessful(pageInteraction);

        page = pageInteraction.result;
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
    final runsInteraction = await githubActionsClient.fetchWorkflowRuns(
      workflowIdentifier,
      status: status,
      perPage: perPage,
      page: page,
    );

    _throwIfInteractionUnsuccessful(runsInteraction);

    return runsInteraction.result;
  }

  /// Maps the given [runs] to a list of [BuildData]s.
  ///
  /// A [workflowIdentifier] is either a workflow id or a name of the file
  /// that defines the workflow.
  Future<List<BuildData>> _mapRunsToBuildData({
    String workflowIdentifier,
    List<WorkflowRun> runs,
  }) async {
    final buildDataFuture = runs.map(
      (run) async {
        return _mapRunToBuildData(
          workflowIdentifier: workflowIdentifier,
          run: run,
          runDuration: await _fetchRunDuration(run),
          coverage: await _fetchCoverage(run),
        );
      },
    );

    return Future.wait(buildDataFuture);
  }

  /// Fetches the coverage for the given [run].
  ///
  /// Returns `null` if the coverage file is not found.
  Future<Percent> _fetchCoverage(WorkflowRun run) async {
    final artifactsInteraction = await githubActionsClient.fetchRunArtifacts(
      run.id,
      perPage: perPageLimit,
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
        final pageInteraction =
            await githubActionsClient.fetchNextRunArtifactsPage(page);
        _throwIfInteractionUnsuccessful(pageInteraction);

        page = pageInteraction.result;
      }
    } while (hasNext);

    return null;
  }

  /// Fetches the [WorkflowRunDuration] of the given [run].
  Future<Duration> _fetchRunDuration(WorkflowRun run) async {
    final durationInteraction =
        await githubActionsClient.fetchRunDuration(run.id);

    _throwIfInteractionUnsuccessful(durationInteraction);

    return durationInteraction.result.duration;
  }

  /// Maps the given [artifact] to the coverage [Percent] value.
  ///
  /// Returns `null` if the coverage file is not found.
  Future<Percent> _mapArtifactToCoverage(WorkflowRunArtifact artifact) async {
    final artifactInteraction =
        await githubActionsClient.downloadRunArtifactZip(artifact.downloadUrl);
    _throwIfInteractionUnsuccessful(artifactInteraction);

    final artifactBytes = artifactInteraction.result;
    final artifactArchive = archiveUtil.decodeArchive(artifactBytes);

    final coverageJsonFile = archiveUtil.getFile(
      artifactArchive,
      'coverage-summary.json',
    );

    final coverageJson =
        jsonDecode(utf8.decode(coverageJsonFile.content as Uint8List))
            as Map<String, dynamic>;
    final coverage = CoverageJsonSummary.fromJson(coverageJson);

    return coverage?.total?.branches?.percent;
  }

  /// Maps the given [run] to the [BuildData] instance.
  ///
  /// A [workflowIdentifier] is either a workflow id or a name of the file
  /// that defines the workflow.
  ///
  /// A [runDuration] is the duration of the given [run].
  ///
  /// A [coverage] is the test coverage after the given run.
  BuildData _mapRunToBuildData({
    String workflowIdentifier,
    WorkflowRun run,
    Duration runDuration,
    Percent coverage,
  }) {
    return BuildData(
      buildNumber: run.number,
      startedAt: run.createdAt,
      buildStatus: _mapConclusionToBuildStatus(run.conclusion),
      duration: runDuration,
      workflowName: workflowIdentifier,
      url: run.url,
      coverage: coverage,
    );
  }

  /// Maps the given [conclusion] to the [BuildStatus].
  BuildStatus _mapConclusionToBuildStatus(RunConclusion conclusion) {
    switch (conclusion) {
      case RunConclusion.success:
        return BuildStatus.successful;
      case RunConclusion.failure:
        return BuildStatus.failed;
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
