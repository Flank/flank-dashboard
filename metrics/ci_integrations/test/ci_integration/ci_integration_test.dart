import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/config/ci_config.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:metrics_core/src/data/model/build_data.dart';
import 'package:test/test.dart';

import 'test_data/builds_test_data.dart';

void main() {
  group("CiIntegration", () {
    final ciConfig = CiConfigTestbed();

    test(
      "should throw ArgumentError trying to create an instance with null CI client",
      () {
        expect(
          () => CiIntegration(
            ciClient: null,
            storageClient: StorageClientTestbed(),
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "should throw ArgumentError trying to create an instance with null storage client",
      () {
        expect(
          () => CiIntegration(
            ciClient: CiClientTestbed(),
            storageClient: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".sync() should throw ArgumentError if the given config is null",
      () {
        final ciIntegration = CiIntegration(
          ciClient: CiClientTestbed(),
          storageClient: StorageClientTestbed(),
        );

        expect(() => ciIntegration.sync(null), throwsArgumentError);
      },
    );

    test(
      ".sync() should result with error if a CI client throws fetching all builds",
      () {
        final ciClient = CiClientTestbed(
          fetchBuildsCallback: (_) => throw UnimplementedError(),
        );
        final storageClient = StorageClientTestbed(
          fetchLastBuildCallback: (_) => null,
        );
        final ciIntegration = CiIntegration(
          ciClient: ciClient,
          storageClient: storageClient,
        );
        final result = ciIntegration.sync(ciConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should result with error if a CI client throws fetching the builds after the given one",
      () {
        final ciClient = CiClientTestbed(
          fetchBuildsAfterCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationTestbed(ciClient: ciClient);
        final result = ciIntegration.sync(ciConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should result with error if a storage client throws fetching the last build",
      () {
        final storageClient = StorageClientTestbed(
          fetchLastBuildCallback: (_) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationTestbed(
          storageClient: storageClient,
        );
        final result = ciIntegration.sync(ciConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should result with error if a storage client throws adding new builds",
      () {
        final storageClient = StorageClientTestbed(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationTestbed(
          storageClient: storageClient,
        );
        final result = ciIntegration.sync(ciConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should ignore empty list of new builds and not call adding builds",
      () {
        final ciClient = CiClientTestbed(
          fetchBuildsAfterCallback: (_, __) => Future.value([]),
        );
        final storageClient = StorageClientTestbed(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegration(
          ciClient: ciClient,
          storageClient: storageClient,
        );
        final result =
            ciIntegration.sync(ciConfig).then((res) => res.isSuccess);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should synchronize builds",
      () {
        final ciIntegration = CiIntegrationTestbed();
        final result =
            ciIntegration.sync(ciConfig).then((res) => res.isSuccess);

        expect(result, completion(isTrue));
      },
    );
  });
}

/// A testbed class for a [CiConfig] abstract class providing required
/// implementations.
class CiIntegrationTestbed extends CiIntegration {
  final StorageClientTestbed _storageClientTestbed;
  final CiClientTestbed _ciClientTestbed;

  @override
  StorageClient get storageClient => _storageClientTestbed;

  @override
  CiClient get ciClient => _ciClientTestbed;

  CiIntegrationTestbed({
    StorageClientTestbed storageClient,
    CiClientTestbed ciClient,
  })  : _storageClientTestbed = storageClient ?? StorageClientTestbed(),
        _ciClientTestbed = ciClient ?? CiClientTestbed();
}

/// A testbed class for a [CiConfig] abstract class providing required
/// implementations.
class CiConfigTestbed implements CiConfig {
  @override
  String get ciProjectId => 'ciProjectId';

  @override
  String get storageProjectId => 'storageProjectId';
}

/// A testbed class for a [CiClient] abstract class providing test
/// implementation for methods.
class CiClientTestbed implements CiClient {
  /// Callback used to replace the default [fetchBuildsAfter] method
  /// implementation in testing purposes.
  final Future<List<BuildData>> Function(String, BuildData)
      fetchBuildsAfterCallback;

  /// Callback used to replace the default [fetchBuilds] method
  /// implementation in testing purposes.
  final Future<List<BuildData>> Function(String) fetchBuildsCallback;

  /// Creates a testbed instance.
  ///
  /// The [fetchBuildsAfterCallback] is optional.
  CiClientTestbed({
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
}

/// A testbed class for a [StorageClient] abstract class providing test
/// implementation for methods.
class StorageClientTestbed implements StorageClient {
  /// Callback used to replace the default [fetchLastBuild] method
  /// implementation in testing purposes.
  final Future<BuildData> Function(String) fetchLastBuildCallback;

  /// Callback used to replace the default [addBuilds] method
  /// implementation in testing purposes.
  final Future<void> Function(String, List<BuildData>) addBuildsCallback;

  /// Creates a testbed instance.
  ///
  /// Both [fetchLastBuildCallback] and [addBuildsCallback] are optional.
  StorageClientTestbed({
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
