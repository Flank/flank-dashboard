import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_builds_page.dart';
import 'package:ci_integration/source/buildkite/adapter/buildkite_source_client_adapter.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/buildkite_test_data_generator.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildkiteSourceClientAdapter", () {
    final testData = BuildkiteTestDataGenerator(
      pipelineSlug: 'testSlug',
      coverage: Percent(0.5),
      webUrl: 'url',
      blocked: false,
      startedAt: DateTime(2020),
      finishedAt: DateTime(2021),
      duration: DateTime(2021).difference(DateTime(2020)),
    );

    final buildkiteClientMock = _BuildkiteClientMock();
    final adapter = BuildkiteSourceClientAdapter(
      buildkiteClient: buildkiteClientMock,
    );

    const coverageJson = <String, dynamic>{'pct': 0.5};
    final coverageBytes = utf8.encode(jsonEncode(coverageJson)) as Uint8List;

    PostExpectation<Future<InteractionResult<BuildkiteBuildsPage>>>
    whenFetchBuildkiteBuilds({
      BuildkiteArtifactsPage withArtifactsPage,
    }) {
      when(
        buildkiteClientMock.downloadArtifact(any),
      ).thenSuccessWith(coverageBytes);

      when(buildkiteClientMock.fetchArtifacts(
        any,
        any,
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      )).thenSuccessWith(withArtifactsPage);

      return when(
        buildkiteClientMock.fetchBuilds(
          any,
          state: anyNamed('state'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      );
    }

    final emptyArtifactsPage = BuildkiteArtifactsPage(
      page: 1,
      nextPageUrl: testData.webUrl,
      values: const [],
    );
    final defaultBuildsPage = BuildkiteBuildsPage(
      values: testData.generateBuildkiteBuildsByNumbers(
        buildNumbers: [2, 1],
      ),
    );
    const defaultArtifactsPage = BuildkiteArtifactsPage(values: [
      BuildkiteArtifact(filename: "coverage-summary.json"),
    ]);
    final defaultBuildData = testData.generateBuildDataByNumbers(
      buildNumbers: [2, 1],
    );

    setUp(() {
      reset(buildkiteClientMock);
    });

    test("throws an ArgumentError if the given Buildkite client is null", () {
      expect(
            () => BuildkiteSourceClientAdapter(
          buildkiteClient: null,
        ),
        throwsArgumentError,
      );
    });

    test("creates an instance with the given parameters", () {
      final adapter = BuildkiteSourceClientAdapter(
        buildkiteClient: buildkiteClientMock,
      );

      expect(adapter.buildkiteClient, equals(buildkiteClientMock));
    });

    test(".fetchBuilds() fetches builds", () {
      whenFetchBuildkiteBuilds(
        withArtifactsPage: defaultArtifactsPage,
      ).thenSuccessWith(defaultBuildsPage);

      final result = adapter.fetchBuilds(testData.pipelineSlug);

      expect(result, completion(equals(defaultBuildData)));
    });

    test(".fetchBuilds() fetches coverage for each build", () async {
      final expectedCoverage = [
        testData.coverage,
        testData.coverage,
      ];

      whenFetchBuildkiteBuilds(
        withArtifactsPage: defaultArtifactsPage,
      ).thenSuccessWith(defaultBuildsPage);

      final result = await adapter.fetchBuilds(testData.pipelineSlug);

      final actualCoverage =
      result.map((buildData) => buildData.coverage).toList();

      expect(actualCoverage, equals(expectedCoverage));
    });

    test(
      ".fetchBuilds() maps the coverage value to null if an artifact with the specified name does not exist",
          () async {
        final expectedCoverage = [null, null];

        const artifactsPage = BuildkiteArtifactsPage(
          values: [BuildkiteArtifact(filename: 'test.json')],
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: artifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final actualCoverage =
        result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() maps the coverage value to null if an artifact bytes is null",
          () async {
        final expectedCoverage = [null, null];

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.downloadArtifact(any)).thenSuccessWith(null);

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final actualCoverage =
        result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() maps the coverage value to null if the JSON content parsing is failed",
          () async {
        const incorrectJson = "{pct : 100}";
        final expectedCoverage = [null, null];

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.downloadArtifact(any)).thenSuccessWith(
          utf8.encode(incorrectJson) as Uint8List,
        );

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final actualCoverage =
        result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() returns no more than the BuildkiteSourceClientAdapter.fetchLimit builds",
          () {
        final builds = testData.generateBuildkiteBuildsByNumbers(
          buildNumbers: List.generate(30, (index) => index),
        );

        final buildsPage = BuildkiteBuildsPage(values: builds);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        final result = adapter.fetchBuilds(testData.pipelineSlug);

        expect(
          result,
          completion(hasLength(BuildkiteSourceClientAdapter.fetchLimit)),
        );
      },
    );

    test(".fetchBuilds() skips blocked builds", () {
      final build = testData.generateBuildkiteBuild(blocked: true);

      final buildsPage = BuildkiteBuildsPage(
        values: [build],
      );

      whenFetchBuildkiteBuilds(
        withArtifactsPage: defaultArtifactsPage,
      ).thenSuccessWith(buildsPage);

      final result = adapter.fetchBuilds(testData.pipelineSlug);

      expect(result, completion(isEmpty));
    });

    test(
      ".fetchBuilds() fetches builds using pagination for build artifacts",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: emptyArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.fetchArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final result = adapter.fetchBuilds(testData.pipelineSlug);

        expect(result, completion(equals(defaultBuildData)));
      },
    );

    test(
      ".fetchBuilds() fetches coverage for each build using pagination for build artifacts",
          () async {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: emptyArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.fetchArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final expectedCoverage = [
          testData.coverage,
          testData.coverage,
        ];

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final actualCoverage =
        result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuilds() throws a StateError if fetching a builds page fails",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenErrorWith();

        final result = adapter.fetchBuilds(testData.pipelineSlug);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if fetching the coverage artifact fails",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.fetchArtifacts(
          any,
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final result = adapter.fetchBuilds(testData.pipelineSlug);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if paginating through coverage artifacts fails",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: emptyArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.fetchArtifactsNext(emptyArtifactsPage))
            .thenErrorWith();

        final result = adapter.fetchBuilds(testData.pipelineSlug);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() throws a StateError if downloading a coverage artifact fails",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.downloadArtifact(any)).thenErrorWith();

        final result = adapter.fetchBuilds(testData.pipelineSlug);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() maps fetched builds states according to the specification",
          () {
        const states = [
          BuildkiteBuildState.passed,
          BuildkiteBuildState.failed,
          BuildkiteBuildState.canceled,
          BuildkiteBuildState.notRun,
          BuildkiteBuildState.scheduled,
          BuildkiteBuildState.blocked,
          BuildkiteBuildState.notRun,
          BuildkiteBuildState.finished,
          BuildkiteBuildState.running,
          BuildkiteBuildState.skipped,
          null,
        ];

        const expectedStates = [
          BuildStatus.successful,
          BuildStatus.failed,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
        ];

        final expectedBuilds = testData.generateBuildDataByStates(
          states: expectedStates,
        );

        final builds = testData.generateBuildkiteBuildsByStates(
          states: states,
        );

        whenFetchBuildkiteBuilds(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(BuildkiteBuildsPage(values: builds));

        final result = adapter.fetchBuilds(testData.pipelineSlug);

        expect(result, completion(equals(expectedBuilds)));
      },
    );

    test(
      ".fetchBuilds() maps fetched builds' difference between the startedAt and finishedAt dates to the duration",
          () async {
        final build = testData.generateBuildkiteBuild();
        final start = build.startedAt;
        final finish = build.finishedAt;
        final expectedDuration = finish.difference(start);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final duration = result.first.duration;

        expect(duration, equals(expectedDuration));
      },
    );

    test(
      ".fetchBuilds() maps fetched builds' difference between the startedAt and finishedAt dates to the Duration.zero if the startedAt date is null",
          () async {
        final build = BuildkiteBuild(
          blocked: false,
          startedAt: null,
          finishedAt: DateTime.now(),
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuilds() maps fetched builds' difference between the startedAt and finishedAt dates to the Duration.zero if the finishedAt date is null",
          () async {
        final build = BuildkiteBuild(
          blocked: false,
          startedAt: DateTime.now(),
          finishedAt: null,
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuilds() maps fetched builds' url to the empty string if the url is null",
          () async {
        const build = BuildkiteBuild(
          blocked: false,
          webUrl: null,
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(const BuildkiteBuildsPage(values: [build]));

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final url = result.first.url;

        expect(url, equals(''));
      },
    );

    test(
      ".fetchBuilds() maps fetched builds' startedAt date to the finishedAt date if the startedAt date is null",
          () async {
        final finishedAt = DateTime.now();
        final build = BuildkiteBuild(
          blocked: false,
          startedAt: null,
          finishedAt: finishedAt,
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final result = await adapter.fetchBuilds(testData.pipelineSlug);
        final startedAt = result.first.startedAt;

        expect(startedAt, equals(finishedAt));
      },
    );

    test(
      ".fetchBuildsAfter() throws ArgumentError if the build is null",
          () {
        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          null,
        );

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".fetchBuildsAfter() fetches all builds after the given one",
          () {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds with a greater build number than the given if the given number is not found",
          () {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [7, 6, 5, 3, 2, 1],
          ),
        );

        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [7, 6, 5],
        );

        final lastBuild = testData.generateBuildData(buildNumber: 4);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() returns an empty list if there are no new builds",
          () {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3, 2, 1],
          ),
        );

        final lastBuild = testData.generateBuildData(buildNumber: 4);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build",
          () async {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3, 2, 1],
          ),
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final expected = [
          testData.coverage,
          testData.coverage,
          testData.coverage,
        ];

        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );
        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expected));
      },
    );

    test(
      ".fetchBuildsAfter() maps the coverage value to null if an artifact is not the coverage summary json",
          () async {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3, 2, 1],
          ),
        );
        const artifactsPage = BuildkiteArtifactsPage(
          values: [BuildkiteArtifact(filename: "test.json")],
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: artifactsPage,
        ).thenSuccessWith(buildsPage);

        final expectedCoverage = [null, null, null];

        final lastBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );
        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() maps the coverage value to null if an artifact bytes is null",
          () async {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [3, 2, 1],
          ),
        );
        final expectedCoverage = [null, null];

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        when(buildkiteClientMock.downloadArtifact(any)).thenSuccessWith(null);

        final lastBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );
        final actualCoverage =
        result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() maps the coverage value to null if the JSON content parsing is failed",
          () async {
        const incorrectJson = "{pct : 100}";
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [3, 2, 1],
          ),
        );
        final expectedCoverage = [null, null];

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        when(buildkiteClientMock.downloadArtifact(any)).thenSuccessWith(
          utf8.encode(incorrectJson) as Uint8List,
        );

        final lastBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );
        final actualCoverage =
        result.map((buildData) => buildData.coverage).toList();

        expect(actualCoverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() fetches coverage for each build using pagination for build artifacts",
          () async {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3, 2, 1],
          ),
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: emptyArtifactsPage,
        ).thenSuccessWith(buildsPage);

        when(buildkiteClientMock.fetchArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final expectedCoverage = [
          testData.coverage,
          testData.coverage,
          testData.coverage,
        ];

        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );
        final coverage = result.map((build) => build.coverage).toList();

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".fetchBuildsAfter() skips the blocked builds",
          () {
        final build = testData.generateBuildkiteBuild(number: 2, blocked: true);
        final buildsPage = BuildkiteBuildsPage(values: [build]);
        final lastBuild = testData.generateBuildData(buildNumber: 1);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(buildsPage);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using pagination for buildkite builds",
          () {
        final firstPage = BuildkiteBuildsPage(
          page: 1,
          nextPageUrl: testData.webUrl,
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3],
          ),
        );
        final secondPage = BuildkiteBuildsPage(
          page: 2,
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [2, 1],
          ),
        );

        final firstBuild = testData.generateBuildData(buildNumber: 1);
        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(firstPage);

        when(buildkiteClientMock.fetchBuildsNext(firstPage))
            .thenSuccessWith(secondPage);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          firstBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() fetches builds using the pagination for buildkite artifacts",
          () {
        final buildsPage = BuildkiteBuildsPage(
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3, 2, 1],
          ),
        );

        final expected = testData.generateBuildDataByNumbers(
          buildNumbers: [4, 3, 2],
        );

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: emptyArtifactsPage,
        ).thenSuccessWith(buildsPage);

        when(buildkiteClientMock.fetchArtifactsNext(emptyArtifactsPage))
            .thenSuccessWith(defaultArtifactsPage);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if fetching a builds page fails",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.fetchBuilds(
          any,
          state: anyNamed('state'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final lastBuild = testData.generateBuildData(buildNumber: 1);
        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through Buildkite builds fails",
          () {
        final firstPage = BuildkiteBuildsPage(
          nextPageUrl: testData.webUrl,
          values: testData.generateBuildkiteBuildsByNumbers(
            buildNumbers: [4, 3],
          ),
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(firstPage);

        when(buildkiteClientMock.fetchBuildsNext(firstPage)).thenErrorWith();

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if fetching the coverage artifact fails",
          () {
        whenFetchBuildkiteBuilds().thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.fetchArtifacts(
          any,
          any,
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        )).thenErrorWith();

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if paginating through builds artifacts fails",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: emptyArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.fetchArtifactsNext(emptyArtifactsPage))
            .thenErrorWith();

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() throws a StateError if downloading an artifact fails",
          () {
        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(defaultBuildsPage);

        when(buildkiteClientMock.downloadArtifact(any)).thenErrorWith();

        final lastBuild = testData.generateBuildData(buildNumber: 1);

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds states according to the specification",
          () {
        const states = [
          BuildkiteBuildState.passed,
          BuildkiteBuildState.failed,
          BuildkiteBuildState.canceled,
          BuildkiteBuildState.notRun,
          BuildkiteBuildState.scheduled,
          BuildkiteBuildState.blocked,
          BuildkiteBuildState.notRun,
          BuildkiteBuildState.finished,
          BuildkiteBuildState.running,
          BuildkiteBuildState.skipped,
          null,
        ];

        const expectedStates = [
          BuildStatus.successful,
          BuildStatus.failed,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
          BuildStatus.unknown,
        ];

        final expectedBuilds = testData.generateBuildDataByStates(
          states: expectedStates,
        );

        final builds = testData.generateBuildkiteBuildsByStates(
          states: states,
        );
        final lastBuild = testData.generateBuildData(buildNumber: 0);

        whenFetchBuildkiteBuilds(withArtifactsPage: defaultArtifactsPage)
            .thenSuccessWith(BuildkiteBuildsPage(values: builds));

        final result = adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          lastBuild,
        );

        expect(result, completion(equals(expectedBuilds)));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds' difference between the startedAt and finishedAt dates to the duration",
          () async {
        final build = testData.generateBuildkiteBuild(number: 2);
        final start = build.startedAt;
        final finish = build.finishedAt;
        final expectedDuration = finish.difference(start);

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final firstBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          firstBuild,
        );
        final duration = result.first.duration;

        expect(duration, equals(expectedDuration));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds' difference between the startedAt and finishedAt dates to the Duration.zero if the startedAt date is null",
          () async {
        final build = BuildkiteBuild(
          number: 2,
          blocked: false,
          startedAt: null,
          finishedAt: DateTime.now(),
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final firstBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          firstBuild,
        );
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds' difference between the startedAt and finishedAt dates to the Duration.zero if the finishedAt date is null",
          () async {
        final build = BuildkiteBuild(
          number: 2,
          blocked: false,
          startedAt: DateTime.now(),
          finishedAt: null,
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final firstBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          firstBuild,
        );
        final duration = result.first.duration;

        expect(duration, equals(Duration.zero));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds' url to the empty string if the url is null",
          () async {
        const build = BuildkiteBuild(
          number: 2,
          blocked: false,
          webUrl: null,
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(const BuildkiteBuildsPage(values: [build]));

        final firstBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          firstBuild,
        );
        final url = result.first.url;

        expect(url, equals(''));
      },
    );

    test(
      ".fetchBuildsAfter() maps fetched builds' startedAt date to the finishedAt date if the startedAt date is null",
          () async {
        final finishedAt = DateTime.now();
        final build = BuildkiteBuild(
          number: 2,
          blocked: false,
          startedAt: null,
          finishedAt: finishedAt,
        );

        whenFetchBuildkiteBuilds(
          withArtifactsPage: defaultArtifactsPage,
        ).thenSuccessWith(BuildkiteBuildsPage(values: [build]));

        final firstBuild = testData.generateBuildData(buildNumber: 1);
        final result = await adapter.fetchBuildsAfter(
          testData.pipelineSlug,
          firstBuild,
        );
        final startedAt = result.first.startedAt;

        expect(startedAt, equals(finishedAt));
      },
    );

    test(".dispose() closes the Buildkite client", () {
      adapter.dispose();

      verify(buildkiteClientMock.close()).called(1);
    });
  });
}

class _BuildkiteClientMock extends Mock implements BuildkiteClient {}

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
