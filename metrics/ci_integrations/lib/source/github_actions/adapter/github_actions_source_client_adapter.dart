// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
import 'package:ci_integration/util/validator/number_validator.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// An adapter for [GithubActionsClient] to implement the [SourceClient]
/// interface.
class GithubActionsSourceClientAdapter
    with LoggerMixin
    implements SourceClient {
  /// A default number of instances to request in paginated requests.
  static const int defaultPerPage = 25;

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
  Future<List<BuildData>> fetchBuilds(
    String jobName,
    int fetchLimit,
  ) async {
    NumberValidator.checkGreaterThan(fetchLimit, 0);

    logger.info('Fetching builds...');
    return _fetchLatestBuilds(
      jobName,
      fetchLimit: fetchLimit,
    );
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
      status: GithubActionStatus.completed,
    );

    final runs = firstRunsPage.values ?? [];

    if (runs.isEmpty || runs.first.number <= latestBuildNumber) return [];

    return _fetchLatestBuilds(
      jobName,
      latestBuildNumber: latestBuildNumber,
    );
  }

  @override
  Future<Percent> fetchCoverage(BuildData build) async {
    ArgumentError.checkNotNull(build, 'build');

    logger.info('Fetching workflow run for build #${build.buildNumber}...');
    final interaction =
        await githubActionsClient.fetchWorkflowRunByUrl(build.apiUrl);
    final workflowRun = _processInteraction(interaction);

    if (workflowRun == null) return null;

    final coverageArtifact = await _fetchCoverageArtifact(workflowRun);
    final artifactBytes = await _downloadArtifact(coverageArtifact);

    return _mapArtifactToCoverage(artifactBytes);
  }

  @override
  Future<BuildData> fetchOneBuild(String jobName, int buildNumber) async {
    ArgumentError.checkNotNull(jobName, 'jobName');
    ArgumentError.checkNotNull(buildNumber, 'buildNumber');

    logger.info(
      'Fetching $jobName build with the build number equal to $buildNumber...',
    );

    final run = await _fetchWorkflowRun(
      buildNumber,
    );

    if (run == null || !_isConclusionValid(run.conclusion)) {
      return null;
    }

    final job = await _fetchJob(run, jobName);

    if (job == null || !_isConclusionValid(job.conclusion)) {
      return null;
    }

    return _mapJobToBuildData(job, run);
  }

  /// Fetches the [WorkflowRun] with the given [runNumber].
  ///
  /// Returns `null` if there is no workflow run with the given [runNumber].
  Future<WorkflowRun> _fetchWorkflowRun(int runNumber) async {
    final latestWorkflowRunsPage = await _fetchRunsPage(
      page: 1,
      perPage: 1,
    );
    final latestWorkflowRuns = latestWorkflowRunsPage.values;

    if (latestWorkflowRuns == null || latestWorkflowRuns.isEmpty) return null;

    final latestWorkflowRun = latestWorkflowRuns.first;
    final latestWorkflowRunNumber = latestWorkflowRun.number;

    if (latestWorkflowRunNumber < runNumber) return null;

    if (latestWorkflowRunNumber == runNumber) {
      return latestWorkflowRun;
    }

    final numberOfRunsToFetch = latestWorkflowRunNumber - runNumber + 1;
    final workflowRunsPage = await _fetchRunsPage(
      page: 1,
      perPage: numberOfRunsToFetch,
    );
    final workflowRuns = workflowRunsPage.values;

    return workflowRuns.firstWhere(
      (run) => run.number == runNumber,
      orElse: () => null,
    );
  }

  /// Fetches the latest builds by the given [jobName].
  ///
  /// If the [latestBuildNumber] is not `null`, returns all builds with the
  /// [Build.buildNumber] greater than the given [latestBuildNumber].
  /// Otherwise, returns no more than [fetchLimit] latest builds.
  Future<List<BuildData>> _fetchLatestBuilds(
    String jobName, {
    int latestBuildNumber,
    int fetchLimit,
  }) async {
    final List<BuildData> result = [];
    bool hasNext = true;

    WorkflowRunsPage runsPage = await _fetchRunsPage(
      page: 1,
      perPage: defaultPerPage,
      status: GithubActionStatus.completed,
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
        runsPage = await _fetchNextRunsPage(runsPage);
      }
    } while (hasNext);

    return result;
  }

  /// Fetches a [WorkflowRunsPage] with the given parameters delegating them to
  /// the [GithubActionsClient.fetchWorkflowRuns] method.
  Future<WorkflowRunsPage> _fetchRunsPage({
    int page,
    int perPage,
    GithubActionStatus status,
  }) async {
    final interaction = await githubActionsClient.fetchWorkflowRuns(
      workflowIdentifier,
      status: status,
      page: page,
      perPage: perPage,
    );

    return _processInteraction(interaction);
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
      apiUrl: run.apiUrl,
    );
  }

  /// Fetches a [WorkflowRunJob] of the given [run] that has the the
  /// [WorkflowRunJob.name] that is equal to the given [jobName].
  Future<WorkflowRunJob> _fetchJob(WorkflowRun run, String jobName) async {
    final runId = run.id;

    WorkflowRunJobsPage runJobsPage = await _fetchWorkflowRunJobs(runId);
    bool hasNext = false;

    do {
      final jobs = runJobsPage.values;

      final job = jobs.firstWhere(
        (job) => job.name == jobName,
        orElse: () => null,
      );

      if (job != null) {
        return job;
      }

      hasNext = runJobsPage.hasNextPage;

      if (hasNext) {
        runJobsPage = await _fetchNextWorkflowRunJobs(runJobsPage);
      }
    } while (hasNext);

    return null;
  }

  /// Fetches the next [WorkflowRunsPage] after to the given [workflowRunsPage].
  Future<WorkflowRunsPage> _fetchNextRunsPage(
    WorkflowRunsPage workflowRunsPage,
  ) async {
    final interaction = await githubActionsClient.fetchWorkflowRunsNext(
      workflowRunsPage,
    );

    return _processInteraction(interaction);
  }

  /// Determines whether the given [conclusion] is valid.
  ///
  /// The [conclusion] is valid if and only if it is not equal
  /// to the [GithubActionConclusion.skipped].
  bool _isConclusionValid(GithubActionConclusion conclusion) {
    return conclusion != GithubActionConclusion.skipped;
  }

  /// Fetches the [WorkflowRunJobsPage] with the given parameters delegating
  /// them to the [githubActionsClient].
  ///
  /// The [page] defaults to `1`.
  /// The [perPage] defaults to [defaultPerPage].
  Future<WorkflowRunJobsPage> _fetchWorkflowRunJobs(
    int runId, {
    int page = 1,
    int perPage = defaultPerPage,
  }) async {
    final interaction = await githubActionsClient.fetchRunJobs(
      runId,
      page: page,
      perPage: perPage,
    );

    return _processInteraction(interaction);
  }

  /// Fetches the next [WorkflowRunJobsPage] after to the given [runJobsPage].
  Future<WorkflowRunJobsPage> _fetchNextWorkflowRunJobs(
    WorkflowRunJobsPage runJobsPage,
  ) async {
    final interaction = await githubActionsClient.fetchRunJobsNext(runJobsPage);

    return _processInteraction(interaction);
  }

  /// Fetches an artifact with coverage data for the given workflow [run].
  ///
  /// Returns `null` if the coverage artifact with the [coverageArtifactName]
  /// is not found.
  Future<WorkflowRunArtifact> _fetchCoverageArtifact(WorkflowRun run) async {
    logger.info(
      'Fetching coverage artifact for a workflow #${run.number}...',
    );
    final interaction = await githubActionsClient.fetchRunArtifacts(
      run.id,
      page: 1,
      perPage: defaultPerPage,
    );

    WorkflowRunArtifactsPage page = _processInteraction(interaction);
    WorkflowRunArtifact artifact;
    bool hasNext = false;

    do {
      final artifacts = page.values;

      artifact = artifacts.firstWhere(
        (artifact) => artifact.name == coverageArtifactName,
        orElse: () => null,
      );

      hasNext = page.hasNextPage && artifact == null;

      if (hasNext) {
        final interaction =
            await githubActionsClient.fetchRunArtifactsNext(page);

        page = _processInteraction(interaction);
      }
    } while (hasNext);

    return artifact;
  }

  /// Downloads the given [artifact] using the [WorkflowRunArtifact.downloadUrl].
  ///
  /// If the given artifact is `null`, returns `null`.
  Future<Uint8List> _downloadArtifact(WorkflowRunArtifact artifact) async {
    if (artifact == null) return null;

    final interaction =
        await githubActionsClient.downloadRunArtifactZip(artifact.downloadUrl);
    final artifactBytes = _processInteraction(interaction);
    final artifactArchive = archiveHelper.decodeArchive(artifactBytes);

    final content = archiveHelper.getFileContent(
      artifactArchive,
      'coverage-summary.json',
    );

    return content;
  }

  /// Maps the given [artifactBytes] into the coverage [Percent] value.
  ///
  /// Returns `null` if either the given [artifactBytes] is `null` or
  /// JSON content parsing is failed.
  Future<Percent> _mapArtifactToCoverage(Uint8List artifactBytes) async {
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
    githubActionsClient.close();
  }
}
