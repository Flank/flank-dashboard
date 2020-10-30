import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_adapter.dart';
import 'package:ci_integration/util/archive/archive_helper.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/github_actions_test_data_generator.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceClientAdapter", () {
    final testDataGenerator = GithubActionsTestDataGenerator(
      workflowIdentifier: 'workflow',
      jobName: 'job',
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
      workflowIdentifier: testDataGenerator.workflowIdentifier,
      coverageArtifactName: testDataGenerator.coverageArtifactName,
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
      nextPageUrl: testDataGenerator.url,
      values: const [],
    );
    final emptyWorkflowRunJobsPage = WorkflowRunJobsPage(
      page: 1,
      nextPageUrl: testDataGenerator.url,
      values: const [],
    );
    final defaultRunsPage = WorkflowRunsPage(
      values: testDataGenerator.generateWorkflowRunsByNumbers(
        runNumbers: [2, 1],
      ),
    );
    final defaultJobsPage = WorkflowRunJobsPage(
      values: [testDataGenerator.generateWorkflowRunJob()],
    );
    final defaultArtifactsPage = WorkflowRunArtifactsPage(values: [
      WorkflowRunArtifact(name: testDataGenerator.coverageArtifactName),
    ]);
    final defaultBuildData = testDataGenerator.generateBuildDataByNumbers(
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
            workflowIdentifier: testDataGenerator.workflowIdentifier,
            coverageArtifactName: testDataGenerator.coverageArtifactName,
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
            workflowIdentifier: testDataGenerator.workflowIdentifier,
            coverageArtifactName: testDataGenerator.coverageArtifactName,
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
            coverageArtifactName: testDataGenerator.coverageArtifactName,
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
            workflowIdentifier: testDataGenerator.workflowIdentifier,
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
          workflowIdentifier: testDataGenerator.workflowIdentifier,
          coverageArtifactName: testDataGenerator.coverageArtifactName,
        );

        expect(adapter.githubActionsClient, equals(githubActionsClientMock));
        expect(adapter.archiveHelper, equals(archiveHelperMock));
        expect(
          adapter.workflowIdentifier,
          equals(testDataGenerator.workflowIdentifier),
        );
        expect(
          adapter.coverageArtifactName,
          equals(testDataGenerator.coverageArtifactName),
        );
      },
    );

    test(
      ".fetchBuilds() fetches builds",
      () async {
        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

        expect(result, completion(equals(defaultBuildData)));
      },
    );

    test(
      ".fetchBuilds() fetches coverage for each build",
      () async {
        final expectedCoverage = [
          testDataGenerator.coverage,
          testDataGenerator.coverage,
        ];

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = await adapter.fetchBuilds(testDataGenerator.jobName);
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() returns not more than the GithubActionsSourceClientAdapter.fetchLimit builds",
      () {
        final workflowRuns = testDataGenerator.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(workflowRunsPage);

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

        expect(
          result,
          completion(hasLength(GithubActionsSourceClientAdapter.fetchLimit)),
        );
      },
    );

    test(
      ".fetchBuilds() does not fetch the skipped builds",
      () {
        final workflowRunJob = testDataGenerator.generateWorkflowRunJob(
          conclusion: GithubActionConclusion.skipped,
        );

        final workflowRunJobsPage = WorkflowRunJobsPage(
          values: [workflowRunJob],
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: workflowRunJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

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
          testDataGenerator.coverage,
          testDataGenerator.coverage,
        ];

        final result = await adapter.fetchBuilds(testDataGenerator.jobName);
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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if looking for the coverage artifact fails",
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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if looking for the workflow run job fails",
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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() maps fetched builds statuses according to specification",
      () {
        const conclusions = [
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

        final expectedBuilds = testDataGenerator.generateBuildDataByStatuses(
          statuses: expectedStatuses,
        );

        final workflowRuns = testDataGenerator.generateWorkflowRunsByNumbers(
          runNumbers: [1, 2, 3, 4, 5, 6, 7],
        );
        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        final workflowRunJobs = testDataGenerator
            .generateWorkflowRunJobsByConclusions(conclusions: conclusions);

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

        final result = adapter.fetchBuilds(testDataGenerator.jobName);

        expect(result, completion(equals(expectedBuilds)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches all builds after the given one",
      () {
        final runsPage = WorkflowRunsPage(
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testDataGenerator.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() returns an empty list if there are no new builds",
      () {
        final runsPage = WorkflowRunsPage(
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final lastBuild = testDataGenerator.generateBuildData(buildNumber: 4);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          lastBuild,
        );

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build",
      () async {
        final runsPage = WorkflowRunsPage(
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        final lastBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final expected = [
          testDataGenerator.coverage,
          testDataGenerator.coverage,
          testDataGenerator.coverage,
        ];

        final result = await adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          lastBuild,
        );

        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expected));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build using pagination for run artifacts",
      () async {
        final runsPage = WorkflowRunsPage(
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: emptyArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final lastBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final expectedCoverage = [
          testDataGenerator.coverage,
          testDataGenerator.coverage,
          testDataGenerator.coverage,
        ];

        final result = await adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          lastBuild,
        );

        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() does not fetch the skipped builds",
      () {
        final workflowRunJobsPage = WorkflowRunJobsPage(values: const [
          WorkflowRunJob(conclusion: GithubActionConclusion.skipped)
        ]);

        final lastBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: workflowRunJobsPage,
        ).thenSuccessWith(defaultRunsPage);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
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
          nextPageUrl: testDataGenerator.url,
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3],
          ),
        );
        final secondPage = WorkflowRunsPage(
          page: 2,
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [2, 1],
          ),
        );

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);
        final expected = testDataGenerator.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(firstPage);

        when(githubActionsClientMock.fetchWorkflowRunsNext(firstPage))
            .thenSuccessWith(secondPage);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using the pagination for run artifacts",
      () {
        final runsPage = WorkflowRunsPage(
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testDataGenerator.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: emptyArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(runsPage);

        when(githubActionsClientMock.fetchRunArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using pagination for run jobs",
      () {
        final runsPage = WorkflowRunsPage(
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testDataGenerator.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: emptyWorkflowRunJobsPage,
        ).thenSuccessWith(runsPage);

        when(githubActionsClientMock.fetchRunJobsNext(emptyWorkflowRunJobsPage))
            .thenSuccessWith(defaultJobsPage);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          lastBuild,
        );

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

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through workflow runs fails",
      () {
        final firstPage = WorkflowRunsPage(
          nextPageUrl: testDataGenerator.url,
          values: testDataGenerator.generateWorkflowRunsByNumbers(
            runNumbers: [4, 3],
          ),
        );

        whenFetchWorkflowRuns(
          withArtifactsPage: defaultArtifactsPage,
          withJobsPage: defaultJobsPage,
        ).thenSuccessWith(firstPage);

        when(githubActionsClientMock.fetchWorkflowRunsNext(firstPage))
            .thenErrorWith();

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if looking for the coverage artifact fails",
      () {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunArtifacts(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

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

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if looking for the run job fails",
      () {
        whenFetchWorkflowRuns(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(defaultRunsPage);

        when(githubActionsClientMock.fetchRunJobs(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

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

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

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

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds statuses according to specification",
      () {
        const conclusions = [
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

        final expectedBuilds = testDataGenerator.generateBuildDataByStatuses(
          statuses: expectedStatuses,
        );

        final workflowRuns = testDataGenerator.generateWorkflowRunsByNumbers(
          runNumbers: [1, 2, 3, 4, 5, 6, 7],
        );
        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        final workflowRunJobs = testDataGenerator
            .generateWorkflowRunJobsByConclusions(conclusions: conclusions);

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

        final firstBuild = testDataGenerator.generateBuildData(buildNumber: 0);

        final result = adapter.fetchBuildsAfter(
          testDataGenerator.jobName,
          firstBuild,
        );

        expect(result, completion(equals(expectedBuilds)));
      },
    );
  });
}

class _GithubActionsClientMock extends Mock implements GithubActionsClient {}

class _ArchiveHelperMock extends Mock implements ArchiveHelper {}

class _ArchiveMock extends Mock implements Archive {}

extension _InteractionResultAnswer<T>
    on PostExpectation<FutureOr<InteractionResult<T>>> {
  void thenSuccessWith(T result, [String message]) {
    return thenAnswer(
      (_) => Future.value(
        InteractionResult<T>.success(
          message: message,
          result: result,
        ),
      ),
    );
  }

  void thenErrorWith([String message]) {
    return thenAnswer(
      (_) => Future.value(
        InteractionResult<T>.error(
          message: message,
        ),
      ),
    );
  }
}
