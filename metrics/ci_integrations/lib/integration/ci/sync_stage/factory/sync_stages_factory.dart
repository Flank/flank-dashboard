// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/integration/ci/sync_stage/builds/in_progress_builds_sync_stage.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/new_builds_sync_stage.dart';
import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:meta/meta.dart';

/// A factory class that creates a list of [SyncStage]s to perform
/// the synchronization algorithm.
class SyncStagesFactory {
  /// Creates a new instance of the [SyncStagesFactory].
  const SyncStagesFactory();

  /// Creates a [List] of [SyncStage]s with the given [sourceClient] and the
  /// [destinationClient].
  ///
  /// Throws an [ArgumentError] if the given [sourceClient] or
  /// [destinationClient] is `null`.
  ///
  /// The result is an [UnmodifiableListView].
  List<SyncStage> create({
    @required SourceClient sourceClient,
    @required DestinationClient destinationClient,
  }) {
    ArgumentError.checkNotNull(sourceClient, 'sourceClient');
    ArgumentError.checkNotNull(destinationClient, 'destinationClient');

    return UnmodifiableListView([
      InProgressBuildsSyncStage(sourceClient, destinationClient),
      NewBuildsSyncStage(sourceClient, destinationClient),
    ]);
  }
}
