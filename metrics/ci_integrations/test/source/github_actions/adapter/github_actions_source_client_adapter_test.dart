import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_adapter.dart';
import 'package:ci_integration/util/archive/archive_helper.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/github_actions_test_data_builder.dart';

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

    PostExpectation<Future<InteractionResult>> whenFetchWorkflowRuns({
      // WorkflowRunsPage withRunsPage,
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
        runNumbers: [1, 2],
      ),
    );
    final defaultJobsPage = WorkflowRunJobsPage(
      values: [testDataGenerator.generateWorkflowRunJob()],
    );
    //final defaultArtifactsPage
    final defaultBuildData =
        testDataGenerator.generateBuildsByNumbers(buildNumbers: [1, 2]);

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

    // test(
    //   ".fetchBuilds() fetches builds",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(result, completion(equals(defaultBuildData)));
    //   },
    // );

    // test(
    //   ".fetchBuilds() fetches coverage for each build",
    //   () async {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final expected = [defaultCoverage, defaultCoverage];

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = await adapter.fetchBuilds(defaultJobName);
    //     final actualCoverage =
    //         result.map((buildData) => buildData.coverage).toList();

    //     expect(actualCoverage, equals(expected));
    //   },
    // );

    // test(
    //   ".fetchBuilds() not more than the GithubActionsSourceClientAdapter.fetchLimit builds",
    //   () {
    //     final workflowRuns = createWorkflowRunsList(
    //       runNumbers: List.generate(30, (index) => index),
    //     );
    //     responses.addRunsPages([WorkflowRunsPage(values: workflowRuns)]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(
    //       result,
    //       completion(hasLength(GithubActionsSourceClientAdapter.fetchLimit)),
    //     );
    //   },
    // );

    // test(
    //   ".fetchBuilds() does not fetch the skipped builds",
    //   () {
    //     final workflowRunJob =
    //         createWorkflowRunJob(conclusion: GithubActionConclusion.skipped);

    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([
    //       WorkflowRunJobsPage(values: [workflowRunJob])
    //     ]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

    //     expect(result, completion(isEmpty));
    //   },
    // );

    // test(
    //   ".fetchBuilds() fetches builds using pagination for workflow run jobs",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(result, completion(equals(defaultBuildData)));
    //   },
    // );

    // test(
    //   ".fetchBuilds() fetches builds using pagination for run artifacts",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages(
    //         [emptyArtifactsPage, defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(result, completion(equals(defaultBuildData)));
    //   },
    // );

    // test(
    //   ".fetchBuilds() throws a StateError if fetching a workflow runs page fails",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     when(githubActionsClientMock.fetchWorkflowRuns(
    //       any,
    //       status: anyNamed('status'),
    //       perPage: anyNamed('perPage'),
    //       page: anyNamed('page'),
    //     )).thenAnswer((_) => responses.error<WorkflowRunsPage>());

    //     final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuilds() throws a StateError if looking for the coverage artifact fails",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     when(githubActionsClientMock.fetchRunArtifacts(
    //       any,
    //       perPage: anyNamed('perPage'),
    //       page: anyNamed('page'),
    //     )).thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuilds() throws a StateError if paginating through coverage artifacts fails",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages(
    //         [emptyArtifactsPage, defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.fetchRunArtifactsNext(any))
    //         .thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuilds() throws a StateError if looking for the workflow run job fails",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     when(githubActionsClientMock.fetchRunJobs(
    //       any,
    //       status: anyNamed('status'),
    //       perPage: anyNamed('perPage'),
    //       page: anyNamed('page'),
    //     )).thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

    //     final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuilds() throws a StateError if paginating through run jobs fails",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.fetchRunJobsNext(any))
    //         .thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

    //     final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuilds() throws a StateError if downloading a coverage artifact archive fails",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.downloadRunArtifactZip(any))
    //         .thenAnswer((_) => responses.error<Uint8List>());

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuilds() maps fetched builds statuses according to specification",
    //   () {
    //     const runConclusions = [
    //       GithubActionConclusion.success,
    //       GithubActionConclusion.failure,
    //       GithubActionConclusion.cancelled,
    //       GithubActionConclusion.neutral,
    //       GithubActionConclusion.actionRequired,
    //       GithubActionConclusion.timedOut,
    //       null,
    //     ];

    //     const expectedStatuses = [
    //       BuildStatus.successful,
    //       BuildStatus.failed,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //     ];

    //     final workflowRuns = <WorkflowRun>[];
    //     final expected = <BuildData>[];

    //     final length = min(runConclusions.length, expectedStatuses.length);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     for (int i = 0; i < length; i++) {
    //       final workflowRun = createWorkflowRun(id: i, runNumber: i + 1);
    //       final workflowRunJob = createWorkflowRunJob(
    //         conclusion: runConclusions[i],
    //       );

    //       final runId = workflowRun.id;
    //       when(githubActionsClientMock.fetchRunJobs(
    //         runId,
    //         status: anyNamed('status'),
    //         perPage: anyNamed('perPage'),
    //         page: anyNamed('page'),
    //       )).thenAnswer((_) => responses.fetchRunJobs(i));

    //       workflowRuns.add(workflowRun);
    //       responses.addRunJobsPages([
    //         WorkflowRunJobsPage(values: [workflowRunJob])
    //       ]);

    //       expected.add(createBuildData(
    //         buildNumber: i + 1,
    //         buildStatus: expectedStatuses[i],
    //       ));
    //     }

    //     responses.addRunsPages([WorkflowRunsPage(values: workflowRuns)]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final result = adapter.fetchBuilds(defaultJobName);

    //     expect(result, completion(equals(expected)));
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() fetches all builds after the given one",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final lastBuild = createBuildData(buildNumber: 1);
    //     final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       lastBuild,
    //     );

    //     expect(result, completion(equals(expected)));
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() returns an empty list if there are no new builds",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final lastBuild = createBuildData(buildNumber: 4);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuildsAfter(
    //       defaultWorkflowIdentifier,
    //       lastBuild,
    //     );

    //     expect(result, completion(isEmpty));
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() fetches coverage for each build",
    //   () async {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final lastBuild = createBuildData(buildNumber: 1);
    //     final expected = [defaultCoverage, defaultCoverage, defaultCoverage];

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = await adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       lastBuild,
    //     );

    //     final coverage = result.map((build) => build.coverage).toList();

    //     expect(coverage, equals(expected));
    //   },
    // );

    // test(
    //   ".fetchBuilds() does not fetch the skipped builds",
    //   () {
    //     final workflowRunJob =
    //         createWorkflowRunJob(conclusion: GithubActionConclusion.skipped);

    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([
    //       WorkflowRunJobsPage(values: [workflowRunJob])
    //     ]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final lastBuild = createBuildData(buildNumber: 1);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuildsAfter(
    //       defaultWorkflowIdentifier,
    //       lastBuild,
    //     );

    //     expect(result, completion(isEmpty));
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() fetches builds using pagination for workflow runs",
    //   () {
    //     final firstPage = WorkflowRunsPage(
    //       page: 1,
    //       nextPageUrl: defaultUrl,
    //       values: createWorkflowRunsList(runNumbers: [4, 3]),
    //     );
    //     final secondPage = WorkflowRunsPage(
    //       page: 2,
    //       values: createWorkflowRunsList(runNumbers: [2, 1]),
    //     );

    //     responses.addRunsPages([firstPage, secondPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final firstBuild = BuildData(buildNumber: 1);
    //     final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       firstBuild,
    //     );

    //     expect(result, completion(equals(expected)));
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() fetches builds using the pagination for run artifacts",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages(
    //         [emptyArtifactsPage, defaultRunArtifactsPage]);

    //     final lastBuild = createBuildData(buildNumber: 1);
    //     final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       lastBuild,
    //     );

    //     expect(result, completion(equals(expected)));
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() fetches builds using pagination for run jobs",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final lastBuild = createBuildData(buildNumber: 1);
    //     final expected = createBuildDataList(buildNumbers: [4, 3, 2]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       lastBuild,
    //     );

    //     expect(result, completion(equals(expected)));
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() throws a StateError if fetching a workflow runs page fails",
    //   () {
    //     responses.addRunsPages([defaultRunsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     when(githubActionsClientMock.fetchWorkflowRuns(
    //       any,
    //       status: anyNamed('status'),
    //       perPage: anyNamed('perPage'),
    //       page: anyNamed('page'),
    //     )).thenAnswer((_) => responses.error<WorkflowRunsPage>());

    //     final firstBuild = createBuildData(buildNumber: 1);
    //     final result = adapter.fetchBuildsAfter(
    //       defaultWorkflowIdentifier,
    //       firstBuild,
    //     );

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() throws a StateError if paginating through workflow runs fails",
    //   () {
    //     final firstRunsPage = WorkflowRunsPage(
    //         nextPageUrl: defaultUrl,
    //         values: createWorkflowRunsList(runNumbers: [4, 3, 2]));
    //     responses.addRunsPages([firstRunsPage, defaultRunsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.fetchWorkflowRunsNext(any))
    //         .thenAnswer((_) => responses.error<WorkflowRunsPage>());

    //     final firstBuild = createBuildData(buildNumber: 1);
    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       firstBuild,
    //     );

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() throws a StateError if looking for the coverage artifact fails",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.fetchRunArtifacts(
    //       any,
    //       perPage: anyNamed('perPage'),
    //       page: anyNamed('page'),
    //     )).thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

    //     final firstBuild = createBuildData(buildNumber: 1);
    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       firstBuild,
    //     );

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() throws a StateError if paginating through run artifacts fails",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunArtifactsPages(
    //         [emptyArtifactsPage, defaultRunArtifactsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.fetchRunArtifactsNext(any))
    //         .thenAnswer((_) => responses.error<WorkflowRunArtifactsPage>());

    //     final firstBuild = createBuildData(buildNumber: 1);
    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       firstBuild,
    //     );

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() throws a StateError if looking for the run job fails",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.fetchRunJobs(
    //       any,
    //       perPage: anyNamed('perPage'),
    //       page: anyNamed('page'),
    //     )).thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

    //     final firstBuild = createBuildData(buildNumber: 1);
    //     final result = adapter.fetchBuildsAfter(
    //       defaultWorkflowIdentifier,
    //       firstBuild,
    //     );

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() throws a StateError if paginating through run jobs fails",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);
    //     responses.addRunJobsPages([emptyWorkflowRunJobsPage, defaultJobsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.fetchRunJobsNext(any))
    //         .thenAnswer((_) => responses.error<WorkflowRunJobsPage>());

    //     final firstBuild = createBuildData(buildNumber: 1);
    //     final result = adapter.fetchBuildsAfter(
    //       defaultWorkflowIdentifier,
    //       firstBuild,
    //     );

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() throws a StateError if downloading an artifact archive fails",
    //   () {
    //     final runsPage = WorkflowRunsPage(
    //       values: createWorkflowRunsList(runNumbers: [4, 3, 2, 1]),
    //     );
    //     responses.addRunsPages([runsPage]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);
    //     responses.addRunJobsPages([defaultJobsPage]);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());
    //     when(githubActionsClientMock.downloadRunArtifactZip(any))
    //         .thenAnswer((_) => responses.error<Uint8List>());

    //     final firstBuild = createBuildData(buildNumber: 1);
    //     final result = adapter.fetchBuildsAfter(
    //       defaultJobName,
    //       firstBuild,
    //     );

    //     expect(result, throwsStateError);
    //   },
    // );

    // test(
    //   ".fetchBuildsAfter() maps fetched builds statuses according to specification",
    //   () {
    //     const runConclusions = [
    //       GithubActionConclusion.success,
    //       GithubActionConclusion.failure,
    //       GithubActionConclusion.cancelled,
    //       GithubActionConclusion.neutral,
    //       GithubActionConclusion.actionRequired,
    //       GithubActionConclusion.timedOut,
    //       null,
    //     ];

    //     const expectedStatuses = [
    //       BuildStatus.successful,
    //       BuildStatus.failed,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //       BuildStatus.unknown,
    //     ];

    //     final workflowRuns = <WorkflowRun>[];
    //     final expected = <BuildData>[];

    //     final length = min(runConclusions.length, expectedStatuses.length);

    //     whenFetchWorkflowRuns()
    //         .thenAnswer((_) => responses.fetchWorkflowRuns());

    //     for (int i = 0; i < length; i++) {
    //       final workflowRun = createWorkflowRun(id: i, runNumber: i + 1);
    //       final workflowRunJob = createWorkflowRunJob(
    //         conclusion: runConclusions[i],
    //       );

    //       final runId = workflowRun.id;
    //       when(githubActionsClientMock.fetchRunJobs(
    //         runId,
    //         status: anyNamed('status'),
    //         perPage: anyNamed('perPage'),
    //         page: anyNamed('page'),
    //       )).thenAnswer((_) => responses.fetchRunJobs(i));

    //       workflowRuns.add(workflowRun);
    //       responses.addRunJobsPages([
    //         WorkflowRunJobsPage(values: [workflowRunJob])
    //       ]);

    //       expected.add(createBuildData(
    //         buildNumber: i + 1,
    //         buildStatus: expectedStatuses[i],
    //       ));
    //     }

    //     responses.addRunsPages([WorkflowRunsPage(values: workflowRuns)]);
    //     responses.addRunArtifactsPages([defaultRunArtifactsPage]);

    //     final firstBuild = BuildData(buildNumber: 0);
    //     final result = adapter.fetchBuildsAfter(defaultJobName, firstBuild);

    //     expect(result, completion(equals(expected)));
    //   },
    // );
  });
}

class _GithubActionsClientMock extends Mock implements GithubActionsClient {}

class _ArchiveHelperMock extends Mock implements ArchiveHelper {}

class _ArchiveMock extends Mock implements Archive {}

extension _InteractionResultAnswer<T>
    on PostExpectation<Future<InteractionResult<T>>> {
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
