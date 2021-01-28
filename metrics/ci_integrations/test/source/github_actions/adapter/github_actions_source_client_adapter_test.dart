import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_client_adapter.dart';
import 'package:ci_integration/util/archive/archive_helper.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/extensions/interaction_result_answer.dart';
import '../test_utils/test_data/github_actions_test_data_generator.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceClientAdapter", () {
    const jobName = 'job';
    const firstSyncFetchLimit = 28;
    final testData = GithubActionsTestDataGenerator(
      workflowIdentifier: 'workflow',
      jobName: jobName,
      coverageArtifactName: 'coverage-summary.json',
      coverage: Percent(0.6),
      url: 'url',
      startDateTime: DateTime(2020),
      completeDateTime: DateTime(2021),
      duration: DateTime(2021).difference(DateTime(2020)),
    );

    final archiveHelperMock = _ArchiveHelperMock();
    final archiveMock = _ArchiveMock();
    final githubActionsClientMock = _GithubActionsClientMock();
    final adapter = GithubActionsSourceClientAdapter(
      githubActionsClient: githubActionsClientMock,
      archiveHelper: archiveHelperMock,
      workflowIdentifier: testData.workflowIdentifier,
      coverageArtifactName: testData.coverageArtifactName,
    );

    final coverageJson = <String, dynamic>{'pct': 0.6};
    final coverageBytes = utf8.encode(jsonEncode(coverageJson)) as Uint8List;

    PostExpectation<Uint8List> whenDecodeCoverage({
      Uint8List withArtifactBytes,
    }) {
      when(
        archiveHelperMock.decodeArchive(withArtifactBytes),
      ).thenReturn(archiveMock);

      return when(
        archiveHelperMock.getFileContent(archiveMock, 'coverage-summary.json'),
      );
    }

    PostExpectation<Future<InteractionResult<WorkflowRunsPage>>>
        whenFetchWorkflowRuns({
      WorkflowRunJobsPage withJobsPage,
      WorkflowRunArtifactsPage withArtifactsPage,
      Uint8List withArtifactBytes,
    }) {
      when(
        githubActionsClientMock.downloadRunArtifactZip(any),
      ).thenSuccessWith(withArtifactBytes);

      whenDecodeCoverage(
        withArtifactBytes: withArtifactBytes,
      ).thenReturn(coverageBytes);

      when(githubActionsClientMock.fetchRunJobs(
        any,
        status: anyNamed('status'),
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      )).thenSuccessWith(withJobsPage);

      when(githubActionsClientMock.fetchRunArtifacts(
        any,
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      )).thenSuccessWith(withArtifactsPage);

      return when(
        githubActionsClientMock.fetchWorkflowRuns(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      );
    }

    final emptyArtifactsPage = WorkflowRunArtifactsPage(
      page: 1,
      nextPageUrl: testData.url,
      values: const [],
    );
    final emptyWorkflowRunJobsPage = WorkflowRunJobsPage(
      page: 1,
      nextPageUrl: testData.url,
      values: const [],
    );
    final defaultRunsPage = WorkflowRunsPage(
      values: testData.generateWorkflowRunsByNumbers(
        runNumbers: [2, 1],
      ),
    );
    final defaultJobsPage = WorkflowRunJobsPage(
      values: [testData.generateWorkflowRunJob()],
    );
    final defaultArtifactsPage = WorkflowRunArtifactsPage(values: [
      WorkflowRunArtifact(name: testData.coverageArtifactName),
    ]);
    final defaultBuildData = testData.generateBuildDataByNumbers(
      buildNumbers: [2, 1],
    );

    setUp(() {
      reset(githubActionsClientMock);
      reset(archiveHelperMock);
    });

    test(
      "throws an ArgumentError if the given Github Actions client is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: null,
            archiveHelper: archiveHelperMock,
            workflowIdentifier: testData.workflowIdentifier,
            coverageArtifactName: testData.coverageArtifactName,
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
            workflowIdentifier: testData.workflowIdentifier,
            coverageArtifactName: testData.coverageArtifactName,
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
            coverageArtifactName: testData.coverageArtifactName,
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
            workflowIdentifier: testData.workflowIdentifier,
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
          workflowIdentifier: testData.workflowIdentifier,
          coverageArtifactName: testData.coverageArtifactName,
        );

        expect(adapter.githubActionsClient, equals(githubActionsClientMock));
        expect(adapter.archiveHelper, equals(archiveHelperMock));
        expect(
          adapter.workflowIdentifier,
          equals(testData.workflowIdentifier),
        );
        expect(
          adapter.coverageArtifactName,
          equals(testData.coverageArtifactName),
        );
      },
    );

    test(
      ".fetchBuilds() throws an ArgumentError if the given first sync fetch limit is 0",
      () {
        expect(
          () => adapter.fetchBuilds(jobName, 0),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fetchBuilds() throws an ArgumentError if the given first sync fetch limit is a negative number",
      () {
        expect(
          () => adapter.fetchBuilds(jobName, -1),
          throwsArgumentError,
        );
      },
    );

    test(".fetchBuilds() fetches builds", () {
      whenFetchWorkflowRuns(
        withArtifactsPage: defaultArtifactsPage,
        withJobsPage: defaultJobsPage,
      ).thenSuccessWith(defaultRunsPage);

      final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

      expect(result, completion(equals(defaultBuildData)));
    });

    test(
      ".fetchBuilds() fetches coverage for each build",
      () async {
        final expectedCoverage = [
          testData.coverage,
          testData.coverage,
        ];

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() maps the coverage value to null if an artifact with the specified name does not exist",
      () async {
        final expectedCoverage = [null, null];

        const artifactsPage = WorkflowRunArtifactsPage(
          values: [WorkflowRunArtifact(name: 'test.json')],
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: artifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() maps the coverage value to null if an artifact archive does not contain the coverage summary json",
      () async {
        final expectedCoverage = [null, null];

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        whenDecodeCoverage(withArtifactBytes: coverageBytes).thenReturn(null);

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() returns no more than the given first sync fetch limit number of builds",
      () {
        const expectedNumberOfBuilds = 12;
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(workflowRunsPage);

        final result = adapter.fetchBuilds(jobName, expectedNumberOfBuilds);

        expect(
          result,
          completion(
            hasLength(expectedNumberOfBuilds),
          ),
        );
      },
    );

    test(
      ".fetchBuilds() does not fetch builds of the skipped jobs",
      () {
        final workflowRunJob = testData.generateWorkflowRunJob(
          conclusion: GithubActionConclusion.skipped,
        );

        final workflowRunJobsPage = WorkflowRunJobsPage(
          values: [workflowRunJob],
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: workflowRunJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuilds() fetches builds using pagination for workflow run jobs",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: emptyWorkflowRunJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunJobsNext(emptyWorkflowRunJobsPage))
            .thenSuccessWith(defaultJobsPage);

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, completion(equals(defaultBuildData)));
      },
    );

    test(
      ".fetchBuilds() fetches builds using pagination for run artifacts",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: emptyArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, completion(equals(defaultBuildData)));
      },
    );

    test(
      ".fetchBuilds() fetches coverage for each build using pagination for run artifacts",
      () async {
        whenFetchWorkflowRuns(
          withArtifactsPage: emptyArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final expectedCoverage = [
          testData.coverage,
          testData.coverage,
        ];

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() throws a StateError if fetching a workflow runs page fails",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenErrorWith();

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if fetching the coverage artifact fails",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunArtifacts(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if paginating through coverage artifacts fails",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: emptyArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenErrorWith();

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if fetching the workflow run jobs fails",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if paginating through run jobs fails",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: emptyWorkflowRunJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunJobsNext(emptyWorkflowRunJobsPage))
            .thenErrorWith();

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if downloading a coverage artifact archive fails",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.downloadRunArtifactZip(any))
            .thenErrorWith();

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() maps fetched builds statuses according to specification",
      () {
        const conclusions = [
          GithubActionConclusion.success,
          GithubActionConclusion.failure,
          GithubActionConclusion.timedOut,
          GithubActionConclusion.cancelled,
          GithubActionConclusion.neutral,
          GithubActionConclusion.actionRequired,
          null,
        ];

        const expectedStatuses = [
          BuildStatus.successful,
          BuildStatus.failed,
          BuildStatus.failed,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
        ];

        final expectedBuilds = testData.generateBuildDataByStatuses(
          statuses: expectedStatuses,
        );

        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: [1, 2, 3, 4, 5, 6, 7],
        );
        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        final workflowRunJobs = testData.generateWorkflowRunJobsByConclusions(
            conclusions: conclusions);

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);

        for (int i = 0; i < workflowRuns.length; ++i) {
          final run = workflowRuns[i];

          when(githubActionsClientMock.fetchRunJobs(
            run.id,
            status: anyNamed('status'),
            page: anyNamed('page'),
            perPage: anyNamed('perPage'),
          )).thenSuccessWith(
            WorkflowRunJobsPage(values: [workflowRunJobs[i]]),
          );
        }

        final result = adapter.fetchBuilds(jobName, firstSyncFetchLimit);

        expect(result, completion(equals(expectedBuilds)));
      },
    );

    test(
      ".fetchBuilds() maps fetched run jobs' startedAt date to the completedAt date if the startedAt date is null",
      () async {
        final completedAt = DateTime.now();
        const workflowRun = WorkflowRun(number: 1);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        final workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: null,
          completedAt: completedAt,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final startedAt = result.first.startedAt;

        expect(startedAt, equals(completedAt));
      },
    );

    test(
      ".fetchBuilds() maps fetched run jobs' startedAt date to the DateTime.now() date if the startedAt and completedAt dates are null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        const workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: null,
          completedAt: null,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          const WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final startedAt = result.first.startedAt;

        expect(startedAt, isNotNull);
      },
    );

    test(
      ".fetchBuilds() maps fetched run jobs' duration to the Duration.zero if the startedAt date is null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        final workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: null,
          completedAt: DateTime.now(),
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuilds() maps fetched run jobs' duration to the Duration.zero if the completedAt date is null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        final workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: DateTime.now(),
          completedAt: null,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuilds() maps fetched run jobs' url to the empty string if the url is null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        const workflowRunJob = WorkflowRunJob(
          name: jobName,
          url: null,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          const WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final result = await adapter.fetchBuilds(
          jobName,
          firstSyncFetchLimit,
        );
        final url = result.first.url;

        expect(url, equals(''));
      },
    );

    test(
      ".fetchBuildsAfter() fetches all builds after the given one",
      () {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final result = adapter.fetchBuildsAfter(jobName, lastBuild);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds with a greater run number than the given if the given number is not found",
      () {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [7, 6, 5, 3, 2, 1],
          ),
        );

        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [7, 6, 5],
        );

        final lastBuild = testData.generateBuildData(buildNumber: 4);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final result = adapter.fetchBuildsAfter(jobName, lastBuild);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() returns an empty list if there are no new builds",
      () {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final lastBuild = testData.generateBuildData(buildNumber: 4);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final result = adapter.fetchBuildsAfter(jobName, lastBuild);

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build",
      () async {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final expected = [
          testData.coverage,
          testData.coverage,
          testData.coverage,
        ];

        final result = await adapter.fetchBuildsAfter(
          jobName,
          lastBuild,
        );

        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expected));
      },
    );

    test(
      ".fetchBuildsAfter() maps the coverage value to null if an artifact with the specified name does not exist",
      () async {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        const artifactsPage = WorkflowRunArtifactsPage(
          values: [WorkflowRunArtifact(name: 'test.json')],
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: artifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final expectedCoverage = [null, null, null];

        final lastBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          jobName,
          lastBuild,
        );
        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() maps the coverage value to null if an artifact archive does not contain the coverage summary json",
      () async {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        whenDecodeCoverage(withArtifactBytes: coverageBytes).thenReturn(null);

        final expectedCoverage = [null, null, null];

        final lastBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          jobName,
          lastBuild,
        );
        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build using pagination for run artifacts",
      () async {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: emptyArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final expectedCoverage = [
          testData.coverage,
          testData.coverage,
          testData.coverage,
        ];

        final result = await adapter.fetchBuildsAfter(
          jobName,
          lastBuild,
        );

        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() does not fetch the skipped builds",
      () {
        const workflowRunJobsPage = WorkflowRunJobsPage(values: [
          WorkflowRunJob(conclusion: GithubActionConclusion.skipped)
        ]);

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: workflowRunJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = adapter.fetchBuildsAfter(jobName, lastBuild);

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using pagination for workflow runs",
      () {
        final firstPage = WorkflowRunsPage(
          page: 1,
          nextPageUrl: testData.url,
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3],
          ),
        );
        final secondPage = WorkflowRunsPage(
          page: 2,
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [2, 1],
          ),
        );

        final firstBuild = testData.generateBuildData(buildNumber: 1);
        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(firstPage);

        when(githubActionsClientMock.fetchWorkflowRunsNext(firstPage))
            .thenSuccessWith(secondPage);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using the pagination for run artifacts",
      () {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: emptyArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final result = adapter.fetchBuildsAfter(jobName, lastBuild);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using pagination for run jobs",
      () {
        final runsPage = WorkflowRunsPage(
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: emptyWorkflowRunJobsPage,
        ).thenSuccessWith(runsPage);

        when(githubActionsClientMock.fetchRunJobsNext(emptyWorkflowRunJobsPage))
            .thenSuccessWith(defaultJobsPage);

        final result = adapter.fetchBuildsAfter(jobName, lastBuild);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if fetching a workflow runs page fails",
      () {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchWorkflowRuns(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through workflow runs fails",
      () {
        final firstPage = WorkflowRunsPage(
          nextPageUrl: testData.url,
          values: testData.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3],
          ),
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(firstPage);

        when(githubActionsClientMock.fetchWorkflowRunsNext(firstPage))
            .thenErrorWith();

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if fetching the coverage artifact fails",
      () {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunArtifacts(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through run artifacts fails",
      () {
        whenFetchWorkflowRuns(
          withJobsPage: defaultJobsPage,
          withArtifactsPage: emptyArtifactsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenErrorWith();

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if fetching the run job fails",
      () {
        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunJobs(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through run jobs fails",
      () {
        whenFetchWorkflowRuns(
          withJobsPage: emptyWorkflowRunJobsPage,
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunJobsNext(emptyWorkflowRunJobsPage))
            .thenErrorWith();

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if downloading an artifact archive fails",
      () {
        whenFetchWorkflowRuns(
          withJobsPage: defaultJobsPage,
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.downloadRunArtifactZip(any))
            .thenErrorWith();

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds statuses according to specification",
      () {
        const conclusions = [
          GithubActionConclusion.success,
          GithubActionConclusion.failure,
          GithubActionConclusion.timedOut,
          GithubActionConclusion.cancelled,
          GithubActionConclusion.neutral,
          GithubActionConclusion.actionRequired,
          null,
        ];

        const expectedStatuses = [
          BuildStatus.successful,
          BuildStatus.failed,
          BuildStatus.failed,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
        ];

        final expectedBuilds = testData.generateBuildDataByStatuses(
          statuses: expectedStatuses,
        );

        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: [1, 2, 3, 4, 5, 6, 7],
        );
        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        final workflowRunJobs = testData.generateWorkflowRunJobsByConclusions(
            conclusions: conclusions);

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);

        for (int i = 0; i < workflowRuns.length; ++i) {
          final run = workflowRuns[i];

          when(githubActionsClientMock.fetchRunJobs(
            run.id,
            status: anyNamed('status'),
            page: anyNamed('page'),
            perPage: anyNamed('perPage'),
          )).thenSuccessWith(
            WorkflowRunJobsPage(values: [workflowRunJobs[i]]),
          );
        }

        final firstBuild = testData.generateBuildData(buildNumber: 0);

        final result = adapter.fetchBuildsAfter(jobName, firstBuild);

        expect(result, completion(equals(expectedBuilds)));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched run jobs' startedAt date to the completedAt date if the startedAt date is null",
      () async {
        final completedAt = DateTime.now();
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        final workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: null,
          completedAt: completedAt,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = await adapter.fetchBuildsAfter(
          jobName,
          firstBuild,
        );
        final startedAt = result.first.startedAt;

        expect(startedAt, equals(completedAt));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched run jobs' startedAt date to the DateTime.now() date if the startedAt and completedAt dates are null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        const workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: null,
          completedAt: null,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          const WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = await adapter.fetchBuildsAfter(
          jobName,
          firstBuild,
        );
        final startedAt = result.first.startedAt;

        expect(startedAt, isNotNull);
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched run jobs' duration to the Duration.zero if the startedAt date is null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        final workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: null,
          completedAt: DateTime.now(),
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = await adapter.fetchBuildsAfter(
          jobName,
          firstBuild,
        );
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched run jobs' duration to the Duration.zero if the completedAt date is null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        final workflowRunJob = WorkflowRunJob(
          name: jobName,
          startedAt: DateTime.now(),
          completedAt: null,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = await adapter.fetchBuildsAfter(
          jobName,
          firstBuild,
        );
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched run jobs' url to the empty string if the url is null",
      () async {
        const workflowRun = WorkflowRun(number: 2);
        const workflowRunsPage = WorkflowRunsPage(values: [workflowRun]);
        const workflowRunJob = WorkflowRunJob(
          name: jobName,
          url: null,
        );

        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(workflowRunsPage);
        when(githubActionsClientMock.fetchRunJobs(
          any,
          status: anyNamed('status'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenSuccessWith(
          const WorkflowRunJobsPage(values: [workflowRunJob]),
        );

        final firstBuild = testData.generateBuildData(buildNumber: 1);

        final result = await adapter.fetchBuildsAfter(
          jobName,
          firstBuild,
        );
        final url = result.first.url;

        expect(url, equals(''));
      },
    );

    test(
      ".dispose() closes the Github Actions client",
      () {
        adapter.dispose();

        verify(githubActionsClientMock.close()).called(1);
      },
    );
  });
}

class _GithubActionsClientMock extends Mock implements GithubActionsClient {}

class _ArchiveHelperMock extends Mock implements ArchiveHelper {}

class _ArchiveMock extends Mock implements Archive {}
