// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/builds_sync_stage.dart';
import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// A class that represents a [SyncStage] for in-progress builds.
class InProgressBuildsSyncStage extends BuildsSyncStage {
  @override
  final DestinationClient destinationClient;

  @override
  final SourceClient sourceClient;

  /// Creates a new instance of the [InProgressBuildsSyncStage] with the
  /// given [sourceClient] and [destinationClient]
  ///
  /// Throws an [ArgumentError] if the given [sourceClient] or
  /// [destinationClient] is `null`.
  InProgressBuildsSyncStage(this.sourceClient, this.destinationClient) {
    ArgumentError.checkNotNull(sourceClient, 'sourceClient');
    ArgumentError.checkNotNull(destinationClient, 'destinationClient');
  }

  @override
  FutureOr<InteractionResult> call(SyncConfig syncConfig) {
    ArgumentError.checkNotNull(syncConfig, 'syncConfig');

    return const InteractionResult.success();
  }
}
