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

      List<BuildData> updatedBuilds;

      for (final build in inProgressBuilds) {
        final refreshedBuild = await _syncInProgressBuild(syncConfig, build);

        if (refreshedBuild != null) updatedBuilds.add(refreshedBuild);
      }

      if (syncConfig.coverage) await addCoverageData(updatedBuilds);

      await destinationClient.updateBuilds(destinationProjectId, updatedBuilds);

      return const InteractionResult.success(
        message: 'The data has been synced successfully!',
      );
    } catch (error) {
      return InteractionResult.error(
        message: 'Failed to sync the data! Details: $error',
      );
    }
  }

  /// Synchronized the given in-progress [build].
  ///
  /// If the build duration has reached the [SyncConfig.inProgressTimeout] and
  /// its status is still [BuildStatus.inProgress], returns the updated build
  /// with the [BuildStatus.unknown] status.
  /// If the build status is not [BuildStatus.inProgress] anymore, returns the
  /// updated build with the new status.
  /// Otherwise, returns `null`.
  Future<BuildData> _syncInProgressBuild(
      SyncConfig syncConfig, BuildData build) async {
    final sourceProjectId = syncConfig.sourceProjectId;
    final buildNumber = build.buildNumber;

    BuildData updatedBuild;

    final refreshedBuild = await _fetchBuild(sourceProjectId, buildNumber);

    if (refreshedBuild == null ||
        refreshedBuild.buildStatus == BuildStatus.inProgress) {
      final startedAt = refreshedBuild.startedAt;
      final timeout = syncConfig.inProgressTimeout;

      if (_shouldTimeoutBuild(startedAt, timeout)) {
        updatedBuild = build.copyWith(
          duration: timeout,
          buildStatus: BuildStatus.unknown,
        );
      }
    } else {
      updatedBuild = refreshedBuild.copyWith(
        id: build.id,
        projectId: build.projectId,
      );
    }

    return updatedBuild;
  }

  /// Fetches a build with the given [buildNumber] for the project identified
  /// by the given [sourceProjectId].
  ///
  /// Returns `null` if fetching of the build with the given [buildNumber] fails.
  Future<BuildData> _fetchBuild(String sourceProjectId, int buildNumber) {
    return sourceClient
        .fetchOneBuild(sourceProjectId, buildNumber)
        .catchError(() => null);
  }

  /// Determines whether the build that started at given [startedAt] date
  /// has reached the given [timeout].
  ///
  /// Returns `true` if the difference between the current date and
  /// the [startedAt] is greater or equal to the given [timeout].
  /// Otherwise, returns `false`.
  bool _shouldTimeoutBuild(DateTime startedAt, Duration timeout) {
    final currentDate = DateTime.now();
    final buildDuration = currentDate.difference(startedAt);

    return buildDuration >= timeout;
  }
}
