import 'package:ci_integration/common/client/storage_client.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../test_data/builds_test_data.dart';

/// A stub class for a [StorageClient] abstract class providing test
/// implementation for methods.
class StorageClientStub implements StorageClient {
  /// Callback used to replace the default [fetchLastBuild] method
  /// implementation in testing purposes.
  final Future<BuildData> Function(String) fetchLastBuildCallback;

  /// Callback used to replace the default [addBuilds] method
  /// implementation in testing purposes.
  final Future<void> Function(String, List<BuildData>) addBuildsCallback;

  /// Creates this stub class instance.
  ///
  /// Both [fetchLastBuildCallback] and [addBuildsCallback] are optional.
  StorageClientStub({
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
}
