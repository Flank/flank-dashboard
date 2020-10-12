import 'dart:async';
import 'dart:convert';

import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_duration.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/coverage.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/coverage_json_summary.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/archive/archive_util.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [GithubActionsClient] to implement the [SourceClient]
/// interface.
class GithubActionsSourceClientAdapter implements SourceClient {
  /// A fetch limit for the paginated requests.
  static const perPageLimit = 25;

  /// A [GithubActionsClient] instance to perform API calls.
  final GithubActionsClient githubActionsClient;

  /// Creates a new instance of the [GithubActionsSourceClientAdapter].
  ///
  /// Throws an [ArgumentError] if the given [githubActionsClient] is `null`.
  GithubActionsSourceClientAdapter(this.githubActionsClient) {
    ArgumentError.checkNotNull(githubActionsClient, 'githubActionsClient');
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
  ///
  /// A [workflowIdentifier] is either a workflow id or a name of the file
  /// that defines the workflow.
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

    while (page.hasNextPage) {
      final runs = page.values;

      for (final run in runs) {
        if (run.number > lastBuildNumber) {
          result.add(run);
        }
        if (run.number == lastBuildNumber) return result;
      }

      page = await _fetchNextRunsPage(page);
    }

    return result;
  }

  /// Fetches the [WorkflowRunDuration] of the given [run].
  Future<WorkflowRunDuration> _fetchRunDuration(WorkflowRun run) async {
    final durationFetchResult =
        await githubActionsClient.fetchRunDuration(run.id);

    _throwIfInteractionUnsuccessful(durationFetchResult);

    return durationFetchResult.result;
  }

  /// Fetches the coverage after the given [run].
  /// If the coverage file was not found, returns 'null'.
  Future<Percent> _fetchCoverage(WorkflowRun run) async {
    WorkflowRunArtifactsPage page = await _fetchArtifactsPage(
      runId: run.id,
      perPage: perPageLimit,
      page: 1,
    );

    while (true) {
      final artifacts = page.values;

      final coverageArtifact = artifacts.firstWhere(
        (artifact) => artifact.name == 'coverage-summary.json',
        orElse: () => null,
      );

      if (coverageArtifact != null) {
        return _mapArtifactToCoverage(coverageArtifact);
      }

      if (!page.hasNextPage) return null;

      page = await _fetchNextArtifactsPage(page);
    }
  }

  /// Fetches a [WorkflowRunsPage] with the given [workflowIdentifier].
  ///
  /// A [workflowIdentifier] is either a workflow id or a name of the file
  /// that defines the workflow.
  ///
  /// A [status] is used as a filter query parameter to define the
  /// [WorkflowRun.status] of runs to fetch.
  ///
  /// A [perPage] is used for limiting the number of runs and pagination in pair
  /// with the [page] parameter.
  ///
  /// A [page] is used for pagination and defines a page of runs to fetch.
  /// If the [page] is `null` or omitted, the first page is fetched.
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

  /// Fetches a [WorkflowRunArtifactsPage] of a run with the given [runId].
  ///
  /// A [perPage] is used for limiting the number of runs and pagination in pair
  /// with the [page] parameter.
  ///
  /// A [page] is used for pagination and defines a page of runs to fetch.
  /// If the [page] is `null` or omitted, the first page is fetched.
  Future<WorkflowRunArtifactsPage> _fetchArtifactsPage({
    int runId,
    int perPage,
    int page,
  }) async {
    final artifactsInteraction = await githubActionsClient.fetchRunArtifacts(
      runId,
      perPage: perPage,
      page: page,
    );

    _throwIfInteractionUnsuccessful(artifactsInteraction);

    return artifactsInteraction.result;
  }

  /// Fetches the next [WorkflowRunsPage] of the given [currentPage].
  Future<WorkflowRunsPage> _fetchNextRunsPage(
    WorkflowRunsPage currentPage,
  ) async {
    final pageInteraction =
        await githubActionsClient.fetchNextRunsPage(currentPage);

    _throwIfInteractionUnsuccessful(pageInteraction);

    return pageInteraction.result;
  }

  /// Fetches the next [WorkflowRunArtifactsPage] of the given [currentPage].
  Future<WorkflowRunArtifactsPage> _fetchNextArtifactsPage(
    WorkflowRunArtifactsPage currentPage,
  ) async {
    final pageInteraction =
        await githubActionsClient.fetchNextRunArtifactsPage(currentPage);

    _throwIfInteractionUnsuccessful(pageInteraction);

    return pageInteraction.result;
  }

  /// Fetches the given [artifact], searches for the coverage file and converts
  /// it to [Coverage].
  ///
  /// If the coverage file was not found, returns `null`.
  Future<Percent> _mapArtifactToCoverage(
    WorkflowRunArtifact artifact,
  ) async {
    final artifactInteraction =
        await githubActionsClient.downloadRunArtifactZip(artifact.downloadUrl);
    _throwIfInteractionUnsuccessful(artifactInteraction);

    final artifactBytes = artifactInteraction.result;
    final coverageJsonFile = ArchiveUtil.getArchiveFile(
      bytes: artifactBytes,
      fileName: 'coverage-summary.json',
    );

    final coverageJson =
        jsonDecode(coverageJsonFile.content as String) as Map<String, dynamic>;
    final coverage = CoverageJsonSummary.fromJson(coverageJson);

    return coverage?.total?.branches?.percent;
  }

  /// Processes the given [runs] to a list of [BuildData]s.
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
    WorkflowRunDuration runDuration,
    Percent coverage,
  }) {
    return BuildData(
      buildNumber: run.number,
      startedAt: run.createdAt,
      buildStatus: _mapConclusionToBuildStatus(run.conclusion),
      duration: runDuration.duration,
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

  /// Throws a [StateError] with the message of [interactionResult] if the
  /// [interactionResult.result] is [InteractionResult.isError].
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
