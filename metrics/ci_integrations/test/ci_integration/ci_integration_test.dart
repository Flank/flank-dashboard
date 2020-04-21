import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:test/test.dart';

import 'test_util/stub/ci_client_stub.dart';
import 'test_util/stub/storage_client_stub.dart';

void main() {
  group("CiIntegration", () {
    final syncConfig = SyncConfig(
      sourceProjectId: 'sourceProjectId',
      destinationProjectId: 'destinationProjectId',
    );

    test(
      "should throw ArgumentError trying to create an instance with null CI client",
      () {
        expect(
          () => CiIntegration(
            sourceClient: null,
            destinationClient: StorageClientStub(),
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
            sourceClient: CiClientStub(),
            destinationClient: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".sync() should throw ArgumentError if the given config is null",
      () {
        final ciIntegration = CiIntegration(
          sourceClient: CiClientStub(),
          destinationClient: StorageClientStub(),
        );

        expect(() => ciIntegration.sync(null), throwsArgumentError);
      },
    );

    test(
      ".sync() should result with an error if a CI client throws fetching all builds",
      () {
        final ciClient = CiClientStub(
          fetchBuildsCallback: (_) => throw UnimplementedError(),
        );
        final storageClient = StorageClientStub(
          fetchLastBuildCallback: (_) => null,
        );
        final ciIntegration = CiIntegration(
          sourceClient: ciClient,
          destinationClient: storageClient,
        );
        final result = ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should result with an error if a CI client throws fetching the builds after the given one",
      () {
        final ciClient = CiClientStub(
          fetchBuildsAfterCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(ciClient: ciClient);
        final result = ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should result with error if a storage client throws fetching the last build",
      () {
        final storageClient = StorageClientStub(
          fetchLastBuildCallback: (_) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(
          storageClient: storageClient,
        );
        final result = ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should result with an error if a storage client throws adding new builds",
      () {
        final storageClient = StorageClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(
          storageClient: storageClient,
        );
        final result = ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should ignore empty list of new builds and not call adding builds",
      () {
        final ciClient = CiClientStub(
          fetchBuildsAfterCallback: (_, __) => Future.value([]),
        );
        final storageClient = StorageClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegration(
          sourceClient: ciClient,
          destinationClient: storageClient,
        );
        final result =
            ciIntegration.sync(syncConfig).then((res) => res.isSuccess);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() should synchronize builds",
      () {
        final ciIntegration = CiIntegrationStub();
        final result =
            ciIntegration.sync(syncConfig).then((res) => res.isSuccess);

        expect(result, completion(isTrue));
      },
    );
  });
}

/// A stub class for a [CiConfig] abstract class providing required
/// implementations.
class CiIntegrationStub extends CiIntegration {
  final StorageClientStub _storageClientTestbed;
  final CiClientStub _ciClientTestbed;

  @override
  DestinationClient get destinationClient => _storageClientTestbed;

  @override
  SourceClient get sourceClient => _ciClientTestbed;

  /// Creates this stub class instance.
  ///
  /// If [storageClient] is not given, the [StorageClientStub] is created.
  /// If [ciClient] is not given, the [CiClientStub] is created.
  CiIntegrationStub({
    StorageClientStub storageClient,
    CiClientStub ciClient,
  })  : _storageClientTestbed = storageClient ?? StorageClientStub(),
        _ciClientTestbed = ciClient ?? CiClientStub();
}
