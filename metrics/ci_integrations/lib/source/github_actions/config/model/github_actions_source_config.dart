import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a [SourceConfig] for the Github Actions integration.
class GithubActionsSourceConfig extends Equatable implements SourceConfig {
  /// A unique identifier of the Github Actions workflow to integrate.
  ///
  /// This is either a workflow id or a name of the file that defines
  /// the workflow.
  final String workflowIdentifier;

  /// A name of the project's repository.
  final String repositoryName;

  /// An owner of the project's repository.
  final String repositoryOwner;

  /// A Github access token.
  final String accessToken;

  @override
  String get sourceProjectId => workflowIdentifier;

  @override
  List<Object> get props =>
      [workflowIdentifier, repositoryName, repositoryOwner, accessToken];

  /// Creates a new instance of the [GithubActionsSourceConfig].
  ///
  /// Throws an [ArgumentError] if either [workflowIdentifier], [repositoryName]
  /// or [repositoryOwner] is `null` or empty.
  GithubActionsSourceConfig({
    @required this.workflowIdentifier,
    @required this.repositoryName,
    @required this.repositoryOwner,
    this.accessToken,
  }) {
    StringValidator.checkNotNullOrEmpty(
      workflowIdentifier,
      name: 'workflowIdentifier',
    );
    StringValidator.checkNotNullOrEmpty(
      repositoryName,
      name: 'repositoryName',
    );
    StringValidator.checkNotNullOrEmpty(
      repositoryOwner,
      name: 'repositoryOwner',
    );
  }

  /// Creates a new instance of the [GithubActionsSourceConfig] from the
  /// decoded JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
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
