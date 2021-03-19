// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
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
  Future<FieldValidationResult<void>> validateAuth(
    AuthorizationBase auth,
  ) async {
    final interaction = await _client.fetchToken(auth);

    if (_isInteractionFailed(interaction)) {
      return const FieldValidationResult.failure(
        additionalContext: GithubActionsStrings.tokenInvalid,
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

      return FieldValidationResult.failure(
        additionalContext: GithubActionsStrings.tokenMissingScopes(
          missingRequiredScopesList.join(', '),
        ),
      );
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given [repositoryOwner].
  Future<FieldValidationResult<void>> validateRepositoryOwner(
    String repositoryOwner,
  ) async {
    final repositoryOwnerInteraction = await _client.fetchGithubUser(
      repositoryOwner,
    );

    if (_isInteractionFailed(repositoryOwnerInteraction)) {
      return const FieldValidationResult.failure(
        additionalContext: GithubActionsStrings.repositoryOwnerNotFound,
      );
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given [repositoryName].
  Future<FieldValidationResult<void>> validateRepositoryName({
    String repositoryName,
    String repositoryOwner,
  }) async {
    final repositoryInteraction = await _client.fetchGithubRepository(
      repositoryName: repositoryName,
      repositoryOwner: repositoryOwner,
    );

    if (_isInteractionFailed(repositoryInteraction)) {
      return const FieldValidationResult.failure(
        additionalContext: GithubActionsStrings.repositoryNotFound,
      );
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given [workflowId].
  Future<FieldValidationResult<void>> validateWorkflowId(
    String workflowId,
  ) async {
    final workflowInteraction = await _client.fetchWorkflow(workflowId);

    if (_isInteractionFailed(workflowInteraction)) {
      return const FieldValidationResult.failure(
        additionalContext: GithubActionsStrings.workflowNotFound,
      );
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given [jobName].
  Future<FieldValidationResult<void>> validateJobName({
    String workflowId,
    String jobName,
  }) async {
    final interaction = await _client.fetchWorkflowRuns(
      workflowId,
      status: GithubActionStatus.completed,
      page: 1,
      perPage: 1,
    );

    if (_isInteractionFailed(interaction)) {
      return const FieldValidationResult.unknown(
        additionalContext: GithubActionsStrings.workflowIdentifierInvalid,
      );
    }

    final workflowRuns = interaction.result.values ?? [];

    if (workflowRuns.isEmpty) {
      return const FieldValidationResult.unknown(
        additionalContext: GithubActionsStrings.noCompletedWorkflowRuns,
      );
    }

    final jobsInteraction = await _fetchJob(workflowRuns.first, jobName);

    if (jobsInteraction.isError) {
      return const FieldValidationResult.unknown(
        additionalContext: GithubActionsStrings.jobsFetchingFailed,
      );
    }

    final job = jobsInteraction.result;

    if (job == null) {
      return const FieldValidationResult.failure(
        additionalContext: GithubActionsStrings.jobNameInvalid,
      );
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given [coverageArtifactName].
  Future<FieldValidationResult<void>> validateCoverageArtifactName({
    String workflowId,
    String coverageArtifactName,
  }) async {
    final interaction = await _client.fetchWorkflowRunsWithConclusion(
      workflowId,
      conclusion: GithubActionConclusion.success,
      page: 1,
      perPage: 1,
    );

    if (_isInteractionFailed(interaction)) {
      return const FieldValidationResult.unknown(
        additionalContext: GithubActionsStrings.workflowIdentifierInvalid,
      );
    }

    final workflowRuns = interaction.result.values ?? [];

    if (workflowRuns.isEmpty) {
      return const FieldValidationResult.unknown(
        additionalContext: GithubActionsStrings.noSuccessfulWorkflowRuns,
      );
    }

    final artifactsInteraction = await _fetchCoverageArtifact(
      workflowRuns.first,
      coverageArtifactName,
    );

    if (artifactsInteraction.isError) {
      return const FieldValidationResult.unknown(
        additionalContext: GithubActionsStrings.artifactsFetchingFailed,
      );
    }

    final artifact = artifactsInteraction.result;

    if (artifact == null) {
      return const FieldValidationResult.failure(
        additionalContext: GithubActionsStrings.coverageArtifactNameInvalid,
      );
    }

    return const FieldValidationResult.success();
  }

  /// Fetches a [WorkflowRunJob] for the given [workflowRun]
  /// by the [jobName].
  Future<InteractionResult<WorkflowRunJob>> _fetchJob(
    WorkflowRun workflowRun,
    String jobName,
  ) async {
    final runJobInteraction = await _client.fetchRunJobs(workflowRun.id);

    if (_isInteractionFailed(runJobInteraction)) {
      return const InteractionResult.error();
    }

    WorkflowRunJobsPage page = runJobInteraction.result;
    WorkflowRunJob job;
    bool hasNext;

    do {
      final jobs = page.values;

      job = jobs.firstWhere(
        (job) => job.name == jobName,
        orElse: () => null,
      );

      hasNext = page.hasNextPage && job == null;

      if (hasNext) {
        final interaction = await _client.fetchRunJobsNext(page);

        if (_isInteractionFailed(interaction)) {
          return const InteractionResult.error();
        }

        page = interaction.result;
      }
    } while (hasNext);

    return InteractionResult.success(result: job);
  }

  /// Fetches a [WorkflowRunArtifact] for the given [workflowRun]
  /// by the [artifactName].
  Future<InteractionResult<WorkflowRunArtifact>> _fetchCoverageArtifact(
    WorkflowRun workflowRun,
    String artifactName,
  ) async {
    final runArtifactInteraction = await _client.fetchRunArtifacts(
      workflowRun.id,
    );

    if (_isInteractionFailed(runArtifactInteraction)) {
      return const InteractionResult.error();
    }

    WorkflowRunArtifactsPage page = runArtifactInteraction.result;
    WorkflowRunArtifact artifact;
    bool hasNext;

    do {
      final artifacts = page.values;

      artifact = artifacts.firstWhere(
        (artifact) => artifact.name == artifactName,
        orElse: () => null,
      );

      hasNext = page.hasNextPage && artifact == null;

      if (hasNext) {
        final interaction = await _client.fetchRunArtifactsNext(page);

        if (_isInteractionFailed(interaction)) {
          return const InteractionResult.error();
        }

        page = interaction.result;
      }
    } while (hasNext);

    return InteractionResult.success(result: artifact);
  }

  /// Determines whether the given [interactionResult] is failed or not.
  bool _isInteractionFailed(InteractionResult interactionResult) {
    return interactionResult.isError || interactionResult.result == null;
  }
}
