// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/sync_stage/builds/in_progress_builds_sync_stage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../cli/test_util/mock/integration_client_mock.dart';
import '../../../../cli/test_util/test_data/config_test_data.dart';

void main() {
  group("InProgressBuildsSyncStage", () {
    final sourceClient = SourceClientMock();
    final destinationClient = DestinationClientMock();
    final syncConfig = ConfigTestData.syncConfig;

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
      ".call() returns a success",
      () async {
        final result = await syncStage.call(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );
  });
}
