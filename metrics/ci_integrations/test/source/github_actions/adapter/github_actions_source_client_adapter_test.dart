import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_duration.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_client_adapter.dart';
import 'package:ci_integration/util/archive/archive_util.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../util/archive/zip_decoder_mock.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceClientAdapter", () {
    const repositoryOwner = 'owner';
    const repositoryName = 'name';
    final authorization = BearerAuthorization('token');

    final client = GithubActionsClient(
      repositoryOwner: repositoryOwner,
      repositoryName: repositoryName,
      authorization: authorization,
    );

    const defaultId = 1;
    const defaultWorkflowIdentifier = 'test';
    final defaultCoverage = Percent(0.6);
    const defaultDuration = Duration(milliseconds: 5000);
    const defaultUrl = 'buildUrl';
    final defaultDateTime = DateTime(2020);

    const defaultArtifactName = 'coverage-summary.json';
    final defaultArtifact = WorkflowRunArtifact(
      name: defaultArtifactName,
      downloadUrl: defaultUrl,
    );
    final defaultRunArtifactPage = WorkflowRunArtifactsPage(
      values: [defaultArtifact],
    );
    final emptyArtifactsPage = WorkflowRunArtifactsPage(
      page: 1,
      nextPageUrl: defaultUrl,
      values: const [],
    );

    final zipDecoderMock = ZipDecoderMock();
    final archiveUtil = ArchiveUtil(zipDecoderMock);

    final githubActionsClientMock = _GithubActionsClientMock();
    final responses = _GithubActionsClientResponse(defaultWorkflowIdentifier);
    final adapter = GithubActionsSourceClientAdapter(
      githubActionsClient: githubActionsClientMock,
      archiveUtil: archiveUtil,
    );

    final coverageJson = <String, dynamic>{
      'total': {
        'branches': {
          'pct': 60,
        },
      },
    };
    final defaultArchive = Archive();
    final archiveFile = ArchiveFile(
      'coverage-summary.json',
      1,
      utf8.encode(jsonEncode(coverageJson)),
    );
    defaultArchive.files = [archiveFile];

    PostExpectation<Future<InteractionResult>> whenDownloadRunArtifactZip() {
      return when(
        githubActionsClientMock.downloadRunArtifactZip(any),
      );
    }

    PostExpectation<Future<InteractionResult>> whenFetchRunArtifacts() {
      return when(
        githubActionsClientMock.fetchRunArtifacts(
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      );
    }

    PostExpectation<Future<InteractionResult>> whenFetchRunDuration() {
      return when(
        githubActionsClientMock.fetchRunDuration(
          any,
        ),
      );
    }

    PostExpectation<FutureOr<InteractionResult>> whenFetchNextRunsPage() {
      return when(
        githubActionsClientMock.fetchNextRunsPage(
          any,
        ),
      );
    }

    PostExpectation<FutureOr<InteractionResult>>
        whenFetchNextRunArtifactsPage() {
      return when(
        githubActionsClientMock.fetchNextRunArtifactsPage(
          any,
        ),
      );
    }

    PostExpectation<Archive> whenDecodeArchive() {
      return when(
        zipDecoderMock.decodeBytes(any),
      );
    }

    PostExpectation<Future<InteractionResult>> whenFetchRuns({
      String workflowIdentifier = defaultWorkflowIdentifier,
    }) {
      whenFetchRunArtifacts().thenAnswer((_) => responses.fetchRunArtifacts());
      whenFetchRunDuration().thenAnswer((_) => responses.fetchRunDuration());
      whenDownloadRunArtifactZip().thenAnswer(
        (_) => responses.downloadRunArtifactZip(),
      );
      whenFetchNextRunsPage().thenAnswer(
        (invocation) => responses.fetchNextRunsPage(
          invocation.positionalArguments.first as WorkflowRunsPage,
        ),
      );
      whenFetchNextRunArtifactsPage().thenAnswer(
        (invocation) => responses.fetchNextRunArtifactsPage(
          invocation.positionalArguments.first as WorkflowRunArtifactsPage,
        ),
      );
      whenDecodeArchive().thenReturn(defaultArchive);

      return when(
        githubActionsClientMock.fetchWorkflowRuns(
          workflowIdentifier,
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
        startedAt: defaultDateTime,
        buildStatus: buildStatus,
        duration: defaultDuration,
        workflowName: defaultWorkflowIdentifier,
        url: defaultUrl,
        coverage: defaultCoverage,
      );
    }

    /// Creates a list of [BuildData]s using the given [buildNumbers].
    List<BuildData> createBuildDatas({
      @required List<int> buildNumbers,
    }) {
      return buildNumbers.map((buildNumber) {
        return createBuildData(buildNumber: buildNumber);
      }).toList();
    }

    /// Creates a [WorkflowRun] instance with the given [buildNumber]
    /// and default [status] and [conclusion] arguments.
    WorkflowRun createWorkflowRun({
      @required int runNumber,
      RunStatus status = RunStatus.completed,
      RunConclusion conclusion = RunConclusion.success,
    }) {
      return WorkflowRun(
        id: defaultId,
        number: runNumber,
        url: defaultUrl,
        status: status,
        conclusion: conclusion,
        createdAt: defaultDateTime,
      );
    }

    /// Creates a list of [WorkflowRun]s using the given [runNumbers].
    List<WorkflowRun> createWorkflowRuns({
      @required List<int> runNumbers,
    }) {
      return runNumbers.map((runNumber) {
        return createWorkflowRun(runNumber: runNumber);
      }).toList();
    }

    setUp(() {
      reset(githubActionsClientMock);
      reset(zipDecoderMock);
      responses.reset();
    });

    test(
      "throws an ArgumentError if the given Github Actions client is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: null,
            archiveUtil: archiveUtil,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given archive util is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: client,
            archiveUtil: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final adapter = GithubActionsSourceClientAdapter(
          githubActionsClient: client,
          archiveUtil: archiveUtil,
        );

        expect(adapter.githubActionsClient, equals(client));
        expect(adapter.archiveUtil, equals(archiveUtil));
      },
    );

    test(
      ".fetchBuilds() fetches builds",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRuns(runNumbers: [1, 2]),
        );
        responses.addRunsPages([runsPage]);

        responses.addRunArtifactsPages([defaultRunArtifactPage]);

        final expected = createBuildDatas(buildNumbers: [1, 2]);

        whenFetchRuns().thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuilds(defaultWorkflowIdentifier);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuilds() fetches coverage for each build",
      () async {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRuns(runNumbers: [1, 2]),
        );
        responses.addRunsPages([runsPage]);

        responses.addRunArtifactsPages([defaultRunArtifactPage]);

        final expected = [defaultCoverage, defaultCoverage];

        whenFetchRuns().thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = await adapter.fetchBuilds(defaultWorkflowIdentifier);
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expected));
      },
    );

    test(
      ".fetchBuilds() fetches coverage for each build if the coverage artifact is in next run artifacts pages",
      () async {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRuns(runNumbers: [1, 2]),
        );
        responses.addRunsPages([runsPage]);

        responses.addRunArtifactsPages([
          emptyArtifactsPage,
          defaultRunArtifactPage,
        ]);

        final expected = [defaultCoverage, defaultCoverage];

        whenFetchRuns().thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = await adapter.fetchBuilds(defaultWorkflowIdentifier);
        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expected));
      },
    );

    test(
      ".fetchBuildsAfter() fetches all builds after the given one",
      () {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRuns(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);

        responses.addRunArtifactsPages([defaultRunArtifactPage]);

        final firstBuild = createBuildData(buildNumber: 1);
        final expected = createBuildDatas(buildNumbers: [4, 3, 2]);

        whenFetchRuns().thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          firstBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build",
      () async {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRuns(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);

        responses.addRunArtifactsPages([defaultRunArtifactPage]);

        final firstBuild = createBuildData(buildNumber: 1);

        final expected = [defaultCoverage, defaultCoverage, defaultCoverage];

        whenFetchRuns().thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = await adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          firstBuild,
        );

        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expected));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build if the coverage artifact is in next run artifacts pages",
      () async {
        final runsPage = WorkflowRunsPage(
          values: createWorkflowRuns(runNumbers: [4, 3, 2, 1]),
        );
        responses.addRunsPages([runsPage]);

        responses
            .addRunArtifactsPages([emptyArtifactsPage, defaultRunArtifactPage]);

        final firstBuild = createBuildData(buildNumber: 1);

        final expected = [defaultCoverage, defaultCoverage, defaultCoverage];

        whenFetchRuns().thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = await adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          firstBuild,
        );

        final actualCoverage =
            result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expected));
      },
    );

    test(
      ".fetchBuildsAfter() fetches all builds using all workflow run pages",
      () {
        final firstPage = WorkflowRunsPage(
          page: 1,
          nextPageUrl: defaultUrl,
          values: createWorkflowRuns(runNumbers: [6, 5]),
        );

        final secondPage = WorkflowRunsPage(
          page: 2,
          nextPageUrl: defaultUrl,
          values: createWorkflowRuns(runNumbers: [4, 3]),
        );

        final thirdPage = WorkflowRunsPage(
          page: 2,
          nextPageUrl: null,
          values: createWorkflowRuns(runNumbers: [2, 1]),
        );

        responses.addRunsPages([firstPage, secondPage, thirdPage]);

        responses.addRunArtifactsPages([defaultRunArtifactPage]);

        final firstBuild = createBuildData(buildNumber: 1);
        final expected = createBuildDatas(buildNumbers: [6, 5, 4, 3, 2]);

        whenFetchRuns().thenAnswer((_) => responses.fetchWorkflowRuns());

        final result = adapter.fetchBuildsAfter(
          defaultWorkflowIdentifier,
          firstBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );
  });
}

