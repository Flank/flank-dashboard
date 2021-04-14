// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/builds_sync_stage.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../cli/test_util/mock/integration_client_mock.dart';
import '../../../../test_utils/matchers.dart';

void main() {
  group("BuildsSyncStage", () {
    const firstBuild = BuildData(buildNumber: 1);
    const secondBuild = BuildData(buildNumber: 2);

    final sourceClient = SourceClientMock();
    final buildsSyncStage = _BuildsSyncStageFake(sourceClient);

    tearDown(() {
      reset(sourceClient);
    });

    test(
      ".addCoverageData() returns an empty list if the given builds is null",
      () async {
        final result = await buildsSyncStage.addCoverageData(null);

        expect(result, isEmpty);
      },
    );

    test(
      ".addCoverageData() returns an empty list if the given builds are empty",
      () async {
        final result = await buildsSyncStage.addCoverageData([]);

        expect(result, isEmpty);
      },
    );

    test(
      ".addCoverageData() fetches coverage the given builds",
      () async {
        const builds = [firstBuild, secondBuild];

        await buildsSyncStage.addCoverageData(builds);

        verify(sourceClient.fetchCoverage(firstBuild)).called(once);
        verify(sourceClient.fetchCoverage(secondBuild)).called(once);
      },
    );

    test(
      ".addCoverageData() returns the build data with updated coverage fetched by the source client",
      () async {
        const builds = [firstBuild, secondBuild];

        final firstBuildCoverage = Percent(0.1);
        final secondBuildCoverage = Percent(0.2);
        final buildsWithCoverage = [
          firstBuild.copyWith(coverage: firstBuildCoverage),
          secondBuild.copyWith(coverage: secondBuildCoverage)
        ];

        when(sourceClient.fetchCoverage(secondBuild)).thenAnswer(
          (_) => Future.value(secondBuildCoverage),
        );
        when(sourceClient.fetchCoverage(firstBuild)).thenAnswer(
          (_) => Future.value(firstBuildCoverage),
        );

        final result = await buildsSyncStage.addCoverageData(builds);

        expect(result, equals(buildsWithCoverage));
      },
    );
  });
}

/// A fake class needed to test the [BuildsSyncStage]'s non-abstract methods.
class _BuildsSyncStageFake extends BuildsSyncStage {
  @override
  final SourceClient sourceClient;

  @override
  DestinationClient get destinationClient => null;

  /// Creates a new instance of this fake with the given [sourceClient].
  _BuildsSyncStageFake(this.sourceClient);

  @override
  FutureOr<InteractionResult> call(SyncConfig syncConfig) {
    return Future.value();
  }
}
