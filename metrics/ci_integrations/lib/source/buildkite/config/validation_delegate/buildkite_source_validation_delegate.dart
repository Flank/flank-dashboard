import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/integration/interface/source/config/validation_delegate/source_validation_delegate.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// A validation delegate for the Buildkite source integration.
class BuildkiteSourceValidationDelegate implements SourceValidationDelegate {
  /// A [BuildkiteClient] of this validation delegate.
  final BuildkiteClient _client;

  /// Creates an instance of the [BuildkiteSourceValidationDelegate]
  BuildkiteSourceValidationDelegate(this._client) {
    ArgumentError.checkNotNull(_client);
  }

  @override
  Future<InteractionResult<BuildkiteToken>> validateAuth(
    AuthorizationBase auth,
  ) {
    return _client.fetchToken(auth);
  }

  @override
  Future<InteractionResult<BuildkitePipeline>> validateSourceProjectId(
    String pipelineSlug,
  ) {
    return _client.fetchPipeline(pipelineSlug);
  }

  /// Validates the given [organizationSlug].
  Future<InteractionResult<BuildkiteOrganization>> validateOrganization(
    String organizationSlug,
  ) {
    return _client.fetchOrganization(organizationSlug);
  }
}
