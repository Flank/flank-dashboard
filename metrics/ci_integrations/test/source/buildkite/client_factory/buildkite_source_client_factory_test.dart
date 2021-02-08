// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/buildkite/client_factory/buildkite_source_client_factory.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/buildkite_config_test_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  final config = BuildkiteConfigTestData.sourceConfig;
  const clientFactory = BuildkiteSourceClientFactory();

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
