// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';

/// A [SourceValidationDelegate] for the Github Actions source integration.
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
  Future<InteractionResult> validateAuth(
    AuthorizationBase auth,
  ) async {
    final interaction = await _client.fetchToken(auth);

    if (interaction.isError || interaction.result == null) {
      return const InteractionResult.error(
        message: GithubActionsStrings.tokenInvalid,
      );
    }

    final token = interaction.result;
    final tokenScopes = token.scopes ?? [];

    final requiredTokenScope = _requiredTokenScopes.firstWhere(
      (scope) => !tokenScopes.contains(scope),
      orElse: () => null,
    );

    if (requiredTokenScope != null) {
      const mapper = GithubTokenScopeMapper();

      return InteractionResult.error(
        message: GithubActionsStrings.tokenScopeNotFound(
          mapper.unmap(requiredTokenScope),
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

    if (repositoryOwnerInteraction.isError ||
        repositoryOwnerInteraction.result == null) {
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

    if (repositoryInteraction.isError || repositoryInteraction.result == null) {
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

    if (workflowInteraction.isError || workflowInteraction.result == null) {
      return const InteractionResult.error(
        message: GithubActionsStrings.workflowNotFround,
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

    final jobsInteraction = await _fetchWorkflowRunJobsPage(
      workflowRunId,
      jobName,
    );

    return jobsInteraction;
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

    final artifactsInteraction = await _fetchWorkflowRunArtifactsPage(
      workflowRunId,
      coverageArtifactName,
    );

    return artifactsInteraction;
  }

  /// Fetches a [WorkflowRunsPage] with a list of [WorkflowRun].
  Future<InteractionResult<WorkflowRunsPage>> _fetchWorkflowRunsPage(
    String workflowId,
  ) async {
    final workflowRunsInteraction = await _client.fetchWorkflowRuns(
      workflowId,
      status: GithubActionStatus.completed,
      page: 1,
      perPage: 1,
    );

    if (workflowRunsInteraction.isError ||
        workflowRunsInteraction.result == null) {
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

  /// Fetches a [WorkflowRunJobsPage]
  /// by the given [workflowRunId] and [jobName].
  Future<InteractionResult<WorkflowRunJobsPage>> _fetchWorkflowRunJobsPage(
    int workflowRunId,
    String jobName,
  ) async {
    final jobsInteraction = await _client.fetchRunJobs(workflowRunId);

    if (jobsInteraction.isError || jobsInteraction.result == null) {
      return const InteractionResult.error(
        message: GithubActionsStrings.noJobsToValidateJobName,
      );
    }

    final jobs = jobsInteraction.result.values;

    final jobNameIsNotValid = !jobs.any((job) => job.name == jobName);

    if (jobNameIsNotValid) {
      return const InteractionResult.error(
        message: GithubActionsStrings.jobNameInvalid,
      );
    }

    return const InteractionResult.success();
  }

  /// Fetches a [WorkflowRunArtifactsPage]
  /// by the given [workflowRunId] and [coverageArtifactName].
  Future<InteractionResult<WorkflowRunArtifactsPage>>
      _fetchWorkflowRunArtifactsPage(
    int workflowRunId,
    String coverageArtifactName,
  ) async {
    final artifactsInteraction = await _client.fetchRunArtifacts(workflowRunId);

    if (artifactsInteraction.isError || artifactsInteraction.result == null) {
      return const InteractionResult.error(
        message: GithubActionsStrings.noArtifactsToValidateName,
      );
    }

    final artifacts = artifactsInteraction.result.values;

    final nameIsNotValid = !artifacts.any(
      (artifact) => artifact.name == coverageArtifactName,
    );

    if (nameIsNotValid) {
      return const InteractionResult.error(
        message: GithubActionsStrings.coverageArtifactNameInvalid,
      );
    }

    return const InteractionResult.success();
  }
}
