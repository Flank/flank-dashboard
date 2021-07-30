// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/validation/model/config_field_target_validation_result.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_validation_target.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A [ValidationDelegate] for the Buildkite source integration.
class BuildkiteSourceValidationDelegate implements ValidationDelegate {
  /// A [List] containing all required [BuildkiteTokenScope]s.
  static const List<BuildkiteTokenScope> _requiredTokenScopes = [
    BuildkiteTokenScope.readBuilds,
  ];

  /// A [BuildkiteClient] used to perform calls to the Buildkite API.
  final BuildkiteClient _client;

  /// Creates an instance of the [BuildkiteSourceValidationDelegate].
  ///
  /// Throws an [ArgumentError] if the given [BuildkiteClient] is `null`.
  BuildkiteSourceValidationDelegate(this._client) {
    ArgumentError.checkNotNull(_client);
  }

  /// Validates the given [auth].
  Future<ConfigFieldTargetValidationResult<BuildkiteToken>> validateAuth(
    AuthorizationBase auth,
  ) async {
    final tokenInteraction = await _client.fetchToken(auth);

    if (tokenInteraction.isError || tokenInteraction.result == null) {
      return const ConfigFieldTargetValidationResult.failure(
        target: BuildkiteSourceValidationTarget.accessToken,
        description: BuildkiteStrings.tokenInvalid,
      );
    }

    final token = tokenInteraction.result;
    final tokenScopes = token.scopes ?? [];

    final containsRequiredScopes = _requiredTokenScopes.every(
      (element) => tokenScopes.contains(element),
    );
    if (!containsRequiredScopes) {
      return const ConfigFieldTargetValidationResult.failure(
        target: BuildkiteSourceValidationTarget.accessToken,
        description: BuildkiteStrings.tokenDoesNotHaveReadBuildsScope,
      );
    }

    final containsScopesToReadArtifacts = tokenScopes.contains(
      BuildkiteTokenScope.readArtifacts,
    );
    if (!containsScopesToReadArtifacts) {
      return ConfigFieldTargetValidationResult.success(
        target: BuildkiteSourceValidationTarget.accessToken,
        description: BuildkiteStrings.tokenDoesNotHaveReadArtifactsScope,
        data: token,
      );
    }

    return ConfigFieldTargetValidationResult.success(
      target: BuildkiteSourceValidationTarget.accessToken,
      data: token,
    );
  }

  /// Validates the given [pipelineSlug].
  Future<ConfigFieldTargetValidationResult<void>> validatePipelineSlug(
    String pipelineSlug,
  ) async {
    final pipelineInteraction = await _client.fetchPipeline(pipelineSlug);

    if (pipelineInteraction.isError || pipelineInteraction.result == null) {
      return const ConfigFieldTargetValidationResult.failure(
        target: BuildkiteSourceValidationTarget.pipelineSlug,
        description: BuildkiteStrings.pipelineNotFound,
      );
    }

    return const ConfigFieldTargetValidationResult.success(
      target: BuildkiteSourceValidationTarget.pipelineSlug,
    );
  }

  /// Validates the given [organizationSlug].
  Future<ConfigFieldTargetValidationResult<void>> validateOrganizationSlug(
    String organizationSlug,
  ) async {
    final organizationInteraction = await _client.fetchOrganization(
      organizationSlug,
    );

    if (organizationInteraction.isError ||
        organizationInteraction.result == null) {
      return const ConfigFieldTargetValidationResult.failure(
        target: BuildkiteSourceValidationTarget.organizationSlug,
        description: BuildkiteStrings.organizationNotFound,
      );
    }

    return const ConfigFieldTargetValidationResult.success(
      target: BuildkiteSourceValidationTarget.organizationSlug,
    );
  }
}
