// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/builds_sync_stage.dart';
import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a [SyncStage] for re-syncing builds with
/// the [BuildStatus.inProgress].
///
/// Fetches the [BuildStatus.inProgress] builds using the
/// [DestinationClient] and resynchronizes them using the [SourceClient].
/// Then updates the corresponding builds using the [DestinationClient].
///
/// If the build loaded from the [SourceClient] is still
/// [BuildStatus.inProgress] or updating a build fails, and the difference
/// between the [DateTime.now] and [Build.startedAt] exceeds the in-progress
/// timeout, sets the [BuildStatus.unknown] to the corresponding build.
class InProgressBuildsSyncStage extends BuildsSyncStage with LoggerMixin {
  @override
  final DestinationClient destinationClient;

  @override
  final SourceClient sourceClient;

  /// Creates a new instance of the [InProgressBuildsSyncStage] with the
  /// given [sourceClient] and [destinationClient].
  ///
  /// Throws an [ArgumentError] if the given [sourceClient] or
  /// [destinationClient] is `null`.
  InProgressBuildsSyncStage(this.sourceClient, this.destinationClient) {
    ArgumentError.checkNotNull(sourceClient, 'sourceClient');
    ArgumentError.checkNotNull(destinationClient, 'destinationClient');
  }

  @override
  Future<InteractionResult> call(SyncConfig syncConfig) async {
    logger.info('Running InProgressBuildsSyncStage...');

    ArgumentError.checkNotNull(syncConfig, 'syncConfig');

    final destinationProjectId = syncConfig.destinationProjectId;

    try {
      final inProgressBuilds = await destinationClient.fetchBuildsWithStatus(
        destinationProjectId,
        BuildStatus.inProgress,
      );

      if (inProgressBuilds.isEmpty) {
        return const InteractionResult.success(
          message: 'There are no in-progress builds to re-sync.',
        );
      }

      List<BuildData> buildUpdates = await _resyncBuilds(
        syncConfig,
        inProgressBuilds,
      );

      if (syncConfig.coverage) {
        buildUpdates = await addCoverageData(buildUpdates);
      }

      await destinationClient.updateBuilds(destinationProjectId, buildUpdates);

      return const InteractionResult.success();
    } catch (error) {
      return InteractionResult.error(
        message: '$error',
      );
    }
  }

  /// Re-synchronizes each [BuildData] of the given [inProgressBuilds] list
  /// and returns a list of updated [BuildData].
  Future<List<BuildData>> _resyncBuilds(
    SyncConfig syncConfig,
    List<BuildData> inProgressBuilds,
  ) async {
    final buildUpdates = <BuildData>[];

    for (final build in inProgressBuilds) {
      final refreshedBuild = await _resyncOneBuild(syncConfig, build);

      if (refreshedBuild != null) buildUpdates.add(refreshedBuild);
    }

    return buildUpdates;
  }

  /// Re-synchronizes the given [build]. Returns `null` if the given [build]
  /// shouldn't be updated.
  ///
  /// Fetches the corresponding build from the source using the [_fetchBuild]
  /// method. If fetching is failed or the corresponding build is
  /// [BuildStatus.inProgress], tries to timeout this build using the
  /// [_timeoutIfNecessary] method. Otherwise, returns the re-synced build.
  Future<BuildData> _resyncOneBuild(
    SyncConfig syncConfig,
    BuildData build,
  ) async {
    final sourceBuild = await _fetchBuild(
      syncConfig.sourceProjectId,
      build.buildNumber,
    );

    if (sourceBuild == null ||
        sourceBuild.buildStatus == BuildStatus.inProgress) {
      return _timeoutIfNecessary(build, syncConfig.inProgressTimeout);
    }

    return sourceBuild.copyWith(id: build.id, projectId: build.projectId);
  }

  /// Fetches a build with the given [buildNumber] of a project identified
  /// by the given [sourceProjectId].
  ///
  /// Returns `null` if fetching a build fails.
  Future<BuildData> _fetchBuild(String sourceProjectId, int buildNumber) {
    return sourceClient
        .fetchOneBuild(sourceProjectId, buildNumber)
        .catchError((_) => null);
  }

  /// Times out the given [build] if this build satisfies the
  /// [_shouldTimeoutBuild] method. Otherwise, returns `null`.
  BuildData _timeoutIfNecessary(BuildData build, Duration timeout) {
    if (_shouldTimeoutBuild(build.startedAt, timeout)) {
      return build.copyWith(
        duration: timeout,
        buildStatus: BuildStatus.unknown,
      );
    }

    return null;
  }

  /// Determines whether a build with the given [startedAt] date exceeds
  /// the given [timeout].
  ///
  /// Returns `true` if the difference between the [DateTime.now] and
  /// the [startedAt] is greater than or equal to the given [timeout].
  /// Otherwise, returns `false`.
  bool _shouldTimeoutBuild(DateTime startedAt, Duration timeout) {
    final currentDate = DateTime.now();
    final buildDuration = currentDate.difference(startedAt);

    return buildDuration >= timeout;
  }
}
