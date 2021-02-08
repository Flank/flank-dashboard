// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/github_actions/client_factory/github_actions_source_client_factory.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/github_actions_config_test_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  final config = GithubActionsConfigTestData.sourceConfig;
  const clientFactory = GithubActionsSourceClientFactory();

  group("GithubActionSourceClientFactory", () {
    test(
      ".create() throws an ArgumentError if the given config is null",
      () {
        expect(
          () => clientFactory.create(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() creates a client with the repository owner from the given config",
      () {
        final repositoryOwner = config.repositoryOwner;

        final adapter = clientFactory.create(config);
        final client = adapter.githubActionsClient;

        expect(client.repositoryOwner, equals(repositoryOwner));
      },
    );

    test(
      ".create() creates a client with the repository name from the given config",
      () {
        final repositoryName = config.repositoryName;

        final adapter = clientFactory.create(config);
        final client = adapter.githubActionsClient;

        expect(client.repositoryName, equals(repositoryName));
      },
    );

    test(
      ".create() creates a client with the authorization credentials from the given config",
      () {
        final accessToken = config.accessToken;
        final authorization = BearerAuthorization(accessToken);

        final adapter = clientFactory.create(config);
        final client = adapter.githubActionsClient;

        expect(client.authorization, equals(authorization));
      },
    );

    test(
      ".create() creates a client without the authorization if the config doesn't contain the access token",
      () {
        final config = GithubActionsSourceConfig(
          repositoryName: 'name',
          repositoryOwner: 'owner',
          workflowIdentifier: 'id',
          jobName: 'name',
          coverageArtifactName: 'name',
          accessToken: null,
        );

        final adapter = clientFactory.create(config);
        final client = adapter.githubActionsClient;

        expect(client.authorization, isNull);
      },
    );

    test(
      ".create() creates an adapter with the workflow identifier from the given config",
      () {
        final workflowIdentifier = config.workflowIdentifier;

        final adapter = clientFactory.create(config);

        expect(adapter.workflowIdentifier, equals(workflowIdentifier));
      },
    );

    test(
      ".create() creates an adapter with the coverage artifact name from the given config",
      () {
        final coverageArtifactName = config.coverageArtifactName;

        final adapter = clientFactory.create(config);

        expect(adapter.coverageArtifactName, equals(coverageArtifactName));
      },
    );

    test(
      ".create() creates an adapter with the Github Actions client",
      () {
        final adapter = clientFactory.create(config);

        expect(adapter.githubActionsClient, isNotNull);
      },
    );

    test(
      ".create() creates an adapter with the archive helper",
      () {
        final adapter = clientFactory.create(config);

        expect(adapter.archiveHelper, isNotNull);
      },
    );
  });
}
