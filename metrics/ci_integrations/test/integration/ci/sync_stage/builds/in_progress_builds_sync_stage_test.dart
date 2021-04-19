// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/in_progress_builds_sync_stage.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../cli/test_util/mock/integration_client_mock.dart';
import '../../../../test_utils/matchers.dart';

void main() {
  group("InProgressBuildsSyncStage", () {
    const inProgressTimeout = Duration(hours: 1);
    const sourceProjectId = 'sourceId';
    const destinationProjectId = 'destinationId';
    const initialSyncLimit = 28;

    final startedAt = DateTime(2021);
    final inProgressBuilds = [
      BuildData(
        buildNumber: 1,
        buildStatus: BuildStatus.inProgress,
        startedAt: startedAt,
      ),
      BuildData(
        buildNumber: 2,
        buildStatus: BuildStatus.inProgress,
        startedAt: startedAt,
      ),
    ];
    final error = Error();

    final sourceClient = SourceClientMock();
    final destinationClient = DestinationClientMock();
    final syncStage = InProgressBuildsSyncStage(
      sourceClient,
      destinationClient,
    );

    SyncConfig createSyncConfig({bool coverage}) {
      return SyncConfig(
        sourceProjectId: sourceProjectId,
        destinationProjectId: destinationProjectId,
        initialSyncLimit: initialSyncLimit,
        inProgressTimeout: inProgressTimeout,
        coverage: coverage,
      );
    }

    final syncConfig = createSyncConfig(coverage: false);
    final syncConfigWithCoverage = createSyncConfig(coverage: true);

    tearDown(() {
      reset(sourceClient);
      reset(destinationClient);
    });

    test(
      "throws an ArgumentError if the given source client is null",
      () {
        expect(
          () => InProgressBuildsSyncStage(null, destinationClient),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given destination client is null",
      () {
        expect(
          () => InProgressBuildsSyncStage(sourceClient, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".call() throws an ArgumentError if the given sync config is null",
      () {
        expect(() => syncStage.call(null), throwsArgumentError);
      },
    );

    test(
      ".call() fetches the in-progress builds from the destination",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.value([]));

        await syncStage.call(syncConfig);

        verify(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).called(once);
      },
    );

    test(
      ".call() does not continue the sync if the fetched in-progress builds are empty",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.value([]));

        await syncStage.call(syncConfig);

        verifyNever(sourceClient.fetchOneBuild(sourceProjectId, any));
        verifyNever(sourceClient.fetchCoverage(any));
        verifyNever(destinationClient.updateBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns a success if the fetched in-progress builds are empty",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.value([]));

        final result = await syncStage.call(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".call() does not update builds if an error occurs while fetching in-progress builds",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.error(error));

        await syncStage.call(syncConfig);

        verifyNever(sourceClient.fetchOneBuild(sourceProjectId, any));
        verifyNever(sourceClient.fetchCoverage(any));
        verifyNever(destinationClient.updateBuilds(destinationProjectId, any));
      },
    );

    test(
      ".call() returns an error if an error occurs while fetching in-progress builds",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.error(error));

        final result = await syncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() refreshes the build data of the fetched in-progress builds",
      () async {
        final buildNumbers = inProgressBuilds.map((build) => build.buildNumber);
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.value(inProgressBuilds));
        when(sourceClient.fetchOneBuild(
          sourceProjectId,
          argThat(isIn(buildNumbers)),
        )).thenAnswer((_) => Future.value(const BuildData(buildNumber: 1)));

        await syncStage.call(syncConfig);

        verify(sourceClient.fetchOneBuild(
          sourceProjectId,
          argThat(isIn(buildNumbers)),
        )).called(inProgressBuilds.length);
      },
    );
  });
}
