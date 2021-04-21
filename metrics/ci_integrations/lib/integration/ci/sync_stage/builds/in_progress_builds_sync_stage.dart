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

      List<BuildData> buildUpdates = await _fetchBuildUpdates(
        inProgressBuilds,
        syncConfig,
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

  /// Resynchronizes each [BuildData] of the given [inProgressBuilds] list
  /// and returns a [List] of [BuildData] needed to be updated in the
  /// destination.
  Future<List<BuildData>> _fetchBuildUpdates(
    List<BuildData> inProgressBuilds,
    SyncConfig syncConfig,
  ) async {
    final buildUpdates = <BuildData>[];

    for (final build in inProgressBuilds) {
      final resyncedBuild = await _resyncBuild(syncConfig, build);

      if (resyncedBuild != null) buildUpdates.add(resyncedBuild);
    }

    return buildUpdates;
  }

  /// Resynchronizes the given [build].
  ///
  /// First, fetches the [BuildData] for the given [build] using the
  /// [SyncConfig.sourceProjectId] and [BuildData.buildNumber] using the
  /// [sourceClient].
  ///
  /// Timeouts the updated build if it is `null` or has the
  /// [BuildData.buildStatus] equal to the [BuildStatus.inProgress] and the
  /// given [SyncConfig.inProgressTimeout] is exceeded. Returns `null` if the
  /// [SyncConfig.inProgressTimeout] is not exceeded.
  ///
  /// Otherwise, returns the [BuildData] with the updated [BuildData.id] and the
  /// [BuildData.projectId].
  Future<BuildData> _resyncBuild(
    SyncConfig syncConfig,
    BuildData build,
  ) async {
    final updatedBuild = await _fetchBuild(
      syncConfig.sourceProjectId,
      build.buildNumber,
    );

    if (updatedBuild == null ||
        updatedBuild.buildStatus == BuildStatus.inProgress) {
      return _processUpdatedBuild(build, syncConfig.inProgressTimeout);
    }

    return updatedBuild.copyWith(id: build.id, projectId: build.projectId);
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

  /// Processes the given updated [build].
  ///
  /// Timeouts the given [build] using the [_timeoutBuild] if the given
  /// [build] exceeds the given [timeout]. Otherwise, returns `null`.
  BuildData _processUpdatedBuild(BuildData build, Duration timeout) {
    if (_shouldTimeoutBuild(build.startedAt, timeout)) {
      return _timeoutBuild(build, timeout);
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

  /// Timeouts the given [build].
  ///
  /// Returns a new [BuildData] instance with the [BuildData.duration] equal
  /// to the given [timeout] and the [BuildStatus.unknown]
  /// [BuildData.buildStatus].
  BuildData _timeoutBuild(BuildData build, Duration timeout) {
    return build.copyWith(duration: timeout, buildStatus: BuildStatus.unknown);
  }
}
