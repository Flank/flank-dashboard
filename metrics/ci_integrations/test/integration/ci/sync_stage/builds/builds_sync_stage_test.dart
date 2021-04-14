// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/ci/sync_stage/builds/builds_sync_stage.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:test/test.dart';

void main() {
  group("BuildsSyncStage", () {
    test(
      "",
      () {},
    );
  });
}

/// A fake class needed to test the [BuildsSyncStage] non-abstract methods.
class _BuildsSyncStageFake extends BuildsSyncStage {
  @override
  final SourceClient sourceClient;

  @override
  final DestinationClient destinationClient;

  /// Creates a new instance of this fake with the given [sourceClient]
  /// and [destinationClient].
  _BuildsSyncStageFake(this.sourceClient, this.destinationClient);

  @override
  FutureOr<InteractionResult> call(SyncConfig syncConfig) {
    return Future.value();
  }
}
