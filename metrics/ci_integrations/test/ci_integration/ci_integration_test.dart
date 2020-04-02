import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/config/ci_config.dart';
import 'package:test/test.dart';

import 'test_util/testbed/ci_client_testbed.dart';
import 'test_util/testbed/storage_client_testbed.dart';

void main() {
  group("CiIntegration", () {
    final ciConfig = CiConfig(
      ciProjectId: 'ciProjectId',
      storageProjectId: 'storageProjectId',
    );

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
