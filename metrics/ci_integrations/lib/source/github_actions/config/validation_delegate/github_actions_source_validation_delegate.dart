// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/github_token.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// A [ValidationDelegate] for the Github Actions source integration.
class GithubActionsSourceValidationDelegate implements ValidationDelegate {
  /// A [List] containing all required [GithubTokenScope]s.
  static const List<GithubTokenScope> _requiredTokenScopes = [
    GithubTokenScope.repo,
  ];

  /// A [GithubActionsClient] used to perform calls to the Github Actions API.
  final GithubActionsClient _client;

  /// Creates an instance of the [GithubActionsSourceValidationDelegate].
  ///
  /// Throws an [ArgumentError] if the given [GithubActionsClient] is `null`.
  GithubActionsSourceValidationDelegate(this._client) {
    ArgumentError.checkNotNull(_client);
  }

  /// Validates the given [auth].
  Future<InteractionResult<GithubToken>> validateAuth(
    AuthorizationBase auth,
  ) async {
    final interaction = await _client.fetchToken(auth);

    if (_isInteractionFailed(interaction)) {
      return const InteractionResult.error(
        message: GithubActionsStrings.tokenInvalid,
      );
    }

    final token = interaction.result;
    final tokenScopes = token.scopes ?? [];

    final missingRequiredScopes = _requiredTokenScopes.where(
      (scope) => !tokenScopes.contains(scope),
    );

    if (missingRequiredScopes.isNotEmpty) {
      const mapper = GithubTokenScopeMapper();
      final missingRequiredScopesList =
          missingRequiredScopes.map((scope) => mapper.unmap(scope)).toList();

      return InteractionResult.error(
        message: GithubActionsStrings.tokenMissingScopes(
          missingRequiredScopesList.join(', '),
        ),
      );
    }

    return interaction;
  }

  /// Validates the given [repositoryOwner].
  Future<InteractionResult<void>> validateRepositoryOwner(
    String repositoryOwner,
  ) async {
    final repositoryOwnerInteraction = await _client.fetchGithubUser(
      repositoryOwner,
    );

    if (_isInteractionFailed(repositoryOwnerInteraction)) {
      return const InteractionResult.error(
        message: GithubActionsStrings.repositoryOwnerNotFound,
      );
    }

    return const InteractionResult.success();
  }

  /// Validates the given [repositoryName].
  Future<InteractionResult<void>> validateRepositoryName({
    String repositoryName,
    String repositoryOwner,
  }) async {
    final repositoryInteraction = await _client.fetchGithubRepository(
      repositoryName: repositoryName,
      repositoryOwner: repositoryOwner,
    );

    if (_isInteractionFailed(repositoryInteraction)) {
      return const InteractionResult.error(
        message: GithubActionsStrings.repositoryNotFound,
      );
    }

    return const InteractionResult.success();
  }

  /// Validates the given [workflowId].
  Future<InteractionResult<void>> validateWorkflowId(
    String workflowId,
  ) async {
    final workflowInteraction = await _client.fetchWorkflow(workflowId);

    if (_isInteractionFailed(workflowInteraction)) {
      return const InteractionResult.error(
        message: GithubActionsStrings.workflowNotFound,
      );
    }

    return const InteractionResult.success();
  }

  /// Validates the given [jobName].
  Future<InteractionResult> validateJobName({
    String workflowId,
    String jobName,
  }) async {
    final workflowRunsInteraction = await _fetchWorkflowRunsPage(
      workflowId,
    );

    if (workflowRunsInteraction.isError) return workflowRunsInteraction;

    final workflowRuns = workflowRunsInteraction.result.values;
    final workflowRunId = workflowRuns.first?.id;

    final jobsInteraction = await _client.fetchRunJobs(workflowRunId);

    if (_isInteractionFailed(jobsInteraction)) {
      return const InteractionResult.error(
        message: GithubActionsStrings.noJobsToValidateJobName,
      );
    }

    final jobs = jobsInteraction.result.values;
    final containsJob = jobs.any((job) => job.name == jobName);

    if (!containsJob) {
      return const InteractionResult.error(
        message: GithubActionsStrings.jobNameInvalid,
      );
    }

    return const InteractionResult.success();
  }

  /// Validates the given [coverageArtifactName].
  Future<InteractionResult> validateCoverageArtifactName({
    String workflowId,
    String coverageArtifactName,
  }) async {
    final workflowRunsInteraction = await _fetchWorkflowRunsPage(
      workflowId,
    );

    if (workflowRunsInteraction.isError) return workflowRunsInteraction;

    final workflowRuns = workflowRunsInteraction.result.values;
    final workflowRunId = workflowRuns.first?.id;

    final artifactsInteraction = await _client.fetchRunArtifacts(workflowRunId);

    if (_isInteractionFailed(artifactsInteraction)) {
      return const InteractionResult.error(
        message: GithubActionsStrings.noArtifactsToValidateName,
      );
    }

    final artifacts = artifactsInteraction.result.values;

    final containsCoverageArtifact = artifacts.any(
      (artifact) => artifact.name == coverageArtifactName,
    );

    if (!containsCoverageArtifact) {
      return const InteractionResult.error(
        message: GithubActionsStrings.coverageArtifactNameInvalid,
      );
    }

    return const InteractionResult.success();
  }

  /// Fetches a [WorkflowRunsPage] with a list of [WorkflowRun]s.
  Future<InteractionResult<WorkflowRunsPage>> _fetchWorkflowRunsPage(
    String workflowId,
  ) async {
    final workflowRunsInteraction = await _client.fetchWorkflowRuns(
      workflowId,
      status: GithubActionStatus.completed,
      page: 1,
      perPage: 1,
    );

    if (_isInteractionFailed(workflowRunsInteraction)) {
      return const InteractionResult.error(
        message: GithubActionsStrings.workflowIdentifierInvalid,
      );
    }

    final workflowRuns = workflowRunsInteraction.result?.values ?? [];

    if (workflowRuns.isEmpty) {
      return const InteractionResult.error(
        message: GithubActionsStrings.noWorkflowRunsToValidateJobName,
      );
    }

    return workflowRunsInteraction;
  }

  /// Determines whether the given [interactionResult] is failed or not.
  bool _isInteractionFailed(InteractionResult interactionResult) {
    return interactionResult.isError || interactionResult.result == null;
  }
}
