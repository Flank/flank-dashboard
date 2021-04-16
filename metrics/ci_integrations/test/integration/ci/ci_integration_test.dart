// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../cli/test_util/test_data/config_test_data.dart';
import '../../test_utils/extensions/interaction_result_answer.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("CiIntegration", () {
    final syncConfig = ConfigTestData.syncConfig;

    final firstSyncStage = _SyncStageMock();
    final secondSyncStage = _SyncStageMock();
    final syncStages = [firstSyncStage, secondSyncStage];
    final ciIntegration = CiIntegration(stages: syncStages);

    tearDown(() {
      reset(firstSyncStage);
      reset(secondSyncStage);
    });

    test(
      "throws an ArgumentError if the given stages is null",
      () {
        expect(() => CiIntegration(stages: null), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given sync stages",
      () {
        final ciIntegration = CiIntegration(stages: syncStages);

        expect(ciIntegration.stages, equals(syncStages));
      },
    );

    test(
      ".sync() throws an ArgumentError if the given config is null",
      () {
        expect(() => ciIntegration.sync(null), throwsArgumentError);
      },
    );

    test(
      ".sync() calls the given sync stages in the right order with the given sync config",
      () async {
        when(firstSyncStage.call(syncConfig)).thenSuccessWith(null);
        when(secondSyncStage.call(syncConfig)).thenSuccessWith(null);

        await ciIntegration.sync(syncConfig);

        verifyInOrder([
          firstSyncStage.call(syncConfig),
          secondSyncStage.call(syncConfig),
        ]);
      },
    );

    test(
      ".sync() does not continue the sync if one of the stages fails",
      () async {
        when(firstSyncStage.call(syncConfig)).thenErrorWith();

        await ciIntegration.sync(syncConfig);

        verifyNever(secondSyncStage.call(any));
      },
    );

    test(
      ".sync() returns an error if one of the stages fails",
      () async {
        when(firstSyncStage.call(syncConfig)).thenErrorWith();

        final result = await ciIntegration.sync(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".sync() returns an error with the message from the failed sync stage",
      () async {
        const expectedMessage = 'test';
        when(
          firstSyncStage.call(syncConfig),
        ).thenErrorWith(null, expectedMessage);

        final result = await ciIntegration.sync(syncConfig);

        expect(result.message, contains(expectedMessage));
      },
    );

    test(
      ".sync() returns a success if all stages pass successfully",
      () async {
        when(firstSyncStage.call(syncConfig)).thenSuccessWith(null);
        when(secondSyncStage.call(syncConfig)).thenSuccessWith(null);

        final result = await ciIntegration.sync(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );
  });
}

class _SyncStageMock extends Mock implements SyncStage {}
