import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';

/// A class containing a test data for the [GithubActionsSourceConfig].
class GithubActionsConfigTestData {
  /// A unique identifier for the workflow to use in tests.
  static const workflowIdentifier = 'workflow';

  /// An owner of the project's repository to use in tests.
  static const repositoryOwner = 'owner';

  /// A name of the project's repository to use in tests.
  static const repositoryName = 'name';

  /// An access token to use in tests.
  static const accessToken = 'token';

  /// A decoded JSON object with Github Action test configurations.
  static const Map<String, dynamic> sourceConfigMap = {
    'workflow_identifier': workflowIdentifier,
    'repository_owner': repositoryOwner,
    'repository_name': repositoryName,
    'access_token': accessToken,
  };

  /// A source config to use in tests.
  static final sourceConfig = GithubActionsSourceConfig(
    workflowIdentifier: workflowIdentifier,
    repositoryOwner: repositoryOwner,
    repositoryName: repositoryName,
    accessToken: accessToken,
  );
}
