// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_actions_workflow.dart';
import 'package:ci_integration/client/github_actions/models/github_repository.dart';
import 'package:ci_integration/client/github_actions/models/github_token.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:ci_integration/client/github_actions/models/github_user.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/source/github_actions/config/validation_delegate/github_actions_source_validation_delegate.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/extensions/interaction_result_answer.dart';
import '../../test_utils/github_actions_client_mock.dart';
import '../../test_utils/test_data/github_actions_test_data_generator.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceValidationDelegate", () {
    const id = 1;
    const repositoryOwner = 'owner';
    const repositoryName = 'name';
    const workflowId = 'workflow_id';
    const jobName = 'job';
    const coverageArtifactName = 'coverage_report';

    const githubToken = GithubToken(
      scopes: [
        GithubTokenScope.repo,
      ],
    );

    const githubUser = GithubUser(
      id: id,
      login: repositoryOwner,
    );

    const githubRepository = GithubRepository(
      id: id,
      name: repositoryName,
      owner: githubUser,
    );

    const githubActionsWorkflow = GithubActionsWorkflow(
      path: workflowId,
    );

    const testDataGenerator = GithubActionsTestDataGenerator(
      workflowIdentifier: workflowId,
      jobName: jobName,
      coverageArtifactName: coverageArtifactName,
    );
    final emptyRunsPage = WorkflowRunsPage(
      values: const [],
      nextPageUrl: testDataGenerator.url,
    );
    final runsPage = WorkflowRunsPage(
      values: testDataGenerator.generateWorkflowRunsByNumbers(
        runNumbers: [1],
      ),
    );
    final emptyJobsPage = WorkflowRunJobsPage(
      page: 1,
      nextPageUrl: testDataGenerator.url,
      values: const [],
    );
    final jobsPage = WorkflowRunJobsPage(
        values: [testDataGenerator.generateWorkflowRunJob()],
        nextPageUrl: 'url');
    final emptyArtifactsPage = WorkflowRunArtifactsPage(
      values: const [],
      nextPageUrl: testDataGenerator.url,
    );
    const artifactsPage = WorkflowRunArtifactsPage(
      values: [
        WorkflowRunArtifact(name: coverageArtifactName),
      ],
      nextPageUrl: 'url',
    );

    const workflowRunsPageHasNext = WorkflowRunJobsPage(
      values: [],
      nextPageUrl: 'url',
    );

    const artifactsPageHasNext = WorkflowRunArtifactsPage(
      values: [],
      nextPageUrl: 'url',
    );

    final auth = BearerAuthorization('token');

    final client = GithubActionsClientMock();
    final delegate = GithubActionsSourceValidationDelegate(client);

    PostExpectation<Future<InteractionResult<WorkflowRunsPage>>>
        whenFetchWorkflowRuns(
      String workflowIdentifier,
    ) {
      return when(
        client.fetchWorkflowRuns(
          workflowIdentifier,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      );
    }

    PostExpectation<Future<InteractionResult<WorkflowRunsPage>>>
        whenFetchWorkflowRunsWithConclusion(
      String workflowIdentifier,
    ) {
      return when(
        client.fetchWorkflowRunsWithConclusion(
          workflowIdentifier,
          conclusion: anyNamed('conclusion'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      );
    }

    PostExpectation<Future<InteractionResult<WorkflowRunJobsPage>>>
        whenFetchRunJobs() {
      when(
        client.fetchWorkflowRuns(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      ).thenSuccessWith(runsPage);

      return when(client.fetchRunJobs(
        any,
        status: anyNamed('status'),
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      ));
    }

    PostExpectation<Future<InteractionResult<WorkflowRunArtifactsPage>>>
        whenFetchRunArtifacts() {
      when(
        client.fetchWorkflowRunsWithConclusion(
          any,
          conclusion: anyNamed('conclusion'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      ).thenSuccessWith(runsPage);

      return when(client.fetchRunArtifacts(
        any,
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      ));
    }

    tearDown(() {
      reset(client);
    });

    test(
      "throws an ArgumentError if the given client is null",
      () {
        expect(
          () => GithubActionsSourceValidationDelegate(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given client",
      () {
        expect(
          () => GithubActionsSourceValidationDelegate(client),
          returnsNormally,
        );
      },
    );

    test(
      ".validateAuth() returns a failure field validation result, if the token fetching failed",
      () async {
        when(client.fetchToken(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'token invalid' additional context, if the token fetching failed",
      () async {
        when(client.fetchToken(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(GithubActionsStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result, if the token fetching result is null",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'token invalid' additional context, if the token fetching result is null",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(GithubActionsStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result, if the fetched token does not have the required scope",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(const GithubToken(scopes: []));

        final result = await delegate.validateAuth(auth);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'token scope not found' additional context, if the fetched token does not have the required scope",
      () async {
        final requiredScope = GithubTokenScopeMapper.repo;

        when(
          client.fetchToken(auth),
        ).thenSuccessWith(const GithubToken(scopes: []));

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(
          additionalContext,
          equals(
            GithubActionsStrings.tokenMissingScopes(requiredScope),
          ),
        );
      },
    );

    test(
      ".validateAuth() returns a failure field validation result, if the fetched token scopes are null",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(const GithubToken());

        final result = await delegate.validateAuth(auth);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'token scope not found' additional context, if the fetched token scopes are null",
      () async {
        final requiredScope = GithubTokenScopeMapper.repo;

        when(client.fetchToken(auth)).thenSuccessWith(const GithubToken());

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(
          additionalContext,
          equals(GithubActionsStrings.tokenMissingScopes(requiredScope)),
        );
      },
    );

    test(
      ".validateAuth() returns a success field validation result, if the fetched Github token has required scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(githubToken);

        final result = await delegate.validateAuth(auth);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateRepositoryOwner() returns a failure field validation result, if the repository owner fetching failed",
      () async {
        when(client.fetchGithubUser(repositoryOwner)).thenErrorWith();

        final result = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateRepositoryOwner() returns a field validation result with the 'repository owner not found' additional context, if the repository owner fetching failed",
      () async {
        when(client.fetchGithubUser(repositoryOwner)).thenErrorWith();

        final result = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );
        final additionalContext = result.additionalContext;

        expect(
          additionalContext,
          equals(GithubActionsStrings.repositoryOwnerNotFound),
        );
      },
    );

    test(
      ".validateRepositoryOwner() returns a failure field validation result, if the repository owner fetching result is null",
      () async {
        when(client.fetchGithubUser(repositoryOwner)).thenSuccessWith(null);

        final result = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateRepositoryOwner() returns a field validation result with the 'repository owner not found' additional context, if the repository owner fetching result is null",
      () async {
        when(client.fetchGithubUser(repositoryOwner)).thenSuccessWith(null);

        final result = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );
        final additionalContext = result.additionalContext;

        expect(
          additionalContext,
          equals(GithubActionsStrings.repositoryOwnerNotFound),
        );
      },
    );

    test(
      ".validateRepositoryOwner() returns a success field validation result, if the given repository owner is valid",
      () async {
        when(
          client.fetchGithubUser(repositoryOwner),
        ).thenSuccessWith(githubUser);

        final result = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateRepositoryName() returns a failure field validation result, if the github repository fetching failed",
      () async {
        when(
          client.fetchGithubRepository(
            repositoryName: repositoryName,
            repositoryOwner: repositoryOwner,
          ),
        ).thenErrorWith();

        final result = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateRepositoryName() returns a field validation result with the 'repository not found' additional context, if the github repository fetching failed",
      () async {
        when(
          client.fetchGithubRepository(
            repositoryName: repositoryName,
            repositoryOwner: repositoryOwner,
          ),
        ).thenErrorWith();

        final result = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );
        final additionalContext = result.additionalContext;

        expect(
          additionalContext,
          equals(GithubActionsStrings.repositoryNotFound),
        );
      },
    );

    test(
      ".validateRepositoryName() returns a failure field validation result, if the github repository fetching result is null",
      () async {
        when(
          client.fetchGithubRepository(
            repositoryName: repositoryName,
            repositoryOwner: repositoryOwner,
          ),
        ).thenSuccessWith(null);

        final result = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateRepositoryName() returns a field validation result with the 'repository not found' additional context, if the github repository fetching result is null",
      () async {
        when(
          client.fetchGithubRepository(
            repositoryName: repositoryName,
            repositoryOwner: repositoryOwner,
          ),
        ).thenSuccessWith(null);

        final result = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );
        final additionalContext = result.additionalContext;

        expect(
            additionalContext, equals(GithubActionsStrings.repositoryNotFound));
      },
    );

    test(
      ".validateRepositoryName() returns a success field validation result, if the given repository name is valid",
      () async {
        when(
          client.fetchGithubRepository(
            repositoryName: repositoryName,
            repositoryOwner: repositoryOwner,
          ),
        ).thenSuccessWith(githubRepository);

        final result = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateWorkflowId() returns a failure field validation result, if the workflow fetching failed",
      () async {
        when(client.fetchWorkflow(workflowId)).thenErrorWith();

        final result = await delegate.validateWorkflowId(workflowId);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateWorkflowId() returns a field validation result with the 'workflow not found' additional context, if the workflow fetching failed",
      () async {
        when(client.fetchWorkflow(workflowId)).thenErrorWith();

        final result = await delegate.validateWorkflowId(workflowId);
        final additionalContext = result.additionalContext;

        expect(
            additionalContext, equals(GithubActionsStrings.workflowNotFound));
      },
    );

    test(
      ".validateWorkflowId() returns a failure field validation result, if the workflow fetching result is null",
      () async {
        when(client.fetchWorkflow(workflowId)).thenSuccessWith(null);

        final result = await delegate.validateWorkflowId(workflowId);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateWorkflowId() returns a field validation result with the 'workflow not found' additional context, if the workflow fetching result is null",
      () async {
        when(
          client.fetchWorkflow(workflowId),
        ).thenSuccessWith(null);

        final result = await delegate.validateWorkflowId(workflowId);
        final additionalContext = result.additionalContext;

        expect(
            additionalContext, equals(GithubActionsStrings.workflowNotFound));
      },
    );

    test(
      ".validateWorkflowId() returns a success field validation result, if the given workflow identifier is valid",
      () async {
        when(
          client.fetchWorkflow(workflowId),
        ).thenSuccessWith(githubActionsWorkflow);

        final result = await delegate.validateWorkflowId(workflowId);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns a successful interaction if the workflow runs fetching failed",
      () async {
        whenFetchWorkflowRuns(workflowId).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with a null result if the workflow runs fetching failed",
      () async {
        whenFetchWorkflowRuns(workflowId).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateJobName() returns an interaction with the workflow identifier invalid message if the workflow runs fetching failed",
      () async {
        whenFetchWorkflowRuns(workflowId).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateJobName() returns a successful interaction if the workflow runs fetching result is null",
      () async {
        whenFetchWorkflowRuns(workflowId).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with a null result if the workflow runs fetching result is null",
      () async {
        whenFetchWorkflowRuns(workflowId).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateJobName() returns an interaction with the workflow identifier invalid message if the workflow runs fetching result is null",
      () async {
        whenFetchWorkflowRuns(workflowId).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateJobName() returns a successful interaction if there are no completed workflow runs",
      () async {
        whenFetchWorkflowRuns(workflowId).thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with a null result if there are no completed workflow runs",
      () async {
        whenFetchWorkflowRuns(workflowId).thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateJobName() returns an interaction with the no completed workflow runs message if there are no completed workflow runs",
      () async {
        whenFetchWorkflowRuns(workflowId).thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        final message = interactionResult.message;

        expect(
          message,
          equals(GithubActionsStrings.noCompletedWorkflowRuns),
        );
      },
    );

    test(
      ".validateJobName() returns a successful interaction if the workflow run jobs page fetching failed",
      () async {
        whenFetchRunJobs().thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with a null result if the workflow run jobs page fetching failed",
      () async {
        whenFetchRunJobs().thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateJobName() returns an interaction with the jobs fetching failed message if the workflow run jobs page fetching failed",
      () async {
        whenFetchRunJobs().thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.jobsFetchingFailed));
      },
    );

    test(
      ".validateJobName() returns a successful interaction if the workflow run jobs page fetching result is null",
      () async {
        whenFetchRunJobs().thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with a null result if the workflow run jobs page fetching result is null",
      () async {
        whenFetchRunJobs().thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateJobName() returns an interaction with the jobs fetching failed message if the workflow run jobs page fetching result is null",
      () async {
        whenFetchRunJobs().thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.jobsFetchingFailed));
      },
    );

    test(
      ".validateJobName() does not fetch the next workflow runs page if the first one contains a job with the given name",
      () async {
        whenFetchRunJobs().thenSuccessWith(jobsPage);

        await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        verifyNever(client.fetchRunJobsNext(jobsPage));
      },
    );

    test(
      ".validateJobName() returns a successful interaction if the next workflow run jobs page fetching failed",
      () async {
        whenFetchRunJobs().thenSuccessWith(workflowRunsPageHasNext);
        when(
          client.fetchRunJobsNext(workflowRunsPageHasNext),
        ).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with a null result if the next workflow run jobs page fetching failed",
      () async {
        whenFetchRunJobs().thenSuccessWith(workflowRunsPageHasNext);
        when(
          client.fetchRunJobsNext(workflowRunsPageHasNext),
        ).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateJobName() returns an interaction with the jobs fetching failed message if the next workflow run jobs page fetching failed",
      () async {
        whenFetchRunJobs().thenSuccessWith(workflowRunsPageHasNext);
        when(
          client.fetchRunJobsNext(workflowRunsPageHasNext),
        ).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.jobsFetchingFailed));
      },
    );

    test(
      ".validateJobName() returns a successful interaction if the next workflow run jobs page fetching result is null",
      () async {
        whenFetchRunJobs().thenSuccessWith(workflowRunsPageHasNext);
        when(
          client.fetchRunJobsNext(workflowRunsPageHasNext),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with a null result if the next workflow run jobs page fetching result is null",
      () async {
        whenFetchRunJobs().thenSuccessWith(workflowRunsPageHasNext);
        when(
          client.fetchRunJobsNext(workflowRunsPageHasNext),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateJobName() returns an interaction with the jobs fetching failed message if the next workflow run jobs page fetching result is null",
      () async {
        whenFetchRunJobs().thenSuccessWith(workflowRunsPageHasNext);
        when(
          client.fetchRunJobsNext(workflowRunsPageHasNext),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.jobsFetchingFailed));
      },
    );

    test(
      ".validateJobName() returns an error if there is no job with the given job name",
      () async {
        whenFetchRunJobs().thenSuccessWith(emptyJobsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction with the job name invalid message if there is no job with the given job name",
      () async {
        whenFetchRunJobs().thenSuccessWith(emptyJobsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.jobNameInvalid));
      },
    );

    test(
      ".validateJobName() returns a successful interaction if the given job name is valid",
      () async {
        whenFetchRunJobs().thenSuccessWith(jobsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns an interaction containing the workflow run job",
      () async {
        whenFetchRunJobs().thenSuccessWith(jobsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.result, isA<WorkflowRunJob>());
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if the workflow runs fetching failed",
      () async {
        whenFetchWorkflowRunsWithConclusion(workflowId).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a null result if the workflow runs fetching failed",
      () async {
        whenFetchWorkflowRunsWithConclusion(workflowId).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with the workflow identifier invalid message if the workflow runs fetching failed",
      () async {
        whenFetchWorkflowRunsWithConclusion(workflowId).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if the successful workflow runs fetching result is null",
      () async {
        whenFetchWorkflowRunsWithConclusion(workflowId).thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a null result if the successful workflow runs fetching result is null",
      () async {
        whenFetchWorkflowRunsWithConclusion(workflowId).thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with the workflow identifier invalid message if the successful workflow runs fetching result is null",
      () async {
        whenFetchWorkflowRunsWithConclusion(workflowId).thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if there are no successful workflow runs",
      () async {
        whenFetchWorkflowRunsWithConclusion(
          workflowId,
        ).thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a null result if there are no successful workflow runs",
      () async {
        whenFetchWorkflowRunsWithConclusion(
          workflowId,
        ).thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with the no successful workflow runs message if there are no successful workflow runs",
      () async {
        whenFetchWorkflowRunsWithConclusion(
          workflowId,
        ).thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.noSuccessfulWorkflowRuns));
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if the workflow run artifacts page fetching failed",
      () async {
        whenFetchRunArtifacts().thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a null result if the workflow run artifacts page fetching failed",
      () async {
        whenFetchRunArtifacts().thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction with the artifacts fetching failed message if the workflow run artifacts page fetching failed",
      () async {
        whenFetchRunArtifacts().thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.artifactsFetchingFailed));
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if the successful workflow run artifacts page fetching result is null",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a null result if the successful workflow run artifacts page fetching result is null",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with the artifacts fetching failed message if the successful workflow run artifacts page fetching result is null",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.artifactsFetchingFailed));
      },
    );

    test(
      ".validateCoverageArtifactName() does not fetch the next workflow runs artifact page if the first one contains an artifact with the given name",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPage);

        await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        verifyNever(client.fetchRunArtifactsNext(artifactsPage));
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if the next workflow run artifacts page fetching failed",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPageHasNext);
        when(
          client.fetchRunArtifactsNext(artifactsPageHasNext),
        ).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a null result if the next workflow run artifacts page fetching failed",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPageHasNext);
        when(
          client.fetchRunArtifactsNext(artifactsPageHasNext),
        ).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with the artifacts fetching failed message if the next workflow run artifacts page fetching failed",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPageHasNext);
        when(
          client.fetchRunArtifactsNext(artifactsPageHasNext),
        ).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.artifactsFetchingFailed));
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if the successful next workflow run artifacts page fetching result is null",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPageHasNext);
        when(
          client.fetchRunArtifactsNext(artifactsPageHasNext),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a null result if the successful next workflow run artifacts page fetching result is null",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPageHasNext);
        when(
          client.fetchRunArtifactsNext(artifactsPageHasNext),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isNull);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with the artifacts fetching failed message if the successful next workflow run artifacts page fetching result is null",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPageHasNext);
        when(
          client.fetchRunArtifactsNext(artifactsPageHasNext),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        final message = interactionResult.message;

        expect(
          message,
          equals(
            GithubActionsStrings.artifactsFetchingFailed,
          ),
        );
      },
    );

    test(
      ".validateCoverageArtifactName() returns an error if there is no artifact with the given coverage artifact name",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(emptyArtifactsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with the coverage artifact name invalid message if there is no artifact with the given coverage artifact name",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(emptyArtifactsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );
        final message = interactionResult.message;

        expect(
          message,
          equals(GithubActionsStrings.coverageArtifactNameInvalid),
        );
      },
    );

    test(
      ".validateCoverageArtifactName() returns a successful interaction if the given coverage artifact name is valid",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns an interaction with a workflow run artifact if the given coverage artifact name is valid",
      () async {
        whenFetchRunArtifacts().thenSuccessWith(artifactsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.result, isA<WorkflowRunArtifact>());
      },
    );
  });
}
