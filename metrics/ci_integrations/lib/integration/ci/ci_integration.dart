// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// A class providing a synchronization algorithm for a project's builds
/// performed on a CI tool and stored in a builds storage.
class CiIntegration with LoggerMixin {
  /// A [List] of [SyncStage]s this CI integration performs.
  final List<SyncStage> stages;

  /// Creates a [CiIntegration] instance with the given [stages].
  ///
  /// Throws an [ArgumentError] if the given [stages] is `null`.
  CiIntegration({this.stages}) {
    ArgumentError.checkNotNull(stages, 'stages');
  }

  /// Synchronizes builds for a project specified in the given [syncConfig].
  ///
  /// Throws an [ArgumentError] if the given [syncConfig] is `null`.
  Future<InteractionResult> sync(
    SyncConfig syncConfig,
  ) async {
    ArgumentError.checkNotNull(syncConfig);

    for (final stage in stages) {
      final stageResult = await stage.call(syncConfig);

      if (stageResult.isError) {
        return InteractionResult.error(
          message: 'Failed to sync the data! Details: ${stageResult.message}',
        );
      }
    }

    return const InteractionResult.success(
      message: 'The data has been synced successfully!',
    );
  }
}
