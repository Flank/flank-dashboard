import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../cli/test_util/test_data/config_test_data.dart';
import 'test_utils/stub/destination_client_stub.dart';
import 'test_utils/stub/source_client_stub.dart';
import 'test_utils/test_data/builds_test_data.dart';

void main() {
  group("CiIntegration", () {
    final syncConfig = ConfigTestData.syncConfig;

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
      ".sync() returns an error if a source client throws fetching all builds",
      () async {
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
        final result = await ciIntegration.sync(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".sync() returns an error if a source client throws fetching the builds after the given one",
      () async {
        final sourceClient = SourceClientStub(
          fetchBuildsAfterCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(sourceClient: sourceClient);
        final result = await ciIntegration.sync(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".sync() returns an error if a destination client throws fetching the last build",
      () async {
        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(
          destinationClient: destinationClient,
        );
        final result = await ciIntegration.sync(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".sync() returns an error if a destination client throws adding new builds",
      () async {
        final destinationClient = DestinationClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        );
        final ciIntegration = CiIntegrationStub(
          destinationClient: destinationClient,
        );
        final result = await ciIntegration.sync(syncConfig);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".sync() ignores empty list of new builds and not call adding builds",
      () async {
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
        final result = await ciIntegration.sync(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".sync() synchronizes builds",
      () async {
        final ciIntegration = CiIntegrationStub();
        final result = await ciIntegration.sync(syncConfig);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".sync() does not fetch coverage for builds if the coverage value is false in the given config",
      () async {
        bool isCalled = false;

        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => null,
        );

        final sourceClientStub = SourceClientStub(
          fetchCoverageCallback: (_) {
            isCalled = true;

            return Future.value(Percent(0.7));
          },
        );

        final ciIntegration = CiIntegrationStub(
          sourceClient: sourceClientStub,
          destinationClient: destinationClient,
        );

        final result = await ciIntegration
            .sync(syncConfig)
            .then((result) => result.isSuccess);

        expect(result, isTrue);
        expect(isCalled, isFalse);
      },
    );

    test(
      ".sync() fetches coverage for each build if the coverage value is true in the given config",
      () async {
        final syncConfig = SyncConfig(
          sourceProjectId: 'test',
          destinationProjectId: 'test',
          coverage: true,
          initialSyncLimit: 10,
        );

        int calledTimes = 0;

        final destinationClient = DestinationClientStub(
          fetchLastBuildCallback: (_) => null,
        );

        final sourceClientStub = SourceClientStub(
          fetchCoverageCallback: (_) {
            calledTimes += 1;

            return Future.value(Percent(0.7));
          },
        );

        final ciIntegration = CiIntegrationStub(
          sourceClient: sourceClientStub,
          destinationClient: destinationClient,
        );

        final result = await ciIntegration
            .sync(syncConfig)
            .then((result) => result.isSuccess);

        expect(result, isTrue);
        expect(calledTimes, equals(BuildsTestData.builds.length));
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
