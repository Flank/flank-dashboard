// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/new_builds_sync_stage.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../cli/test_util/mock/integration_client_mock.dart';
import '../../../../test_utils/matchers.dart';

void main() {
  group("NewBuildsSyncStage", () {
    const sourceProjectId = 'sourceId';
    const destinationProjectId = 'destinationId';
    const initialSyncLimit = 28;
    const build = BuildData(buildNumber: 1);
    const anotherBuild = BuildData(buildNumber: 2);
    const builds = [build, anotherBuild];

    final coverage = Percent(0.1);
    final buildWithCoverage = build.copyWith(coverage: coverage);
    final anotherBuildWithCoverage = anotherBuild.copyWith(coverage: coverage);
    final buildsWithCoverage = [buildWithCoverage, anotherBuildWithCoverage];
    final error = Error();

    final sourceClient = SourceClientMock();
    final destinationClient = DestinationClientMock();

    final newBuildsSyncStage = NewBuildsSyncStage(
      sourceClient,
      destinationClient,
    );

    SyncConfig createSyncConfig({bool coverage}) {
      return SyncConfig(
        sourceProjectId: sourceProjectId,
        destinationProjectId: destinationProjectId,
        initialSyncLimit: initialSyncLimit,
        inProgressTimeout: Duration.zero,
        coverage: coverage,
      );
    }

    final syncConfig = createSyncConfig(coverage: false);
    final syncConfigWithCoverage = createSyncConfig(coverage: true);

    PostExpectation<Future<List<BuildData>>> whenFetchBuilds() {
      when(
        destinationClient.fetchLastBuild(destinationProjectId),
      ).thenAnswer((_) => Future.value());

      return when(sourceClient.fetchBuilds(sourceProjectId, initialSyncLimit));
    }

    PostExpectation<Future<List<BuildData>>> whenFetchBuildsAfter() {
      when(
        destinationClient.fetchLastBuild(destinationProjectId),
      ).thenAnswer((_) => Future.value(build));

      return when(sourceClient.fetchBuildsAfter(sourceProjectId, build));
    }

    tearDown(() {
      reset(sourceClient);
      reset(destinationClient);
    });

    test(
      "throws an ArgumentError if the given source client is null",
      () {
        expect(
          () => NewBuildsSyncStage(null, destinationClient),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given destination client is null",
      () {
        expect(
          () => NewBuildsSyncStage(sourceClient, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".call() throws an ArgumentError if the given sync config is null",
      () {
        final result = newBuildsSyncStage.call(null);

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".call() fetches the last build using the destination client and the given destination project id",
      () async {
        final expectedDestinationProjectId = syncConfig.destinationProjectId;

        await newBuildsSyncStage.call(syncConfig);

        verify(
          destinationClient.fetchLastBuild(expectedDestinationProjectId),
        ).called(once);
      },
    );

    test(
      ".call() returns an error if an error occurs while fetching the last build from the destination",
      () async {
        when(
          destinationClient.fetchLastBuild(destinationProjectId),
        ).thenAnswer((_) => Future.error(error));

        final result = await newBuildsSyncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() does not continue the sync if an error occurs while fetching the last build from the destination",
      () async {
        when(
          destinationClient.fetchLastBuild(destinationProjectId),
        ).thenAnswer((_) => Future.error(error));

        await newBuildsSyncStage.call(syncConfig);

        verifyZeroInteractions(sourceClient);
        verifyNever(destinationClient.addBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() fetches the initial sync limit number of builds from the source if the fetched last build is null",
      () async {
        final expectedInitialSyncLimit = syncConfig.initialSyncLimit;
        when(
          destinationClient.fetchLastBuild(destinationProjectId),
        ).thenAnswer((_) => Future.value(null));

        await newBuildsSyncStage.call(syncConfig);

        verify(
          sourceClient.fetchBuilds(sourceProjectId, expectedInitialSyncLimit),
        ).called(once);
      },
    );

    test(
      ".call() does not fetch the builds after from the source if the fetched last build is null",
      () async {
        when(
          destinationClient.fetchLastBuild(destinationProjectId),
        ).thenAnswer((_) => Future.value(null));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchBuildsAfter(sourceProjectId, any));
      },
    );

    test(
      ".call() does not continue the sync if an error occurs while fetching the last builds from the source",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.error(error));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchCoverage(any));
        verifyNever(destinationClient.addBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns an error if an error occurs while fetching the last builds from the source",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.error(error));

        final result = await newBuildsSyncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() does not continue the sync if the fetched last builds are empty",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value([]));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchCoverage(any));
        verifyNever(destinationClient.addBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns a success if the fetched last builds are empty",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value([]));

        final result = await newBuildsSyncStage.call(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".call() does not fetch coverage for the fetched last builds if the coverage option is not enabled in the sync config",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchCoverage(any));
      },
    );

    test(
      ".call() adds fetched last builds to the destination if the coverage option is not enabled",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));

        await newBuildsSyncStage.call(syncConfig);

        verify(destinationClient.addBuilds(destinationProjectId, builds));
      },
    );

    test(
      ".call() fetches coverage for the fetched last builds if the coverage option is enabled",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));

        await newBuildsSyncStage.call(syncConfigWithCoverage);

        verify(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).called(equals(builds.length));
      },
    );

    test(
      ".call() does not continue the sync if an error occurs while fetching the coverage for the fetched last builds",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));
        when(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).thenAnswer((_) => Future.error(error));

        await newBuildsSyncStage.call(syncConfigWithCoverage);

        verifyNever(destinationClient.addBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns an error if an error occurs while fetching the coverage for the fetched last builds",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));
        when(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).thenAnswer((_) => Future.error(error));

        final result = await newBuildsSyncStage.call(syncConfigWithCoverage);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() adds the last builds with the fetched coverage to the destination",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));
        when(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).thenAnswer((_) => Future.value(coverage));

        await newBuildsSyncStage.call(syncConfigWithCoverage);

        verify(
          destinationClient.addBuilds(destinationProjectId, buildsWithCoverage),
        ).called(once);
      },
    );

    test(
      ".call() returns an error if an error occurs while adding the last builds",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));
        when(
          destinationClient.addBuilds(destinationProjectId, builds),
        ).thenAnswer((_) => Future.error(error));

        final result = await newBuildsSyncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() returns a success if adding the last builds succeeds",
      () async {
        whenFetchBuilds().thenAnswer((_) => Future.value(builds));
        when(
          destinationClient.addBuilds(destinationProjectId, builds),
        ).thenAnswer((_) => Future.value());

        final result = await newBuildsSyncStage.call(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".call() fetches the builds after the fetched last build with the given source project id",
      () async {
        final expectedSourceProjectId = syncConfig.sourceProjectId;
        when(
          destinationClient.fetchLastBuild(destinationProjectId),
        ).thenAnswer((_) => Future.value(build));

        await newBuildsSyncStage.call(syncConfig);

        verify(
          sourceClient.fetchBuildsAfter(expectedSourceProjectId, build),
        ).called(once);
      },
    );

    test(
      ".call() does not fetch the last builds if the fetched last build is not null",
      () async {
        when(
          destinationClient.fetchLastBuild(destinationProjectId),
        ).thenAnswer((_) => Future.value(build));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchBuilds(sourceProjectId, any));
      },
    );

    test(
      ".call() does not continue the sync if an error occurs while fetching the builds after the fetched last build",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.error(error));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchCoverage(any));
        verifyNever(destinationClient.addBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns an error if an error occurs while fetching the builds after the fetched last build",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.error(error));

        final result = await newBuildsSyncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() does not continue the sync if the fetched builds after are empty",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value([]));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchCoverage(any));
        verifyNever(destinationClient.addBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns a success if the fetched builds after are empty",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value([]));

        final result = await newBuildsSyncStage.call(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".call() does not fetch the coverage for the fetched builds after if the coverage option is not enabled in the sync config",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value(builds));

        await newBuildsSyncStage.call(syncConfig);

        verifyNever(sourceClient.fetchCoverage(any));
      },
    );

    test(
      ".call() adds the fetched builds after to the destination if the coverage option is not enabled in the sync config",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value(builds));

        await newBuildsSyncStage.call(syncConfig);

        verify(
          destinationClient.addBuilds(destinationProjectId, builds),
        ).called(once);
      },
    );

    test(
      ".call() fetches coverage for the fetched builds after if the coverage option is enabled in the sync config",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value(builds));

        await newBuildsSyncStage.call(syncConfigWithCoverage);

        verify(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).called(equals(builds.length));
      },
    );

    test(
      ".call() does not continue the sync if an error occurs while fetching the coverage for the fetched builds after",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value(builds));
        when(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).thenAnswer((_) => Future.error(error));

        await newBuildsSyncStage.call(syncConfigWithCoverage);

        verifyNever(destinationClient.addBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns an error if an error occurs while fetching the coverage for the fetched builds after",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value(builds));
        when(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).thenAnswer((_) => Future.error(error));

        final result = await newBuildsSyncStage.call(syncConfigWithCoverage);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() adds fetched builds after with the fetched coverage to the destination",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value(builds));
        when(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).thenAnswer((_) => Future.value(coverage));

        await newBuildsSyncStage.call(syncConfigWithCoverage);

        verify(
          destinationClient.addBuilds(destinationProjectId, buildsWithCoverage),
        ).called(once);
      },
    );

    test(
      ".call() returns a success if adding builds with coverage to the destination succeeds",
      () async {
        whenFetchBuildsAfter().thenAnswer((_) => Future.value(builds));
        when(
          sourceClient.fetchCoverage(argThat(anyOf(builds))),
        ).thenAnswer((_) => Future.value(coverage));

        final result = await newBuildsSyncStage.call(syncConfigWithCoverage);

        expect(result.isSuccess, isTrue);
      },
    );
  });
}