class _GithubActionsClientMock extends Mock implements GithubActionsClient {}

/// A class that provides methods for building [_GithubActionsClientMock]
/// responses.
class _GithubActionsClientResponse {
  /// A workflow identifier to use in responses.
  final String workflowIdentifier;

  /// A list of [WorkflowRunsPage]s to use in responses.
  final List<WorkflowRunsPage> _runsPages = [];

  /// A list of [WorkflowRunArtifactsPage]s to use in responses.
  final List<WorkflowRunArtifactsPage> _runArtifactsPages = [];

  /// Creates a new instance of the [_GithubActionsClientResponse].
  _GithubActionsClientResponse(this.workflowIdentifier);

  /// Adds the given [runsPages] to the [_runsPages].
  void addRunsPages(Iterable<WorkflowRunsPage> runsPages) {
    _runsPages.addAll(runsPages);
  }

  /// Adds the given [_runArtifactsPages] to the [_runArtifactsPages].
  void addRunArtifactsPages(
    Iterable<WorkflowRunArtifactsPage> runArtifactsPages,
  ) {
    _runArtifactsPages.addAll(runArtifactsPages);
  }

  /// Builds the response for the [GithubActionsClient.fetchWorkflowRuns] method.
  Future<InteractionResult<WorkflowRunsPage>> fetchWorkflowRuns() {
    final result = _runsPages.first;

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchRunArtifacts] method.
  Future<InteractionResult<WorkflowRunArtifactsPage>> fetchRunArtifacts() {
    final result = _runArtifactsPages.first;

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchNextRunsPage] method.
  Future<InteractionResult<WorkflowRunsPage>> fetchNextRunsPage(
    WorkflowRunsPage currentPage,
  ) {
    final pageNumber = currentPage.page;

    final result = _runsPages[pageNumber];

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchNextRunArtifactsPage]
  /// method.
  Future<InteractionResult<WorkflowRunArtifactsPage>> fetchNextRunArtifactsPage(
    WorkflowRunArtifactsPage currentPage,
  ) {
    final pageNumber = currentPage.page;

    final result = _runArtifactsPages[pageNumber];

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.fetchRunDuration] method.
  Future<InteractionResult<WorkflowRunDuration>> fetchRunDuration() {
    final result = WorkflowRunDuration(duration: Duration(milliseconds: 5000));

    return _wrapFuture(InteractionResult.success(result: result));
  }

  /// Builds the response for the [GithubActionsClient.downloadRunArtifactZip]
  /// method.
  Future<InteractionResult<Uint8List>> downloadRunArtifactZip() {
    final result = Uint8List.fromList([]);

    return _wrapFuture(InteractionResult.success(result: result));
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
  }
}
