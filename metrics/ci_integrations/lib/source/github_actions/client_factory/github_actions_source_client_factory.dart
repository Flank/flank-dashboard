import 'package:archive/archive.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/integration/interface/source/client_factory/source_client_factory.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_client_adapter.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/util/archive/archive_helper.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A client factory for Github Actions source integration.
///
/// Used to create instances of the [GithubActionsSourceClientAdapter]
/// using [GithubActionsSourceConfig].
class GithubActionsSourceClientFactory
    implements
        SourceClientFactory<GithubActionsSourceConfig,
            GithubActionsSourceClientAdapter> {
  /// Creates a new instance of the [GithubActionsSourceClientFactory].
  const GithubActionsSourceClientFactory();

  @override
  GithubActionsSourceClientAdapter create(GithubActionsSourceConfig config) {
    ArgumentError.checkNotNull(config, 'config');

    final zipDecoder = ZipDecoder();
    final archiveHelper = ArchiveHelper(zipDecoder);

    BearerAuthorization authorization;
    if (config.accessToken != null) {
      authorization = BearerAuthorization(config.accessToken);
    }

    final githubActionsClient = GithubActionsClient(
      repositoryOwner: config.repositoryOwner,
      repositoryName: config.repositoryName,
      authorization: authorization,
    );

    final githubActionsSourceClientAdapter = GithubActionsSourceClientAdapter(
      githubActionsClient: githubActionsClient,
      archiveHelper: archiveHelper,
      workflowIdentifier: config.workflowIdentifier,
      coverageArtifactName: config.coverageArtifactName,
    );

    return githubActionsSourceClientAdapter;
  }
}
