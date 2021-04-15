// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/integration/ci/sync_stage/builds/in_progress_builds_sync_stage.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/new_builds_sync_stage.dart';
import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:meta/meta.dart';

/// A factory class that provides a method for creating [SyncStage]s.
class SyncStageFactory {
  /// A [SourceClient] of this factory used to create the [SyncStage]s.
  final SourceClient sourceClient;

  /// A [DestinationClient] of this factory used to create the [SyncStage]s.
  final DestinationClient destinationClient;

  /// Creates a new instance of the [SyncStageFactory] with the given
  /// [sourceClient] and [destinationClient].
  ///
  /// Throws an [ArgumentError] if the given [sourceClient] or
  /// [destinationClient] is `null`.
  SyncStageFactory({
    @required this.sourceClient,
    @required this.destinationClient,
  }) {
    ArgumentError.checkNotNull(sourceClient, 'sourceClient');
    ArgumentError.checkNotNull(destinationClient, 'destinationClient');
  }

  /// Creates a [List] of [SyncStage]s with the [sourceClient] and the
  /// [destinationClient].
  ///
  /// The result is an [UnmodifiableListView].
  List<SyncStage> create() {
    return UnmodifiableListView([
      InProgressBuildsSyncStage(sourceClient, destinationClient),
      NewBuildsSyncStage(sourceClient, destinationClient),
    ]);
  }
}
