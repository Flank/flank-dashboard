import 'dart:async';
import 'dart:convert';

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/util/archive/archive_helper.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [GithubActionsClient] to implement the [SourceClient]
/// interface.
class GithubActionsSourceClientAdapter
    with LoggerMixin
    implements SourceClient {
  /// A fetch limit for Github Actions API calls.
  static const int fetchLimit = 25;

  /// A [GithubActionsClient] instance to perform API calls.
  final GithubActionsClient githubActionsClient;

  /// A unique identifier of the Github Actions workflow
  /// this adapter should work with.
  ///
  /// This identifier is used to fetch [WorkflowRun]s.
  /// The [GithubActionsSourceConfig.workflowIdentifier] provides a
  /// configuration for this parameter.
  final String workflowIdentifier;

  /// A name of the coverage artifact this adapter should fetch.
  ///
  /// This name is used to filter workflow run artifacts using
  /// [WorkflowRunArtifact.name].
  /// The [GithubActionsSourceConfig.coverageArtifactName] provides a
  /// configuration for this parameter.
  final String coverageArtifactName;

  /// An [ArchiveHelper] to work with the compressed responses data.
  final ArchiveHelper archiveHelper;

  /// Creates a new instance of the [GithubActionsSourceClientAdapter].
  ///
  /// Throws an [ArgumentError] if at least one of the required parameters
  /// is `null`.
  GithubActionsSourceClientAdapter({
    @required this.githubActionsClient,
    @required this.archiveHelper,
    @required this.workflowIdentifier,
    @required this.coverageArtifactName,
  }) {
    ArgumentError.checkNotNull(githubActionsClient, 'githubActionsClient');
    ArgumentError.checkNotNull(archiveHelper, 'archiveHelper');
    ArgumentError.checkNotNull(workflowIdentifier, 'workflowIdentifier');
    ArgumentError.checkNotNull(coverageArtifactName, 'coverageArtifactName');
  }

  @override
  Future<List<BuildData>> fetchBuilds(String jobName) async {
    logger.info('Fetching builds...');
    return _fetchLatestBuilds(jobName);
  }

  @override
  Future<List<BuildData>> fetchBuildsAfter(
    String jobName,
    BuildData build,
  ) async {
    ArgumentError.checkNotNull(build, 'build');
    final latestBuildNumber = build.buildNumber;
    logger.info('Fetching builds after build #$latestBuildNumber...');

    final firstRunsPage = await _fetchRunsPage(
      page: 1,
      perPage: 1,
    );

    final runs = firstRunsPage.values ?? [];

    if (runs.isEmpty || runs.first.number <= latestBuildNumber) return [];

    return _fetchLatestBuilds(jobName, latestBuildNumber);
  }

  /// Fetches the latest builds by the given [jobName].
  ///
  /// If the [latestBuildNumber] is not `null`, returns all builds with the
  /// [Build.buildNumber] greater than the given [latestBuildNumber]. Otherwise,
  /// returns no more than the latest [fetchLimit] builds.
  Future<List<BuildData>> _fetchLatestBuilds(
    String jobName, [
    int latestBuildNumber,
  ]) async {
    final List<BuildData> result = [];
    bool hasNext = true;

    WorkflowRunsPage runsPage = await _fetchRunsPage(
      page: 1,
      perPage: fetchLimit,
    );

    do {
      hasNext = runsPage.hasNextPage;
      final runs = runsPage.values;

      for (final run in runs) {
        if (latestBuildNumber != null && run.number <= latestBuildNumber) {
          hasNext = false;
          break;
        }

        final job = await _fetchJob(run, jobName);

        if (job == null || job.conclusion == GithubActionConclusion.skipped) {
          continue;
        } else {
          final build = await _mapJobToBuildData(job, run);
          result.add(build);

          if (latestBuildNumber == null && result.length == fetchLimit) {
            hasNext = false;
            break;
          }
        }
      }

      if (hasNext) {
        final interaction =
            await githubActionsClient.fetchWorkflowRunsNext(runsPage);
        _throwIfInteractionUnsuccessful(interaction);
        runsPage = interaction.result;
      }
    } while (hasNext);

    return result;
  }

  /// Fetches a [WorkflowRunsPage] with the given parameters delegating them to
  /// the [GithubActionsClient.fetchWorkflowRuns] method.
  Future<WorkflowRunsPage> _fetchRunsPage({
    int page,
    int perPage,
  }) async {
    final interaction = await githubActionsClient.fetchWorkflowRuns(
      workflowIdentifier,
      status: GithubActionStatus.completed,
      page: page,
      perPage: perPage,
    );

    _throwIfInteractionUnsuccessful(interaction);

    return interaction.result;
  }

  /// Maps the given [job] and [run] to the [BuildData] instance.
  Future<BuildData> _mapJobToBuildData(
    WorkflowRunJob job,
    WorkflowRun run,
  ) async {
    return BuildData(
      buildNumber: run.number,
      startedAt: job.startedAt ?? job.completedAt ?? DateTime.now(),
      buildStatus: _mapConclusionToBuildStatus(job.conclusion),
      duration: _calculateJobDuration(job),
      workflowName: job.name,
      url: job.url ?? '',
      coverage: await _fetchCoverage(run),
    );
  }

  /// Fetches a [WorkflowRunJob] of the given [run] that has the the
  /// [WorkflowRunJob.name] that is equal to the given [jobName].
  Future<WorkflowRunJob> _fetchJob(WorkflowRun run, String jobName) async {
    final runId = run.id;

    final interaction = await githubActionsClient.fetchRunJobs(
      runId,
      page: 1,
      perPage: fetchLimit,
    );

    _throwIfInteractionUnsuccessful(interaction);

    WorkflowRunJobsPage page = interaction.result;
    bool hasNext = false;

    do {
      final jobs = page.values;

      final job = jobs.firstWhere(
        (job) => job.name == jobName,
        orElse: () => null,
      );

      if (job != null) {
        return job;
      }

      hasNext = page.hasNextPage;

      if (hasNext) {
        final interaction = await githubActionsClient.fetchRunJobsNext(page);
        _throwIfInteractionUnsuccessful(interaction);

        page = interaction.result;
      }
    } while (hasNext);

    return null;
  }

  /// Fetches the coverage for the given [run].
  ///
  /// Returns `null` if the coverage artifact with the [coverageArtifactName]
  /// is not found.
  Future<Percent> _fetchCoverage(WorkflowRun run) async {
    logger.info(
      'Fetching coverage artifact for a workflow #${run.number}...',
    );

    final interaction = await githubActionsClient.fetchRunArtifacts(
      run.id,
      page: 1,
      perPage: fetchLimit,
    );
    _throwIfInteractionUnsuccessful(interaction);

    WorkflowRunArtifactsPage page = interaction.result;
    bool hasNext = false;

    do {
      final artifacts = page.values;

      final coverageArtifact = artifacts.firstWhere(
        (artifact) => artifact.name == coverageArtifactName,
        orElse: () => null,
      );

      if (coverageArtifact != null) {
        return _mapArtifactToCoverage(coverageArtifact);
      }

      hasNext = page.hasNextPage;

      if (hasNext) {
        final interaction =
            await githubActionsClient.fetchRunArtifactsNext(page);
        _throwIfInteractionUnsuccessful(interaction);

        page = interaction.result;
      }
    } while (hasNext);

    return null;
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

    final content = archiveHelper.getFileContent(
      artifactArchive,
      'coverage-summary.json',
    );

    if (content == null) return null;

    logger.info('Parsing coverage artifact...');

    final coverageContent = utf8.decode(content);
    final coverageJson = jsonDecode(coverageContent) as Map<String, dynamic>;
    final coverage = CoverageData.fromJson(coverageJson);

    return coverage?.percent;
  }

  /// Calculates a [Duration] of the given [job].
  ///
  /// Returns `null` if either [WorkflowRunJob.startedAt] or
  /// [WorkflowRunJob.completedAt] is`null`.
  Duration _calculateJobDuration(WorkflowRunJob job) {
    if (job.startedAt == null || job.completedAt == null) return Duration.zero;

    return job.completedAt.difference(job.startedAt);
  }

  /// Maps the given [conclusion] to the [BuildStatus].
  BuildStatus _mapConclusionToBuildStatus(GithubActionConclusion conclusion) {
    switch (conclusion) {
      case GithubActionConclusion.success:
        return BuildStatus.successful;
      case GithubActionConclusion.timedOut:
      case GithubActionConclusion.failure:
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
    githubActionsClient.close();
  }
}
