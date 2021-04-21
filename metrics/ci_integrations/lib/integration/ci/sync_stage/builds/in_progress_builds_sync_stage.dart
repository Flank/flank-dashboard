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

/// A class that represents a [SyncStage] for in-progress builds.
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
  FutureOr<InteractionResult> call(SyncConfig syncConfig) async {
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
          message: 'There are no in-progress builds in the destination.',
        );
      }

      List<BuildData> updatedBuilds;
      updatedBuilds = await _fetchUpdatedBuilds(
        inProgressBuilds,
        syncConfig,
      );

      if (syncConfig.coverage) {
        updatedBuilds = await addCoverageData(updatedBuilds);
      }

      await destinationClient.updateBuilds(destinationProjectId, updatedBuilds);

      return const InteractionResult.success();
    } catch (error) {
      return InteractionResult.error(
        message: '$error',
      );
    }
  }

  /// Fetches the updated [BuildData] using the given [inProgressBuilds] and
  /// [syncConfig].
  Future<List<BuildData>> _fetchUpdatedBuilds(
    List<BuildData> inProgressBuilds,
    SyncConfig syncConfig,
  ) async {
    final updatedBuilds = <BuildData>[];

    for (final build in inProgressBuilds) {
      final refreshedBuild = await _syncInProgressBuild(syncConfig, build);

      if (refreshedBuild != null) updatedBuilds.add(refreshedBuild);
    }

    return updatedBuilds;
  }

  /// Synchronizes the given in-progress [build].
  ///
  /// First, fetches the refreshed [BuildData] using the given
  /// [SyncConfig.sourceProjectId] and [BuildData.buildNumber] using the
  /// [sourceClient].
  ///
  /// Timeouts the build if the refreshed [BuildData] is `null` or has the
  /// [BuildData.buildStatus] equal to the [BuildStatus.inProgress] and the
  /// given [SyncConfig.inProgressTimeout] is reached. Returns `null` if the
  /// [SyncConfig.inProgressTimeout] is not reached.
  ///
  /// Otherwise, returns the refreshed [BuildData] with the updated
  /// [BuildData.id] and the [BuildData.projectId].
  Future<BuildData> _syncInProgressBuild(
    SyncConfig syncConfig,
    BuildData build,
  ) async {
    final refreshedBuild = await _fetchBuild(
      syncConfig.sourceProjectId,
      build.buildNumber,
    );

    if (refreshedBuild == null ||
        refreshedBuild.buildStatus == BuildStatus.inProgress) {
      return _processInProgressBuild(build, syncConfig.inProgressTimeout);
    }

    return refreshedBuild.copyWith(id: build.id, projectId: build.projectId);
  }

  /// Fetches a build with the given [buildNumber] of the project identified
  /// by the given [sourceProjectId].
  ///
  /// Returns `null` if fetching a build fails.
  Future<BuildData> _fetchBuild(String sourceProjectId, int buildNumber) {
    return sourceClient
        .fetchOneBuild(sourceProjectId, buildNumber)
        .catchError((_) => null);
  }

  /// Processes the given in-progress [build].
  ///
  /// Delegates to [_timeoutBuild] if the given [build] reaches the given
  /// [timeout].
  ///
  /// Otherwise, returns `null`.
  BuildData _processInProgressBuild(BuildData build, Duration timeout) {
    if (_shouldTimeoutBuild(build.startedAt, timeout)) {
      return _timeoutBuild(build, timeout);
    }

    return null;
  }

  /// Determines whether a build with the given [startedAt] date reaches
  /// the given [timeout].
  ///
  /// Returns `true` if the difference between the current date and
  /// the [startedAt] is greater than or equal to the given [timeout].
  /// Otherwise, returns `false`.
  bool _shouldTimeoutBuild(DateTime startedAt, Duration timeout) {
    final currentDate = DateTime.now();
    final buildDuration = currentDate.difference(startedAt);

    return buildDuration >= timeout;
  }

  /// Timeouts the given [build].
  ///
  /// Returns a new [BuildData] instance with the [BuildData.duration] equal
  /// to the given [timeout] and the [BuildStatus.unknown]
  /// [BuildData.buildStatus].
  BuildData _timeoutBuild(BuildData build, Duration timeout) {
    return build.copyWith(duration: timeout, buildStatus: BuildStatus.unknown);
  }
}
