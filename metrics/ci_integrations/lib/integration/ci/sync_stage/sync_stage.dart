// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// An abstract class that represents a stage of the synchronization process.
abstract class SyncStage {
  /// A [SourceClient] of this stage.
  SourceClient get sourceClient;

  /// A [DestinationClient] of this stage.
  DestinationClient get destinationClient;

  /// Runs this stage using the given [syncConfig].
  ///
  /// Throws an [ArgumentError] if the given [syncConfig] is `null`.
  FutureOr<InteractionResult> call(SyncConfig syncConfig);
}
