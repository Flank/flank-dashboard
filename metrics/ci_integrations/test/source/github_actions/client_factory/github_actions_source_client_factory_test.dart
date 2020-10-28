import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/source/github_actions/client_factory/github_actions_source_client_factory.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/github_actions_config_test_data.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  final githubActionsSourceConfig = GithubActionsConfigTestData.sourceConfig;
  final githubActionsSourceClientFactory = GithubActionsSourceClientFactory();

  GithubActionsClient createClient(GithubActionsSourceConfig config) {
    final adapter = githubActionsSourceClientFactory.create(config);
    return adapter.githubActionsClient;
  }

  group("GithubActionSourceClientFactory", () {
    test(
      ".create() throws an ArgumentError if the given config is null",
      () {
        expect(
          () => githubActionsSourceClientFactory.create(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() creates a client with the repository owner from the given config",
      () {
        final repositoryOwner = githubActionsSourceConfig.repositoryOwner;

        final client = createClient(githubActionsSourceConfig);

        expect(client.repositoryOwner, equals(repositoryOwner));
      },
    );

    test(
      ".create() creates a client with the repository name from the given config",
      () {
        final repositoryName = githubActionsSourceConfig.repositoryName;

        final client = createClient(githubActionsSourceConfig);

        expect(client.repositoryName, equals(repositoryName));
      },
    );

    test(
      ".create() creates a client with the authorization credentials from the given config",
      () {
        final accessToken = githubActionsSourceConfig.accessToken;
        final authorization = BearerAuthorization(accessToken);

        final client = createClient(githubActionsSourceConfig);

        expect(client.authorization, authorization);
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

        final client = createClient(config);

        expect(client.authorization, isNull);
      },
    );

    test(
      ".create() creates an adapter with the workflow identifier from the given config",
      () {
        final workflowIdentifier = githubActionsSourceConfig.workflowIdentifier;

        final adapter =
            githubActionsSourceClientFactory.create(githubActionsSourceConfig);

        expect(adapter.workflowIdentifier, equals(workflowIdentifier));
      },
    );

    test(
      ".create() creates an adapter with the coverage artifact name from the given config",
      () {
        final coverageArtifactName =
            githubActionsSourceConfig.coverageArtifactName;

        final adapter =
            githubActionsSourceClientFactory.create(githubActionsSourceConfig);

        expect(adapter.coverageArtifactName, equals(coverageArtifactName));
      },
    );

    test(
      ".create() creates an adapter with the Github Actions client",
      () {
        final adapter =
            githubActionsSourceClientFactory.create(githubActionsSourceConfig);

        expect(adapter.githubActionsClient, isNotNull);
      },
    );

    test(
      ".create() creates an adapter with the archive helper",
      () {
        final adapter =
            githubActionsSourceClientFactory.create(githubActionsSourceConfig);

        expect(adapter.archiveHelper, isNotNull);
      },
    );
  });
}
