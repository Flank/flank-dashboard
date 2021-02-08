// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';

/// A class containing a test data for the [GithubActionsSourceConfig].
class GithubActionsConfigTestData {
  /// A unique identifier for the workflow to use in tests.
  static const String workflowIdentifier = 'workflow';

  /// An owner of the project's repository to use in tests.
  static const String repositoryOwner = 'owner';

  /// A name of the project's repository to use in tests.
  static const String repositoryName = 'name';

  /// A name of the workflow's job to use in tests.
  static const String jobName = 'job-name';

  /// A name of an artifact with coverage data.
  static const String coverageArtifactName = 'job_coverage.json';

  /// An access token to use in tests.
  static const String accessToken = 'token';

  /// A decoded JSON object with Github Action test configurations.
  static const Map<String, dynamic> sourceConfigMap = {
    'repository_owner': repositoryOwner,
    'repository_name': repositoryName,
    'workflow_identifier': workflowIdentifier,
    'job_name': jobName,
    'coverage_artifact_name': coverageArtifactName,
    'access_token': accessToken,
  };

  /// A source config to use in tests.
  static final sourceConfig = GithubActionsSourceConfig(
    repositoryOwner: repositoryOwner,
    repositoryName: repositoryName,
    workflowIdentifier: workflowIdentifier,
    jobName: jobName,
    coverageArtifactName: coverageArtifactName,
    accessToken: accessToken,
  );
}
