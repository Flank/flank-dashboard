// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:metrics_core/metrics_core.dart';

import '../test_data/builds_test_data.dart';

/// A stub class for a [DestinationClient] abstract class providing test
/// implementation for methods.
class DestinationClientStub implements DestinationClient {
  /// Callback used to replace the default [fetchLastBuild] method
  /// implementation for testing purposes.
  final Future<BuildData> Function(String) fetchLastBuildCallback;

  /// Callback used to replace the default [addBuilds] method
  /// implementation for testing purposes.
  final Future<void> Function(String, List<BuildData>) addBuildsCallback;

  /// Creates this stub class instance.
  ///
  /// Both [fetchLastBuildCallback] and [addBuildsCallback] are optional.
  DestinationClientStub({
    this.fetchLastBuildCallback,
    this.addBuildsCallback,
  });

  @override
  Future<BuildData> fetchLastBuild(String projectId) {
    if (fetchLastBuildCallback != null) {
      return fetchLastBuildCallback(projectId);
    } else {
      return Future.value(BuildsTestData.firstBuild);
    }
  }

  @override
  Future<void> addBuilds(String projectId, List<BuildData> builds) async {
    if (addBuildsCallback != null) {
      return addBuildsCallback(projectId, builds);
    }
  }

  @override
  void dispose() {}
}
