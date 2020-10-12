import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceConfig", () {
    const workflowIdentifier = 'workflow';
    const repositoryOwner = 'owner';
    const repositoryName = 'name';
    const accessToken = 'token';

    const configJson = <String, dynamic>{
      'workflow_identifier': workflowIdentifier,
      'repository_owner': repositoryOwner,
      'repository_name': repositoryName,
      'access_token': accessToken,
    };

    final config = GithubActionsSourceConfig(
      workflowIdentifier: workflowIdentifier,
      repositoryOwner: repositoryOwner,
      repositoryName: repositoryName,
      accessToken: accessToken,
    );

    GithubActionsSourceConfig _createConfig({
      String workflowIdentifier = workflowIdentifier,
      String repositoryOwner = repositoryOwner,
      String repositoryName = repositoryName,
      String accessToken,
    }) {
      return GithubActionsSourceConfig(
        workflowIdentifier: workflowIdentifier,
        repositoryOwner: repositoryOwner,
        repositoryName: repositoryName,
        accessToken: accessToken,
      );
    }

    test(
      "throws an ArgumentError if the given workflow identifier is null",
      () {
        expect(
          () => _createConfig(workflowIdentifier: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given repository owner is null",
      () {
        expect(
          () => _createConfig(repositoryOwner: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given repository name is null",
      () {
        expect(
          () => _createConfig(repositoryName: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given values",
      () {
        final config = GithubActionsSourceConfig(
          workflowIdentifier: workflowIdentifier,
          repositoryOwner: repositoryOwner,
          repositoryName: repositoryName,
          accessToken: accessToken,
        );

        expect(config.workflowIdentifier, equals(workflowIdentifier));
        expect(config.repositoryOwner, equals(repositoryOwner));
        expect(config.repositoryName, equals(repositoryName));
        expect(config.accessToken, equals(accessToken));
      },
    );

    test(
      ".fromJson returns null if the given json is null",
      () {
        final actualConfig = GithubActionsSourceConfig.fromJson(null);

        expect(actualConfig, isNull);
      },
    );

    test(
      ".fromJson creates an instance from the given json",
      () {
        final actualConfig = GithubActionsSourceConfig.fromJson(configJson);

        expect(actualConfig, equals(config));
      },
    );
  });
}
