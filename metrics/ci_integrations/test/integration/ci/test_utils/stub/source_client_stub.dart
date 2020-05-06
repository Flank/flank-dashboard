import 'dart:async';

import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:metrics_core/metrics_core.dart';

import '../test_data/builds_test_data.dart';

/// A stub class for a [SourceClient] abstract class providing test
/// implementation for methods.
class SourceClientStub implements SourceClient {
  /// Callback used to replace the default [fetchBuildsAfter] method
  /// implementation for testing purposes.
  final Future<List<BuildData>> Function(String, BuildData)
      fetchBuildsAfterCallback;

  /// Callback used to replace the default [fetchBuilds] method
  /// implementation for testing purposes.
  final Future<List<BuildData>> Function(String) fetchBuildsCallback;

  /// Creates this stub class instance.
  ///
  /// Both [fetchBuildsAfterCallback] and [fetchBuildsCallback] are optional.
  SourceClientStub({
    this.fetchBuildsAfterCallback,
    this.fetchBuildsCallback,
  });

  @override
  Future<List<BuildData>> fetchBuildsAfter(String projectId, BuildData build) {
    if (fetchBuildsAfterCallback != null) {
      return fetchBuildsAfterCallback(projectId, build);
    } else {
      final builds = BuildsTestData.builds;

      final index = BuildsTestData.builds.indexWhere(
        (b) => b.buildNumber == build.buildNumber,
      );
      final result =
          builds.sublist(index == null || index == -1 ? 0 : index + 1);

      return Future.value(result);
    }
  }

  @override
  Future<List<BuildData>> fetchBuilds(String projectId) {
    if (fetchBuildsCallback != null) {
      return fetchBuildsCallback(projectId);
    } else {
      return Future.value(BuildsTestData.builds);
    }
  }

  @override
  void dispose() {}
}
