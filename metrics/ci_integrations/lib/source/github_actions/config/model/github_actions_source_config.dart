import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents the Github Actions source config.
class GithubActionsSourceConfig extends Equatable implements SourceConfig {
  /// An identifier that is either a workflow id or a name of the file
  /// that defines the workflow.
  final String workflowIdentifier;

  /// A name of the project's repository.
  final String repositoryName;

  /// An owner of the project's repository.
  final String repositoryOwner;

  /// A Github access token.
  final String accessToken;

  @override
  List<Object> get props =>
      [workflowIdentifier, repositoryName, repositoryOwner, accessToken];

  @override
  String get sourceProjectId => workflowIdentifier;

  /// Creates a new instance of the [GithubActionsSourceConfig].
  ///
  /// Throws an [ArgumentError] if either [workflowIdentifier], [repositoryName]
  /// or [repositoryOwner] is `null` or empty.
  GithubActionsSourceConfig({
    @required this.workflowIdentifier,
    @required this.repositoryOwner,
    @required this.repositoryName,
    this.accessToken,
  }) {
    StringValidator.checkNotNullOrEmpty(
      workflowIdentifier,
      name: 'workflowIdentifier',
    );
    StringValidator.checkNotNullOrEmpty(
      repositoryOwner,
      name: 'repositoryOwner',
    );
    StringValidator.checkNotNullOrEmpty(
      repositoryName,
      name: 'repositoryName',
    );
  }

  /// Creates [GithubActionsSourceConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory GithubActionsSourceConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return GithubActionsSourceConfig(
      workflowIdentifier: json['workflow_identifier'] as String,
      repositoryOwner: json['repository_owner'] as String,
      repositoryName: json['repository_name'] as String,
      accessToken: json['access_token'] as String,
    );
  }
}
