// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/new_builds_sync_stage.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../../cli/test_util/test_data/config_test_data.dart';
import '../../test_utils/stub/destination_client_stub.dart';
import '../../test_utils/stub/source_client_stub.dart';
import '../../test_utils/test_data/builds_test_data.dart';

void main() {
  group("NewBuildsSyncStage", () {
    final sourceClient = SourceClientStub();
    final destinationClient = DestinationClientStub();
    final newBuildsSyncStage = NewBuildsSyncStage(
      sourceClient,
      destinationClient,
    );
    final syncConfig = ConfigTestData.syncConfig;

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
        final result = newBuildsSyncStage(null);

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".call() returns an error if a source client throws fetching all builds",
      () async {
        final sourceClient = SourceClientStub(
          fetchBuildsCallback: (_) => throw UnimplementedError(),
        );
        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => null,
        );
        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );
        final result = await newBuildsSyncStage(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() returns an error if a source client throws fetching the builds after the given one",
      () async {
        final sourceClient = SourceClientStub(
          fetchBuildsAfterCallback: (_, __) => throw UnimplementedError(),
        );
        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );
        final result = await newBuildsSyncStage(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() returns an error if a destination client throws fetching the last build",
      () async {
        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => throw UnimplementedError(),
        );
        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );
        final result = await newBuildsSyncStage(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() returns an error if a destination client throws adding new builds",
      () async {
        final destinationClient = DestinationClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );
        final result = await newBuildsSyncStage(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() ignores empty list of new builds and not call adding builds",
      () async {
        final sourceClient = SourceClientStub(
          fetchBuildsAfterCallback: (_, __) => Future.value([]),
        );
        final destinationClient = DestinationClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );
        final result = await newBuildsSyncStage(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".call() synchronizes builds",
      () async {
        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );
        final result = await newBuildsSyncStage(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".call() does not fetch coverage for builds if the coverage value is false in the given config",
      () async {
        bool isCalled = false;

        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => null,
        );

        final sourceClient = SourceClientStub(
          fetchCoverageCallback: (_) {
            isCalled = true;

            return Future.value(Percent(0.7));
          },
        );

        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );

        final result = await (newBuildsSyncStage(syncConfig) as Future)
            .then((result) => result.isSuccess);

        expect(result, isTrue);
        expect(isCalled, isFalse);
      },
    );

    test(
      ".call() fetches coverage for each build if the coverage value is true in the given config",
      () async {
        final syncConfig = SyncConfig(
          sourceProjectId: 'test',
          destinationProjectId: 'test',
          coverage: true,
          initialSyncLimit: 10,
          inProgressTimeout: const Duration(minutes: 1),
        );

        final expectedCalledTimes = BuildsTestData.builds.length;
        int calledTimes = 0;

        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => null,
        );

        final sourceClient = SourceClientStub(
          fetchCoverageCallback: (_) {
            calledTimes += 1;

            return Future.value(Percent(0.7));
          },
        );

        final newBuildsSyncStage = NewBuildsSyncStage(
          sourceClient,
          destinationClient,
        );

        final result = await (newBuildsSyncStage(syncConfig) as Future)
            .then((result) => result.isSuccess);

        expect(result, isTrue);
        expect(calledTimes, equals(expectedCalledTimes));
      },
    );
  });
}
