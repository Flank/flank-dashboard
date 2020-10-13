import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/github_actions_config_test_data.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceConfig", () {
    const workflowIdentifier = GithubActionsConfigTestData.workflowIdentifier;
    const repositoryOwner = GithubActionsConfigTestData.repositoryOwner;
    const repositoryName = GithubActionsConfigTestData.repositoryName;
    const accessToken = GithubActionsConfigTestData.accessToken;

    const configMap = GithubActionsConfigTestData.sourceConfigMap;
    final config = GithubActionsConfigTestData.sourceConfig;

    test(
      "throws an ArgumentError if the given workflow identifier is null",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: null,
            repositoryOwner: repositoryOwner,
            repositoryName: repositoryName,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given workflow identifier is empty",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: '',
            repositoryOwner: repositoryOwner,
            repositoryName: repositoryName,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given repository owner is null",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: null,
            repositoryName: repositoryName,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given repository owner is empty",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: '',
            repositoryName: repositoryName,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given repository name is null",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: repositoryOwner,
            repositoryName: null,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given repository name is null",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: repositoryOwner,
            repositoryName: '',
            accessToken: accessToken,
          ),
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
      ".fromJson creates a new instance from the given json",
      () {
        final actualConfig = GithubActionsSourceConfig.fromJson(configMap);

        expect(actualConfig, equals(config));
      },
    );

    test(".sourceProjectId returns the given workflow identifier value", () {
      const expected = workflowIdentifier;

      final sourceProjectId = config.sourceProjectId;

      expect(sourceProjectId, equals(expected));
    });
  });
}
