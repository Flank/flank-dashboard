import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/interface/source/config/validation_delegate/source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_validation_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// A validation delegate for the Buildkite source integration.
class BuildkiteSourceValidationDelegate implements SourceValidationDelegate {
  /// A [List] containing all required [BuildkiteTokenScope]s
  /// to use in validation.
  static const List<BuildkiteTokenScope> _requiredTokenScopes = [
    BuildkiteTokenScope.readBuilds,
  ];

  /// A [BuildkiteClient] of this validation delegate.
  final BuildkiteClient _client;

  /// Creates an instance of the [BuildkiteSourceValidationDelegate]
  BuildkiteSourceValidationDelegate(this._client) {
    ArgumentError.checkNotNull(_client);
  }

  @override
  Future<InteractionResult<BuildkiteToken>> validateAuth(
    AuthorizationBase auth,
  ) async {
    final tokenInteraction = await _client.fetchToken(auth);

    if (tokenInteraction.isError || tokenInteraction.result == null) {
      return const InteractionResult.error(
        message: BuildkiteValidationStrings.tokenInvalid,
      );
    }

    final token = tokenInteraction.result;
    final tokenScopes = token.scopes ?? [];

    final containsRequiredScopes = _requiredTokenScopes.every(
      (element) => tokenScopes.contains(element),
    );

    if (!containsRequiredScopes) {
      return const InteractionResult.error(
        message: BuildkiteValidationStrings.tokenDoesNotHaveReadBuildsScope,
      );
    }

    return tokenInteraction;
  }

  @override
  Future<InteractionResult<BuildkitePipeline>> validateSourceProjectId(
    String pipelineSlug,
  ) async {
    final pipelineInteraction = await _client.fetchPipeline(pipelineSlug);

    if (pipelineInteraction.isError || pipelineInteraction.result == null) {
      return const InteractionResult.error(
        message: BuildkiteValidationStrings.pipelineNotFound,
      );
    }

    return pipelineInteraction;
  }

  /// Validates the given [organizationSlug].
  Future<InteractionResult<BuildkiteOrganization>> validateOrganization(
    String organizationSlug,
  ) async {
    final organizationInteraction = await _client.fetchOrganization(
      organizationSlug,
    );

    if (organizationInteraction.isError ||
        organizationInteraction.result == null) {
      return const InteractionResult.error(
        message: BuildkiteValidationStrings.organizationNotFound,
      );
    }

    return organizationInteraction;
  }
}
