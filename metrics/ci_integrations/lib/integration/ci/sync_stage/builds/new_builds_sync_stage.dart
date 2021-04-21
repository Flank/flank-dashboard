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

/// A [SyncStage] implementation that synchronizes new builds.
class NewBuildsSyncStage extends BuildsSyncStage with LoggerMixin {
  @override
  final SourceClient sourceClient;

  @override
  final DestinationClient destinationClient;

  /// Creates a new instance of the [NewBuildsSyncStage] with the
  /// given [sourceClient] and [destinationClient].
  ///
  /// Throws an [ArgumentError] if the given [sourceClient] or
  /// [destinationClient] is `null`.
  NewBuildsSyncStage(this.sourceClient, this.destinationClient) {
    ArgumentError.checkNotNull(sourceClient, 'sourceClient');
    ArgumentError.checkNotNull(destinationClient, 'destinationClient');
  }

  @override
  Future<InteractionResult> call(SyncConfig syncConfig) async {
    logger.info('Running a NewBuildsSyncStage...');

    ArgumentError.checkNotNull(syncConfig, 'syncConfig');

    try {
      final destinationProjectId = syncConfig.destinationProjectId;

      final lastBuild = await destinationClient.fetchLastBuild(
        destinationProjectId,
      );

      List<BuildData> newBuilds = await _fetchNewBuilds(lastBuild, syncConfig);

      if (newBuilds.isEmpty) {
        return const InteractionResult.success(
          message: 'The project data is up-to-date!',
        );
      }

      if (syncConfig.coverage) {
        newBuilds = await addCoverageData(newBuilds);
      }

      await destinationClient.addBuilds(
        destinationProjectId,
        newBuilds,
      );

      return const InteractionResult.success();
    } catch (error) {
      return InteractionResult.error(
        message: '$error',
      );
    }
  }

  /// Fetches the new builds from the source of the given [syncConfig].
  ///
  /// If the given [lastBuild] is `null`, fetches the given
  /// [SyncConfig.initialSyncLimit] number of builds using the
  /// [SourceClient.fetchBuilds] method.
  /// Otherwise, fetches the new builds after the given [lastBuild] using the
  /// [SourceClient.fetchBuildsAfter] method.
  Future<List<BuildData>> _fetchNewBuilds(
    BuildData lastBuild,
    SyncConfig syncConfig,
  ) {
    final sourceProjectId = syncConfig.sourceProjectId;

    if (lastBuild == null) {
      logger.info('There are no builds in the destination...');

      return sourceClient.fetchBuilds(
        sourceProjectId,
        syncConfig.initialSyncLimit,
      );
    }

    return sourceClient.fetchBuildsAfter(
      sourceProjectId,
      lastBuild,
    );
  }
}
