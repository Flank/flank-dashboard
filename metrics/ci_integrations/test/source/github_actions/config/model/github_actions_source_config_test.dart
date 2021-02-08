// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/github_actions_config_test_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceConfig", () {
    const workflowIdentifier = GithubActionsConfigTestData.workflowIdentifier;
    const repositoryOwner = GithubActionsConfigTestData.repositoryOwner;
    const repositoryName = GithubActionsConfigTestData.repositoryName;
    const jobName = GithubActionsConfigTestData.jobName;
    const coverageArtifactName =
        GithubActionsConfigTestData.coverageArtifactName;
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
            jobName: jobName,
            coverageArtifactName: coverageArtifactName,
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
            jobName: jobName,
            coverageArtifactName: coverageArtifactName,
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
            jobName: jobName,
            coverageArtifactName: coverageArtifactName,
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
            jobName: jobName,
            coverageArtifactName: coverageArtifactName,
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
            jobName: jobName,
            coverageArtifactName: coverageArtifactName,
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
            jobName: jobName,
            coverageArtifactName: coverageArtifactName,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given job name is null",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: repositoryOwner,
            repositoryName: repositoryName,
            jobName: null,
            coverageArtifactName: coverageArtifactName,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given job name is empty",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: repositoryOwner,
            repositoryName: repositoryName,
            jobName: '',
            coverageArtifactName: coverageArtifactName,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given coverage artifact name is null",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: repositoryOwner,
            repositoryName: repositoryName,
            jobName: jobName,
            coverageArtifactName: null,
            accessToken: accessToken,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given coverage artifact name is empty",
      () {
        expect(
          () => GithubActionsSourceConfig(
            workflowIdentifier: workflowIdentifier,
            repositoryOwner: repositoryOwner,
            repositoryName: repositoryName,
            jobName: jobName,
            coverageArtifactName: '',
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
          jobName: jobName,
          coverageArtifactName: coverageArtifactName,
          accessToken: accessToken,
        );

        expect(config.workflowIdentifier, equals(workflowIdentifier));
        expect(config.repositoryOwner, equals(repositoryOwner));
        expect(config.repositoryName, equals(repositoryName));
        expect(config.jobName, equals(jobName));
        expect(config.coverageArtifactName, equals(coverageArtifactName));
        expect(config.accessToken, equals(accessToken));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final actualConfig = GithubActionsSourceConfig.fromJson(null);

        expect(actualConfig, isNull);
      },
    );

    test(
      ".fromJson() creates a new instance from the given json",
      () {
        final actualConfig = GithubActionsSourceConfig.fromJson(configMap);

        expect(actualConfig, equals(config));
      },
    );

    test(".sourceProjectId returns the given job name value", () {
      const expected = jobName;

      final sourceProjectId = config.sourceProjectId;

      expect(sourceProjectId, equals(expected));
    });
  });
}
