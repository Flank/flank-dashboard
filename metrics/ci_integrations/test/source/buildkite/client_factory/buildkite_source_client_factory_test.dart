import 'package:ci_integration/source/buildkite/client_factory/buildkite_source_client_factory.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/buildkite_config_test_data.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  final config = BuildkiteConfigTestData.sourceConfig;
  final clientFactory = BuildkiteSourceClientFactory();

  group("BuildkiteSourceClientFactory", () {
    test(".create() throws an ArgumentError if the given config is null", () {
      expect(
        () => clientFactory.create(null),
        throwsArgumentError,
      );
    });

    test(
      ".create() creates a client with the organization slug from the given config",
      () {
        final organizationSlug = config.organizationSlug;

        final adapter = clientFactory.create(config);
        final client = adapter.buildkiteClient;

        expect(client.organizationSlug, equals(organizationSlug));
      },
    );

    test(
      ".create() creates a client with the authorization credentials from the given config",
      () {
        final accessToken = config.accessToken;
        final authorization = BearerAuthorization(accessToken);

        final adapter = clientFactory.create(config);
        final client = adapter.buildkiteClient;

        expect(client.authorization, equals(authorization));
      },
    );

    test(
      ".create() creates an adapter with the Buildkite client",
      () {
        final adapter = clientFactory.create(config);

        expect(adapter.buildkiteClient, isNotNull);
      },
    );
  });
}
