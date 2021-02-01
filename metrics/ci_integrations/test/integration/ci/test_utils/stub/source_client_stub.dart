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

  /// Callback used to replace the default [fetchCoverage] method
  /// implementation for testing purposes.
  final Future<Percent> Function(BuildData) fetchCoverageCallback;

  /// Creates a new instance of the [SourceClientStub].
  SourceClientStub({
    this.fetchBuildsAfterCallback,
    this.fetchBuildsCallback,
    this.fetchCoverageCallback,
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
  Future<List<BuildData>> fetchBuilds(
    String projectId,
    int fetchLimit,
  ) {
    if (fetchBuildsCallback != null) {
      return fetchBuildsCallback(projectId);
    } else {
      return Future.value(BuildsTestData.builds);
    }
  }

  @override
  Future<Percent> fetchCoverage(BuildData build) {
    if (fetchCoverageCallback != null) {
      return fetchCoverageCallback(build);
    } else {
      return Future.value(BuildsTestData.firstBuild.coverage);
    }
  }

  @override
  void dispose() {}
}
