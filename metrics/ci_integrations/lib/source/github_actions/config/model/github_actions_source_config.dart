// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a [SourceConfig] for the Github Actions integration.
class GithubActionsSourceConfig extends Equatable implements SourceConfig {
  /// An owner of the project's repository.
  final String repositoryOwner;

  /// A name of the project's repository.
  final String repositoryName;

  /// A unique identifier of the Github Actions workflow to integrate.
  ///
  /// This is either a workflow id or a name of the file that defines
  /// the workflow.
  final String workflowIdentifier;

  /// A name of the Github Actions workflow job associated with the repository
  /// project to use in integration.
  ///
  /// This name must uniquely identify a job among other jobs within the workflow.
  final String jobName;

  /// A name of the artifact that contains a coverage data for a single run
  /// of the job.
  final String coverageArtifactName;

  /// A Github access token.
  final String accessToken;

  @override
  String get sourceProjectId => jobName;

  @override
  List<Object> get props => [
        workflowIdentifier,
        repositoryName,
        repositoryOwner,
        jobName,
        coverageArtifactName,
        accessToken,
      ];

  /// Creates a new instance of the [GithubActionsSourceConfig].
  ///
  /// Throws an [ArgumentError] if one of the required parameters
  /// is `null` or empty.
  GithubActionsSourceConfig({
    @required this.repositoryOwner,
    @required this.repositoryName,
    @required this.workflowIdentifier,
    @required this.jobName,
    @required this.coverageArtifactName,
    this.accessToken,
  }) {
    StringValidator.checkNotNullOrEmpty(
      repositoryOwner,
      name: 'repositoryOwner',
    );
    StringValidator.checkNotNullOrEmpty(repositoryName, name: 'repositoryName');
    StringValidator.checkNotNullOrEmpty(
      workflowIdentifier,
      name: 'workflowIdentifier',
    );
    StringValidator.checkNotNullOrEmpty(jobName, name: 'jobName');
    StringValidator.checkNotNullOrEmpty(
      coverageArtifactName,
      name: 'coverageArtifactName',
    );
  }

  /// Creates a new instance of the [GithubActionsSourceConfig] from the
  /// decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory GithubActionsSourceConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return GithubActionsSourceConfig(
      repositoryOwner: json['repository_owner'] as String,
      repositoryName: json['repository_name'] as String,
      workflowIdentifier: json['workflow_identifier'] as String,
      jobName: json['job_name'] as String,
      coverageArtifactName: json['coverage_artifact_name'] as String,
      accessToken: json['access_token'] as String,
    );
  }
}
