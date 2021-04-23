// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/in_progress_builds_sync_stage.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../cli/test_util/mock/integration_client_mock.dart';
import '../../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("InProgressBuildsSyncStage", () {
    const inProgressTimeout = Duration(hours: 1);
    const sourceProjectId = 'sourceId';
    const projectId = 'projectId';
    const destinationProjectId = 'destinationId';

    final currentDate = DateTime.now();
    final startedAt = currentDate.subtract(
      inProgressTimeout * 0.5,
    );
    final timedOutStartedAt = currentDate.subtract(
      inProgressTimeout * 2,
    );
    final inProgressBuilds = [
      BuildData(
        buildNumber: 1,
        buildStatus: BuildStatus.inProgress,
        startedAt: startedAt,
        projectId: projectId,
      ),
      BuildData(
        buildNumber: 2,
        buildStatus: BuildStatus.inProgress,
        startedAt: startedAt,
        projectId: projectId,
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
        initialSyncLimit: 28,
        inProgressTimeout: inProgressTimeout,
        coverage: coverage,
      );
    }

    final syncConfig = createSyncConfig(coverage: false);
    final syncConfigWithCoverage = createSyncConfig(coverage: true);

    PostExpectation<Future<List<BuildData>>> whenFetchInProgressBuilds() {
      return when(destinationClient.fetchBuildsWithStatus(
        destinationProjectId,
        BuildStatus.inProgress,
      ));
    }

    PostExpectation<Future<BuildData>> whenFetchOneBuild(BuildData build) {
      return when(sourceClient.fetchOneBuild(
        sourceProjectId,
        build.buildNumber,
      ));
    }

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
      ".call() fetches in-progress builds from the destination",
      () async {
        whenFetchInProgressBuilds().thenAnswer((_) => Future.value([]));

        await syncStage.call(syncConfig);

        verify(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).called(once);
      },
    );

    test(
      ".call() does not continue syncing if the fetched in-progress builds list is empty",
      () async {
        whenFetchInProgressBuilds().thenAnswer((_) => Future.value([]));

        await syncStage.call(syncConfig);

        verify(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).called(once);

        verifyZeroInteractions(sourceClient);
        verifyNoMoreInteractions(destinationClient);
      },
    );

    test(
      ".call() returns a success if the fetched in-progress builds list is empty",
      () async {
        whenFetchInProgressBuilds().thenAnswer((_) => Future.value([]));

        final result = await syncStage.call(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".call() does not continue syncing if fetching in-progress builds fails",
      () async {
        whenFetchInProgressBuilds().thenAnswer((_) => Future.error(error));

        await syncStage.call(syncConfig);

        verify(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).called(once);

        verifyZeroInteractions(sourceClient);
        verifyNoMoreInteractions(destinationClient);
      },
    );

    test(
      ".call() returns an error if fetching in-progress builds fails",
      () async {
        whenFetchInProgressBuilds().thenAnswer((_) => Future.error(error));

        final result = await syncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() re-fetches each fetched in-progress build from the given destination client",
      () async {
        final buildNumbers = inProgressBuilds.map((build) => build.buildNumber);
        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
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

    test(
      ".call() does not update a build if the corresponding build is in progress and the current one is not timed out",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: startedAt,
        );
        final inProgressBuilds = [inProgressBuild];

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(inProgressBuild),
        );

        await syncStage.call(syncConfig);

        verifyNever(destinationClient.updateBuilds(
          destinationProjectId,
          argThat(isNotEmpty),
        ));
      },
    );

    test(
      ".call() does not update a build if the corresponding build is null and the current one is not timed out",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: startedAt,
        );
        final inProgressBuilds = [inProgressBuild];

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(),
        );

        await syncStage.call(syncConfig);

        verifyNever(destinationClient.updateBuilds(
          destinationProjectId,
          argThat(isNotEmpty),
        ));
      },
    );

    test(
      ".call() does not update a build if fetching the corresponding build fails and the build is not timed out",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: startedAt,
        );
        final inProgressBuilds = [inProgressBuild];

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.error(error),
        );

        await syncStage.call(syncConfig);

        verifyNever(destinationClient.updateBuilds(
          destinationProjectId,
          argThat(isNotEmpty),
        ));
      },
    );

    test(
      ".call() updates a build as timed out if the corresponding build is in progress and the build exceeds a timeout duration",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild];
        final expectedTimedOutBuild = inProgressBuild.copyWith(
          duration: inProgressTimeout,
          buildStatus: BuildStatus.unknown,
        );

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(inProgressBuild),
        );

        await syncStage.call(syncConfig);

        verify(destinationClient.updateBuilds(
          destinationProjectId,
          [expectedTimedOutBuild],
        )).called(once);
      },
    );

    test(
      ".call() updates a build as timed out if the corresponding build is null and the build exceeds a timeout duration",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild];
        final expectedTimedOutBuild = inProgressBuild.copyWith(
          duration: inProgressTimeout,
          buildStatus: BuildStatus.unknown,
        );

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(),
        );

        await syncStage.call(syncConfig);

        verify(destinationClient.updateBuilds(
          destinationProjectId,
          [expectedTimedOutBuild],
        )).called(once);
      },
    );

    test(
      ".call() updates a build as timed out if it exceeds a timeout duration and fetching the corresponding build fails",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild];
        final expectedTimedOutBuild = inProgressBuild.copyWith(
          duration: inProgressTimeout,
          buildStatus: BuildStatus.unknown,
        );

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.error(error),
        );

        await syncStage.call(syncConfig);

        verify(destinationClient.updateBuilds(
          destinationProjectId,
          [expectedTimedOutBuild],
        )).called(once);
      },
    );

    test(
      ".call() updates a build if the corresponding build is finished",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild];
        final finishedBuild = inProgressBuild.copyWith(
          buildStatus: BuildStatus.successful,
        );

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(finishedBuild),
        );

        await syncStage.call(syncConfig);

        verify(destinationClient.updateBuilds(
          destinationProjectId,
          [finishedBuild],
        )).called(once);
      },
    );

    test(
      ".call() returns an error if updating builds fails",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild];

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(),
        );
        when(
          destinationClient.updateBuilds(destinationProjectId, any),
        ).thenAnswer((_) => Future.error(error));

        final result = await syncStage.call(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() fetches coverage for the builds to update if the coverage option is enabled in the sync config",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final anotherInProgressBuild = BuildData(
          buildNumber: 2,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild, anotherInProgressBuild];
        final updatedBuilds = inProgressBuilds
            .map((build) => build.copyWith(buildStatus: BuildStatus.successful))
            .toList();

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuilds[0]).thenAnswer(
          (_) => Future.value(updatedBuilds[0]),
        );
        whenFetchOneBuild(inProgressBuilds[1]).thenAnswer(
          (_) => Future.value(updatedBuilds[1]),
        );

        await syncStage.call(syncConfigWithCoverage);

        verify(
          sourceClient.fetchCoverage(argThat(isIn(updatedBuilds))),
        ).called(updatedBuilds.length);
      },
    );

    test(
      ".call() does not fetch coverage for builds to update if the coverage option is not enabled in the sync config",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final anotherInProgressBuild = BuildData(
          buildNumber: 2,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild, anotherInProgressBuild];
        final updatedBuilds = inProgressBuilds
            .map((build) => build.copyWith(buildStatus: BuildStatus.successful))
            .toList();

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuilds[0]).thenAnswer(
          (_) => Future.value(updatedBuilds[0]),
        );
        whenFetchOneBuild(inProgressBuilds[1]).thenAnswer(
          (_) => Future.value(updatedBuilds[1]),
        );

        await syncStage.call(syncConfig);

        verifyNever(sourceClient.fetchCoverage(argThat(isIn(updatedBuilds))));
      },
    );

    test(
      ".call() does not continue syncing if fetching coverage for a build fails",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild];
        final updatedBuilds = inProgressBuilds
            .map((build) => build.copyWith(buildStatus: BuildStatus.successful))
            .toList();

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(updatedBuilds[0]),
        );
        when(
          sourceClient.fetchCoverage(updatedBuilds[0]),
        ).thenAnswer((_) => Future.error(error));

        await syncStage.call(syncConfigWithCoverage);

        verify(destinationClient.fetchBuildsWithStatus(
          destinationProjectId,
          BuildStatus.inProgress,
        )).called(once);
        verify(sourceClient.fetchOneBuild(
          sourceProjectId,
          inProgressBuild.buildNumber,
        )).called(once);
        verify(sourceClient.fetchCoverage(updatedBuilds[0])).called(once);

        verifyNoMoreInteractions(sourceClient);
        verifyNoMoreInteractions(destinationClient);
      },
    );

    test(
      ".call() returns an error if fetching coverage for a build fails",
      () async {
        final inProgressBuild = BuildData(
          buildNumber: 1,
          buildStatus: BuildStatus.inProgress,
          startedAt: timedOutStartedAt,
        );
        final inProgressBuilds = [inProgressBuild];
        final updatedBuilds = inProgressBuilds
            .map((build) => build.copyWith(buildStatus: BuildStatus.successful))
            .toList();

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuild).thenAnswer(
          (_) => Future.value(updatedBuilds[0]),
        );
        when(
          sourceClient.fetchCoverage(updatedBuilds[0]),
        ).thenAnswer((_) => Future.error(error));

        final result = await syncStage.call(syncConfigWithCoverage);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".call() updates builds with the fetched coverage if the coverage option is enabled in the sync config",
      () async {
        final updatedBuilds = inProgressBuilds
            .map((build) => build.copyWith(buildStatus: BuildStatus.successful))
            .toList();

        final coverage = Percent(0.1);
        final updatedBuildsWithCoverage = updatedBuilds
            .map((build) => build.copyWith(coverage: coverage))
            .toList();

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuilds[0]).thenAnswer(
          (_) => Future.value(updatedBuilds[0]),
        );
        whenFetchOneBuild(inProgressBuilds[1]).thenAnswer(
          (_) => Future.value(updatedBuilds[1]),
        );
        when(
          sourceClient.fetchCoverage(argThat(isIn(updatedBuilds))),
        ).thenAnswer((_) => Future.value(coverage));

        await syncStage.call(syncConfigWithCoverage);

        verify(destinationClient.updateBuilds(
          destinationProjectId,
          updatedBuildsWithCoverage,
        )).called(once);
      },
    );

    test(
      ".call() returns a success if updating builds succeeds",
      () async {
        final updatedBuilds = inProgressBuilds
            .map((build) => build.copyWith(buildStatus: BuildStatus.successful))
            .toList();

        whenFetchInProgressBuilds().thenAnswer(
          (_) => Future.value(inProgressBuilds),
        );
        whenFetchOneBuild(inProgressBuilds[0]).thenAnswer(
          (_) => Future.value(updatedBuilds[0]),
        );
        whenFetchOneBuild(inProgressBuilds[1]).thenAnswer(
          (_) => Future.value(updatedBuilds[1]),
        );
        when(
          destinationClient.updateBuilds(projectId, updatedBuilds),
        ).thenAnswer((_) => Future.value());

        final result = await syncStage.call(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );
  });
}
