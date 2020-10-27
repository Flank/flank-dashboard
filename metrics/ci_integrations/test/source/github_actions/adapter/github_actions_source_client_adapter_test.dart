import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_adapter.dart';
import 'package:ci_integration/util/archive/archive_helper.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceClientAdapter", () {
    const defaultId = 1;
    const defaultWorkflowIdentifier = 'workflow';
    const defaultJobName = 'job';
    const defaultCoverageArtifactName = 'coverage artifact';
    const defaultCoverageArtifactFileName = 'coverage-summary.json';
    final defaultCoverage = Percent(0.6);
    const defaultUrl = 'url';
    final defaultStartDateTime = DateTime(2020);
    final defaultCompleteDateTime = DateTime(2021);
    final defaultDuration =
        defaultCompleteDateTime.difference(defaultStartDateTime);

    final archiveHelperMock = _ArchiveHelperMock();
    final githubActionsClientMock = _GithubActionsClientMock();
    final responses = _GithubActionsClientResponse();

    final adapter = GithubActionsSourceClientAdapter(
      githubActionsClient: githubActionsClientMock,
      archiveHelper: archiveHelperMock,
      workflowIdentifier: defaultWorkflowIdentifier,
      coverageArtifactName: defaultCoverageArtifactName,
    );

    final coverageJson = <String, dynamic>{
      'pct': 0.6,
    };
    final defaultArchive = Archive();
    final archiveFile = ArchiveFile(
      defaultCoverageArtifactFileName,
      1,
      utf8.encode(jsonEncode(coverageJson)),
    );
    defaultArchive.files = [archiveFile];

    final defaultArtifact = WorkflowRunArtifact(
      name: defaultCoverageArtifactName,
      downloadUrl: defaultUrl,
    );
    final defaultRunArtifactsPage = WorkflowRunArtifactsPage(
      values: [defaultArtifact],
    );
    final emptyArtifactsPage = WorkflowRunArtifactsPage(
      page: 1,
      nextPageUrl: defaultUrl,
      values: const [],
    );
    final emptyWorkflowRunJobsPage = WorkflowRunJobsPage(
      page: 1,
      nextPageUrl: defaultUrl,
      values: const [],
    );

    PostExpectation<Future<InteractionResult>> whenFetchWorkflowRuns() {
      when(githubActionsClientMock.downloadRunArtifactZip(
        any,
      )).thenAnswer((_) => responses.downloadRunArtifactZip());

      when(
        archiveHelperMock.decodeArchive(any),
      ).thenReturn(defaultArchive);

      when(
        archiveHelperMock.getFile(any, any),
      ).thenReturn(archiveFile);

      when(githubActionsClientMock.fetchRunJobs(
        any,
        status: anyNamed('status'),
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      )).thenAnswer((_) => responses.fetchRunJobs());

      when(githubActionsClientMock.fetchRunJobsNext(
        any,
      )).thenAnswer(
        (invocation) => responses.fetchRunJobsNext(
          invocation.positionalArguments.first as WorkflowRunJobsPage,
        ),
      );

      when(githubActionsClientMock.fetchRunArtifacts(
        any,
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      )).thenAnswer((_) => responses.fetchRunArtifacts());

      when(githubActionsClientMock.fetchRunArtifactsNext(
        any,
      )).thenAnswer(
        (invocation) => responses.fetchRunArtifactsNext(
          invocation.positionalArguments.first as WorkflowRunArtifactsPage,
        ),
      );

      when(
        githubActionsClientMock.fetchWorkflowRunsNext(any),
      ).thenAnswer(
        (invocation) => responses.fetchWorkflowRunsNext(
          invocation.positionalArguments.first as WorkflowRunsPage,
        ),
      );

      return when(
        githubActionsClientMock.fetchWorkflowRuns(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      );
    }

    /// Creates a [BuildData] instance with the given [buildNumber]
    /// and default build arguments.
    BuildData createBuildData({
      @required int buildNumber,
      BuildStatus buildStatus = BuildStatus.successful,
    }) {
      return BuildData(
        buildNumber: buildNumber,
        startedAt: defaultStartDateTime,
        buildStatus: buildStatus,
        duration: defaultDuration,
        workflowName: defaultJobName,
        url: defaultUrl,
        coverage: defaultCoverage,
      );
    }

    /// Creates a list of [BuildData]s using the given [buildNumbers].
    List<BuildData> createBuildDataList({
      @required List<int> buildNumbers,
    }) {
      return buildNumbers.map((buildNumber) {
        return createBuildData(buildNumber: buildNumber);
      }).toList();
    }

    /// Creates a [WorkflowRun] instance with the given [runNumber], [runId]
    /// and [status] arguments. Other run parameters equal to default ones.
    ///
    /// The [id] defaults to the [defaultId].
    /// The [status] defaults to the [GithubActionStatus.completed].
    WorkflowRun createWorkflowRun({
      @required int runNumber,
      int id = defaultId,
      GithubActionStatus status = GithubActionStatus.completed,
    }) {
      return WorkflowRun(
        id: id,
        number: runNumber,
        url: defaultUrl,
        status: status,
        createdAt: defaultStartDateTime,
      );
    }

    /// Creates a list of [WorkflowRun]s using the given [runNumbers].
    List<WorkflowRun> createWorkflowRunsList({
      @required List<int> runNumbers,
    }) {
      return runNumbers.map((runNumber) {
        return createWorkflowRun(runNumber: runNumber);
      }).toList();
    }

    /// Creates a [WorkflowRunJob] instance with the given [status] and
    /// [conclusion].
    ///
    /// [status] defaults to [GithubActionStatus.completed].
    /// [conclusion] defaults to [GithubActionConclusion.success].
    WorkflowRunJob createWorkflowRunJob({
      GithubActionStatus status = GithubActionStatus.completed,
      GithubActionConclusion conclusion = GithubActionConclusion.success,
    }) {
      return WorkflowRunJob(
        id: defaultId,
        runId: defaultId,
        name: defaultJobName,
        url: defaultUrl,
        status: status,
        conclusion: conclusion,
        startedAt: defaultStartDateTime,
        completedAt: defaultCompleteDateTime,
      );
    }

    /// Creates a list of [WorkflowRunJob]s of the given [length].
    List<WorkflowRunJob> createWorkflowRunJobsList(int length) {
      return List.generate(
        length,
        (index) => createWorkflowRunJob(),
      );
    }

    final defaultRunsPage = WorkflowRunsPage(
      values: createWorkflowRunsList(runNumbers: [1, 2]),
    );
    final defaultJobsPage = WorkflowRunJobsPage(
      values: createWorkflowRunJobsList(2),
    );
    final defaultBuildData = createBuildDataList(buildNumbers: [1, 2]);

    setUp(() {
      reset(githubActionsClientMock);
      reset(archiveHelperMock);
      responses.reset();
    });

    test(
      "throws an ArgumentError if the given Github Actions client is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: null,
            archiveHelper: archiveHelperMock,
            workflowIdentifier: defaultWorkflowIdentifier,
            coverageArtifactName: defaultCoverageArtifactName,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given archive helper is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: githubActionsClientMock,
            archiveHelper: null,
            workflowIdentifier: defaultWorkflowIdentifier,
            coverageArtifactName: defaultCoverageArtifactName,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given workflow identifier is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: githubActionsClientMock,
            archiveHelper: archiveHelperMock,
            workflowIdentifier: null,
            coverageArtifactName: defaultCoverageArtifactName,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given coverage artifact name is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: githubActionsClientMock,
            archiveHelper: archiveHelperMock,
            workflowIdentifier: defaultWorkflowIdentifier,
            coverageArtifactName: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final adapter = GithubActionsSourceClientAdapter(
          githubActionsClient: githubActionsClientMock,
          archiveHelper: archiveHelperMock,
          workflowIdentifier: defaultWorkflowIdentifier,
          coverageArtifactName: defaultCoverageArtifactName,
        );

        expect(adapter.githubActionsClient, equals(githubActionsClientMock));
        expect(adapter.archiveHelper, equals(archiveHelperMock));
        expect(adapter.workflowIdentifier, equals(defaultWorkflowIdentifier));
        expect(
            adapter.coverageArtifactName, equals(defaultCoverageArtifactName));
      },
    );

    test(
      ".fetchBuilds() fetches builds",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuilds(defaultJobName);

        expect(result, completion(equals(defaultBuildData)));
      },
    );

    test(
      ".fetchBuilds() fetches coverage for each build",
      () async {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final expected = [defaultCoverage, defaultCoverage];

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = await adapter.fetchBuilds(defaultJobName);
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expected));
      },
    );

    test(
      ".fetchBuilds() not more than the GithubActionsSourceClientAdapter.fetchLimit builds",
      () {
        final workflowRuns = createWorkflowRunsList(
          runNumbers: List.generate(30, (index) => index),
        );
        responses.addRunsPages([WorkflowRunsPage(values: workflowRuns)]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuilds(defaultJobName);

        expect(
          result,
          completion(hasLength(GithubActionsSourceClientAdapter.fetchLimit)),
        );
      },
    );

    test(
      ".fetchBuilds() does not fetch the skipped builds",
      () {
        final workflowRunJob =
            createWorkflowRunJob(conclusion: GithubActionConclusion.skipped);

        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([
          WorkflowRunJobsPage(values: [workflowRunJob])
        ]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuilds() fetches builds using pagination for workflow run jobs",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuilds(defaultJobName);

        expect(result, completion(equals(defaultBuildData)));
      },
    );

    test(
      ".fetchBuilds() fetches builds using pagination for run artifacts",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages(
            [emptyArtifactsPage, defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuilds(defaultJobName);

        expect(result, completion(equals(defaultBuildData)));
      },
    );

    test(
      ".fetchBuilds() throws a StateError if fetching a workflow runs page fails",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        when(githubActionsClientMock.fetchWorkflowRuns(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenAnswer((_) => responses.error<WorkflowRunsPage>());

        final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if looking for the coverage artifact fails",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        when(githubActionsClientMock.fetchRunArtifacts(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

        final result = adapter.fetchBuilds(defaultJobName);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if paginating through coverage artifacts fails",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages(
            [emptyArtifactsPage, defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.fetchRunArtifactsNext(any))
            .thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

        final result = adapter.fetchBuilds(defaultJobName);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if looking for the workflow run job fails",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

        final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if paginating through run jobs fails",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.fetchRunJobsNext(any))
            .thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

        final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if downloading a coverage artifact archive fails",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.downloadRunArtifactZip(any))
            .thenAnswer((_) => responses.error<Uint8List>());

        final result = adapter.fetchBuilds(defaultJobName);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() maps fetched builds statuses according to specification",
      () {
        const runConclusions = [
          GithubActionConclusion.success,
          GithubActionConclusion.failure,
          GithubActionConclusion.cancelled,
          GithubActionConclusion.neutral,
          GithubActionConclusion.actionRequired,
          GithubActionConclusion.timedOut,
          null,
        ];

        const expectedStatuses = [
          BuildStatus.successful,
          BuildStatus.failed,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
        ];

        final workflowRuns = <WorkflowRun>[];
        final expected = <BuildData>[];

        final length = min(runConclusions.length, expectedStatuses.length);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        for (int i = 0; i < length; i++) {
          final workflowRun = createWorkflowRun(id: i, runNumber: i + 1);
          final workflowRunJob = createWorkflowRunJob(
            conclusion: runConclusions[i],
          );

          final runId = workflowRun.id;
          when(githubActionsClientMock.fetchRunJobs(
            runId,
            status: anyNamed('status'),
            perPage: anyNamed('perPage'),
            page: anyNamed('page'),
          )).thenAnswer((_) => responses.fetchRunJobs(i));

          workflowRuns.add(workflowRun);
          responses.addRunJobsPages([
            WorkflowRunJobsPage(values: [workflowRunJob])
          ]);

          expected.add(createBuildData(
            buildNumber: i + 1,
            buildStatus: expectedStatuses[i],
          ));
        }

        responses.addRunsPages([WorkflowRunsPage(values: workflowRuns)]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final result = adapter.fetchBuilds(defaultJobName);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches all builds after the given one",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final lastBuild = createBuildData(buildNumber: 1);
        final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() returns an empty list if there are no new builds",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final lastBuild = createBuildData(buildNumber: 4);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          lastBuild,
        );

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build",
      () async {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final lastBuild = createBuildData(buildNumber: 1);
        final expected = [defaultCoverage, defaultCoverage, defaultCoverage];

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = await adapter.fetchBuildsAfter(
          defaultJobName,
          lastBuild,
        );

        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expected));
      },
    );

    test(
      ".fetchBuilds() does not fetch the skipped builds",
      () {
        final workflowRunJob =
            createWorkflowRunJob(conclusion: GithubActionConclusion.skipped);

        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([
          WorkflowRunJobsPage(values: [workflowRunJob])
        ]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final lastBuild = createBuildData(buildNumber: 1);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          lastBuild,
        );

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using pagination for workflow runs",
      () {
        final firstPage = WorkflowRunsPage(
          page: 1,
          nextPageUrl: defaultUrl,
          values: createWorkflowRunsList(runNumbers: [4, 3]),
        );
        final secondPage = WorkflowRunsPage(
          page: 2,
          values: createWorkflowRunsList(runNumbers: [2, 1]),
        );

        responses.addRunsPages([firstPage, secondPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final firstBuild = BuildData(buildNumber: 1);
        final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          firstBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using the pagination for run artifacts",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages(
            [emptyArtifactsPage, defaultRunArtifactsPage]);

        final lastBuild = createBuildData(buildNumber: 1);
        final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using pagination for run jobs",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final lastBuild = createBuildData(buildNumber: 1);
        final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if fetching a workflow runs page fails",
      () {
        responses.addRunsPages([defaultRunsPage]);
        responses.addRunJobsPages([defaultJobsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        when(githubActionsClientMock.fetchWorkflowRuns(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenAnswer((_) => responses.error<WorkflowRunsPage>());

        final firstBuild = createBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through workflow runs fails",
      () {
        final firstRunsPage = WorkflowRunsPage(
            nextPageUrl: defaultUrl,
            values: createWorkflowRunsList(runNumbers: [4, 3, 2]));
        responses.addRunsPages([firstRunsPage, defaultRunsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);
        responses.addRunJobsPages([defaultJobsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.fetchWorkflowRunsNext(any))
            .thenAnswer((_) => responses.error<WorkflowRunsPage>());

        final firstBuild = createBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if looking for the coverage artifact fails",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);
        responses.addRunJobsPages([defaultJobsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.fetchRunArtifacts(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

        final firstBuild = createBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through run artifacts fails",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunArtifactsPages(
            [emptyArtifactsPage, defaultRunArtifactsPage]);
        responses.addRunJobsPages([defaultJobsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.fetchRunArtifactsNext(any))
            .thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

        final firstBuild = createBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if looking for the run job fails",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);
        responses.addRunJobsPages([defaultJobsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.fetchRunJobs(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

        final firstBuild = createBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through run jobs fails",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);
        responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.fetchRunJobsNext(any))
            .thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

        final firstBuild = createBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if downloading an artifact archive fails",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);
        responses.addRunJobsPages([defaultJobsPage]);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());
        when(githubActionsClientMock.downloadRunArtifactZip(any))
            .thenAnswer((_) => responses.error<Uint8List>());

        final firstBuild = createBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          defaultJobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds statuses according to specification",
      () {
        const runConclusions = [
          GithubActionConclusion.success,
          GithubActionConclusion.failure,
          GithubActionConclusion.cancelled,
          GithubActionConclusion.neutral,
          GithubActionConclusion.actionRequired,
          GithubActionConclusion.timedOut,
          null,
        ];

        const expectedStatuses = [
          BuildStatus.successful,
          BuildStatus.failed,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
        ];

        final workflowRuns = <WorkflowRun>[];
        final expected = <BuildData>[];

        final length = min(runConclusions.length, expectedStatuses.length);

        whenFetchWorkflowRuns()
            .thenAnswer((_) => responses.fetchWorkflowRuns());

        for (int i = 0; i < length; i++) {
          final workflowRun = createWorkflowRun(id: i, runNumber: i + 1);
          final workflowRunJob = createWorkflowRunJob(
            conclusion: runConclusions[i],
          );

          final runId = workflowRun.id;
          when(githubActionsClientMock.fetchRunJobs(
            runId,
            status: anyNamed('status'),
            perPage: anyNamed('perPage'),
            page: anyNamed('page'),
          )).thenAnswer((_) => responses.fetchRunJobs(i));

          workflowRuns.add(workflowRun);
          responses.addRunJobsPages([
            WorkflowRunJobsPage(values: [workflowRunJob])
          ]);

          expected.add(createBuildData(
            buildNumber: i + 1,
            buildStatus: expectedStatuses[i],
          ));
        }

        responses.addRunsPages([WorkflowRunsPage(values: workflowRuns)]);
        responses.addRunArtifactsPages([defaultRunArtifactsPage]);

        final firstBuild = BuildData(buildNumber: 0);
        final result = adapter.fetchBuildsAfter(defaultJobName, firstBuild);

        expect(result, completion(equals(expected)));
      },
    );
  });
}

class _GithubActionsClientMock extends Mock implements GithubActionsClient {}

class _ArchiveHelperMock extends Mock implements ArchiveHelper {}

/// A class that provides methods for building [_GithubActionsClientMock]
/// responses.
class _GithubActionsClientResponse {
  /// A list of [WorkflowRunsPage]s to use in responses.
  final List<WorkflowRunsPage> _runsPages = [];

  /// A list of [WorkflowRunArtifactsPage]s to use in responses.
  final List<WorkflowRunArtifactsPage> _runArtifactsPages = [];

  /// A list of [WorkflowRunJobsPage]s to use in responses.
  final List<WorkflowRunJobsPage> _runJobsPages = [];

  /// Creates a new instance of the [_GithubActionsClientResponse].
  _GithubActionsClientResponse();

  /// Adds the given [runsPages] to the [_runsPages].
  void addRunsPages(Iterable<WorkflowRunsPage> runsPages) {
    _runsPages.addAll(runsPages);
  }

  /// Adds the given [runArtifactsPages] to the [_runArtifactsPages].
  void addRunArtifactsPages(
    Iterable<WorkflowRunArtifactsPage> runArtifactsPages,
  ) {
    _runArtifactsPages.addAll(runArtifactsPages);
  }

  /// Adds the given [runArtifactsPages] to the [_runJobsPages].
  void addRunJobsPages(
    Iterable<WorkflowRunJobsPage> runJobsPages,
  ) {
    _runJobsPages.addAll(runJobsPages);
  }

  /// Builds the response for the [GithubActionsClient.fetchWorkflowRuns] method.
  Future<InteractionResult<WorkflowRunsPage>> fetchWorkflowRuns([int page]) {
    final result = _runsPages[page ?? 0];

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchWorkflowRunsNext]
  /// method.
  Future<InteractionResult<WorkflowRunsPage>> fetchWorkflowRunsNext(
    WorkflowRunsPage currentPage,
  ) {
    final pageNumber = currentPage.page;

    final result = _runsPages[pageNumber];

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchRunArtifacts] method.
  Future<InteractionResult<WorkflowRunArtifactsPage>> fetchRunArtifacts([
    int page,
  ]) {
    final result = _runArtifactsPages[page ?? 0];

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchRunArtifactsNext]
  /// method.
  Future<InteractionResult<WorkflowRunArtifactsPage>> fetchRunArtifactsNext(
    WorkflowRunArtifactsPage currentPage,
  ) {
    final pageNumber = currentPage.page;

    final result = _runArtifactsPages[pageNumber];

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchRunJobs] method.
  Future<InteractionResult<WorkflowRunJobsPage>> fetchRunJobs([int page]) {
    final result = _runJobsPages[page ?? 0];

    print(result);

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchRunJobsNext]
  /// method.
  Future<InteractionResult<WorkflowRunJobsPage>> fetchRunJobsNext(
    WorkflowRunJobsPage currentPage,
  ) {
    final pageNumber = currentPage.page;

    final result = _runJobsPages[pageNumber];

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.downloadRunArtifactZip]
  /// method.
  Future<InteractionResult<Uint8List>> downloadRunArtifactZip() {
    final result = Uint8List.fromList([]);

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the error response creating an [InteractionResult.error] instance.
  Future<InteractionResult<T>> error<T>() {
    return _wrapFuture(InteractionResult<T>.error());
  }

  /// Wraps the given [value] into the [Future.value].
  Future<T> _wrapFuture<T>(T value) {
    return Future.value(value);
  }

  /// Resets this [_GithubActionsClientResponse] for a new test case to ensure
  /// different test cases have no hidden dependencies.
  void reset() {
    _runsPages.clear();
    _runArtifactsPages.clear();
    _runJobsPages.clear();
  }
}
