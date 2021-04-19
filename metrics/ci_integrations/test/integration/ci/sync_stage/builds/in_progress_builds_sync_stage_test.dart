// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/sync_stage/builds/in_progress_builds_sync_stage.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../cli/test_util/mock/integration_client_mock.dart';
import '../../../../cli/test_util/test_data/config_test_data.dart';
import '../../../../test_utils/matchers.dart';

void main() {
  group("InProgressBuildsSyncStage", () {
    final syncConfig = ConfigTestData.syncConfig;
    final destinationProjectId = syncConfig.destinationProjectId;
    final sourceProjectId = syncConfig.sourceProjectId;
    final exception = Exception();

    final sourceClient = SourceClientMock();
    final destinationClient = DestinationClientMock();
    final syncStage = InProgressBuildsSyncStage(
      sourceClient,
      destinationClient,
    );

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
      ".call() does not update the builds if the fetched in-progress builds are empty",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.value([]));

        await syncStage.call(syncConfig);

        verifyNever(destinationClient.updateBuilds(any, any));
      },
    );

    test(
      ".call() returns an error if an error occurs while fetching in-progress builds",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.error(exception));

        final result = await syncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() does not update builds if an error occurs while fetching in-progress builds",
      () async {
        when(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).thenAnswer((_) => Future.error(exception));

        await syncStage.call(syncConfig);

        verifyNever(destinationClient.updateBuilds(any, any));
      },
    );
  });
}
