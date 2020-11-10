import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:test/test.dart';

import 'test_utils/stub/destination_client_stub.dart';
import 'test_utils/stub/source_client_stub.dart';

void main() {
  group("CiIntegration", () {
    final syncConfig = SyncConfig(
      sourceProjectId: 'sourceProjectId',
      destinationProjectId: 'destinationProjectId',
    );

    test(
      "throws an ArgumentError if the given source client is null",
      () {
        expect(
          () => CiIntegration(
            sourceClient: null,
            destinationClient: DestinationClientStub(),
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given destination client is null",
      () {
        expect(
          () => CiIntegration(
            sourceClient: SourceClientStub(),
            destinationClient: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".sync() throws an ArgumentError if the given config is null",
      () {
        final ciIntegration = CiIntegration(
          sourceClient: SourceClientStub(),
          destinationClient: DestinationClientStub(),
        );

        expect(() => ciIntegration.sync(null), throwsArgumentError);
      },
    );

    test(
      ".sync() results with an error if a source client throws fetching all builds",
      () {
        final sourceClient = SourceClientStub(
          fetchBuildsCallback: (_) => throw UnimplementedError(),
        );
        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => null,
        );
        final ciIntegration = CiIntegration(
          sourceClient: sourceClient,
          destinationClient: destinationClient,
        );
        final result =
            ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() results with an error if a source client throws fetching the builds after the given one",
      () {
        final sourceClient = SourceClientStub(
          fetchBuildsAfterCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(sourceClient: sourceClient);
        final result =
            ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() results with an error if a destination client throws fetching the last build",
      () {
        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(
          destinationClient: destinationClient,
        );
        final result =
            ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() results with an error if a destination client throws adding new builds",
      () {
        final destinationClient = DestinationClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(
          destinationClient: destinationClient,
        );
        final result =
            ciIntegration.sync(syncConfig).then((res) => res.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() ignores empty list of new builds and not call adding builds",
      () {
        final sourceClient = SourceClientStub(
          fetchBuildsAfterCallback: (_, __) => Future.value([]),
        );
        final destinationClient = DestinationClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegration(
          sourceClient: sourceClient,
          destinationClient: destinationClient,
        );
        final result =
            ciIntegration.sync(syncConfig).then((res) => res.isSuccess);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".sync() synchronizes builds",
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
  final DestinationClientStub _destinationClientTestbed;
  final SourceClientStub _sourceClientTestbed;

  @override
  DestinationClient get destinationClient => _destinationClientTestbed;

  @override
  SourceClient get sourceClient => _sourceClientTestbed;

  /// Creates this stub class instance.
  ///
  /// If [destinationClient] is not given, the [DestinationClientStub] is created.
  /// If [sourceClient] is not given, the [SourceClientStub] is created.
  CiIntegrationStub({
    DestinationClientStub destinationClient,
    SourceClientStub sourceClient,
  })  : _destinationClientTestbed =
            destinationClient ?? DestinationClientStub(),
        _sourceClientTestbed = sourceClient ?? SourceClientStub();
}
