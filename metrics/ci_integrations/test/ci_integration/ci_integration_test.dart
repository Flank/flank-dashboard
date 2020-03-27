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
    final defaultCiClientTestbed = CiClientTestbed();
    final defaultStorageClientTestbed = StorageClientTestbed();

    test(
      "should throw ArgumentError trying to create an instance with null ci client",
      () {
        expect(
          () => CiIntegration(
            ciClient: null,
            storageClient: defaultStorageClientTestbed,
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
            ciClient: defaultCiClientTestbed,
            storageClient: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(".sync() should result with error if a ci client throws", () {
      final ciClient = CiClientTestbed(
        fetchBuildsAfterCallback: (_, __) => throw UnimplementedError(),
      );
      final ciIntegration = CiIntegration(
        ciClient: ciClient,
        storageClient: defaultStorageClientTestbed,
      );
      final result = ciIntegration.sync(ciConfig).then((res) => res.isError);

      expect(result, completion(isTrue));
    });

    test(
      ".sync() should result with error if a storage client throws fetching the last build",
      () {
        final storageClient = StorageClientTestbed(
          fetchLastBuildCallback: (_) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegration(
          ciClient: defaultCiClientTestbed,
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
        final ciIntegration = CiIntegration(
          ciClient: defaultCiClientTestbed,
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
        final ciIntegration = CiIntegration(
          ciClient: defaultCiClientTestbed,
          storageClient: defaultStorageClientTestbed,
        );
        final result =
            ciIntegration.sync(ciConfig).then((res) => res.isSuccess);

        expect(result, completion(isTrue));
      },
    );
  });
}

class CiConfigTestbed extends CiConfig {
  @override
  String get ciProjectId => 'ciProjectId';

  @override
  String get storageProjectId => 'storageProjectId';
}

class CiClientTestbed extends CiClient {
  final Future<List<BuildData>> Function(String, BuildData)
      fetchBuildsAfterCallback;

  CiClientTestbed({
    this.fetchBuildsAfterCallback,
  });

  @override
  Future<List<BuildData>> fetchBuildsAfter(String projectId, BuildData build) {
    if (fetchBuildsAfterCallback != null) {
      return fetchBuildsAfterCallback(projectId, build);
    } else {
      List<BuildData> builds;

      if (build == null) {
        builds = BuildsTestData.builds;
      } else {
        final index = BuildsTestData.builds.indexWhere(
          (b) => b.buildNumber == build.buildNumber,
        );
        builds = BuildsTestData.builds
            .sublist(index == null || index == -1 ? 0 : index + 1);
      }

      return Future.value(builds);
    }
  }
}

class StorageClientTestbed extends StorageClient {
  final Future<BuildData> Function(String) fetchLastBuildCallback;
  final Future<void> Function(String, List<BuildData>) addBuildsCallback;

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
