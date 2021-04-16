// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';

/// A class providing a synchronization algorithm for a project's builds
/// performed on a CI tool and stored in a builds storage.
class CiIntegration with LoggerMixin {
  /// Used to interact with a source API.
  final SourceClient sourceClient;

  /// Used to interact with a builds storage.
  final DestinationClient destinationClient;

  /// Creates a [CiIntegration] instance with the given [sourceClient]
  /// and [destinationClient].
  ///
  /// Throws an [ArgumentError] if the given [stages] list is `null`.
  CiIntegration({
    @required this.stages,
  }) {
    ArgumentError.checkNotNull(stages, 'stages');
  }

  /// Synchronizes builds for a project specified in the given [config].
  ///
  /// Throws an [ArgumentError] if the given [config] is `null`.
  Future<InteractionResult> sync(
    SyncConfig config,
  ) async {
    ArgumentError.checkNotNull(config);

    try {
      final sourceProjectId = config.sourceProjectId;
      final destinationProjectId = config.destinationProjectId;

    for (final stage in stages) {
      final stageResult = await stage(syncConfig);

      if (stageResult == null || stageResult.isError) {
        return InteractionResult.error(
          message: _getStageErrorMessage(stage, stageResult),
        );
      }

      if (newBuilds == null || newBuilds.isEmpty) {
        return const InteractionResult.success(
          message: 'The project data is up-to-date!',
        );
      }

      if (config.coverage) {
        newBuilds = await _fetchCoverage(newBuilds);
      }

      await destinationClient.addBuilds(
        destinationProjectId,
        newBuilds,
      );

    return const InteractionResult.success(
      message: 'The data has been synced successfully!',
    );
  }

  /// Returns a message that describes an error occurred during
  /// the given [stage], finished with the given [stageResult].
  ///
  /// Adds the [InteractionResult.message] of the given [stageResult], if this
  /// result is not `null`.
  String _getStageErrorMessage(SyncStage stage, InteractionResult stageResult) {
    String message = 'Failed to run the ${stage.runtimeType}';

    if (stageResult?.message != null) {
      message = '$message due to the following error: ${stageResult.message}';
    }

    return message;
  }
}
