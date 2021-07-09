// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [GithubActionsSourceConfig]'s fields.
class GithubActionsSourceValidationTarget {
  /// A workflow identifier field of the [GithubActionsSourceConfig].
  static const workflowIdentifier = ValidationTarget(
    name: 'workflow_identifier',
  );

  /// A repository name field of the [GithubActionsSourceConfig].
  static const repositoryName = ValidationTarget(name: 'repository_name');

  /// A repository owner field of the [GithubActionsSourceConfig].
  static const repositoryOwner = ValidationTarget(name: 'repository_owner');

  /// An access token field of the [GithubActionsSourceConfig].
  static const accessToken = ValidationTarget(name: 'access_token');

  /// A job name field of the [GithubActionsSourceConfig].
  static const jobName = ValidationTarget(name: 'job_name');

  /// A coverage artifact name field of the [GithubActionsSourceConfig].
  static const coverageArtifactName = ValidationTarget(
    name: 'coverage_artifact_name',
  );

  /// A list containing all [ValidationTarget]s of
  /// the [GithubActionsSourceConfig].
  static final List<ValidationTarget> values = UnmodifiableListView([
    accessToken,
    workflowIdentifier,
    repositoryName,
    repositoryOwner,
    jobName,
    coverageArtifactName,
  ]);
}
