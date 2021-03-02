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
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/source/github_actions/config/validation_delegate/github_actions_source_validation_delegate.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:metrics_core/metrics_core.dart';
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
    final testData = GithubActionsTestDataGenerator(
      workflowIdentifier: workflowId,
      jobName: jobName,
      coverageArtifactName: coverageArtifactName,
      coverage: Percent(0.6),
      url: 'url',
      startDateTime: DateTime(2020),
      completeDateTime: DateTime(2021),
      duration: DateTime(2021).difference(DateTime(2020)),
    );

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

    final emptyWorkflowRunJobsPage = WorkflowRunJobsPage(
      page: 1,
      nextPageUrl: testData.url,
      values: const [],
    );
    final defaultRunsPage = WorkflowRunsPage(
      values: testData.generateWorkflowRunsByNumbers(
        runNumbers: [2, 1],
      ),
    );
    const emptyRunsPage = WorkflowRunsPage(values: []);

    final defaultJobsPage = WorkflowRunJobsPage(
      values: [testData.generateWorkflowRunJob()],
    );
    final defaultArtifactsPage = WorkflowRunArtifactsPage(values: [
      WorkflowRunArtifact(name: testData.coverageArtifactName),
    ]);

    final artifactsPage = WorkflowRunArtifactsPage(
      values: const [WorkflowRunArtifact()],
      nextPageUrl: testData.url,
    );

    final auth = BearerAuthorization('token');

    final client = GithubActionsClientMock();
    final delegate = GithubActionsSourceValidationDelegate(client);

    PostExpectation<Future<InteractionResult<WorkflowRunsPage>>>
        whenFetchWorkflowRuns({
      WorkflowRunJobsPage withJobsPage,
    }) {
      when(client.fetchRunJobs(
        any,
        status: anyNamed('status'),
        perPage: anyNamed('perPage'),
        page: anyNamed('page'),
      )).thenSuccessWith(withJobsPage);

      return when(
        client.fetchWorkflowRuns(
          any,
          status: anyNamed('status'),
          perPage: anyNamed('perPage'),
          page: anyNamed('page'),
        ),
      );
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
      ".validateAuth() returns an error if the interaction with the client is not successful",
      () async {
        when(
          client.fetchToken(auth),
        ).thenErrorWith();

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction with the token invalid message if the interaction with the client is not successful",
      () async {
        when(
          client.fetchToken(auth),
        ).thenErrorWith();

        final interactionResult = await delegate.validateAuth(auth);
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns an error if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction with the token invalid message if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateAuth(auth);
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns an error if the fetched token does not have the required scope",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(const GithubToken(scopes: []));

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction with the token scope not found message if the fetched token does not have the required scope",
      () async {
        const requiredTokenScope = GithubTokenScope.repo;
        const mapper = GithubTokenScopeMapper();
        final requiredScope = mapper.unmap(requiredTokenScope);

        when(
          client.fetchToken(auth),
        ).thenSuccessWith(const GithubToken(scopes: []));

        final interactionResult = await delegate.validateAuth(auth);
        final message = interactionResult.message;

        expect(
          message,
          equals(GithubActionsStrings.tokenScopeNotFound(requiredScope)),
        );
      },
    );

    test(
      ".validateAuth() returns an interaction containing the fetched Github token has required scopes",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(githubToken);

        final interactionResult = await delegate.validateAuth(auth);
        final token = interactionResult.result;

        expect(token, equals(githubToken));
      },
    );

    test(
      ".validateRepositoryOwner() returns an error if the interaction with the client is not successful",
      () async {
        when(
          client.fetchGithubUser(repositoryOwner),
        ).thenErrorWith();

        final interactionResult = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateRepositoryOwner() returns an interaction with the repository owner not found message if the interaction with the client is not successful",
      () async {
        when(
          client.fetchGithubUser(repositoryOwner),
        ).thenErrorWith();

        final interactionResult = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.repositoryOwnerNotFound));
      },
    );

    test(
      ".validateRepositoryOwner() returns an error if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchGithubUser(repositoryOwner),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateRepositoryOwner() returns an interaction with the repository owner not found message if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchGithubUser(repositoryOwner),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.repositoryOwnerNotFound));
      },
    );

    test(
      ".validateRepositoryOwner() returns a successful interaction if the given repository owner is valid",
      () async {
        when(
          client.fetchGithubUser(repositoryOwner),
        ).thenSuccessWith(githubUser);

        final interactionResult = await delegate.validateRepositoryOwner(
          repositoryOwner,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateRepositoryName() returns an error if the interaction with the client is not successful",
      () async {
        when(client.fetchGithubRepository(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        )).thenErrorWith();

        final interactionResult = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateRepositoryName() returns an interaction with the repository not found message if the interaction with the client is not successful",
      () async {
        when(client.fetchGithubRepository(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        )).thenErrorWith();

        final interactionResult = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.repositoryNotFound));
      },
    );

    test(
      ".validateRepositoryName() returns an error if the result of an interaction with the client is null",
      () async {
        when(client.fetchGithubRepository(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        )).thenSuccessWith(null);

        final interactionResult = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateRepositoryName() returns an interaction with the repository not found message if the result of an interaction with the client is null",
      () async {
        when(client.fetchGithubRepository(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        )).thenSuccessWith(null);

        final interactionResult = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.repositoryNotFound));
      },
    );

    test(
      ".validateRepositoryName() returns a successful interaction if the given repository name is valid",
      () async {
        when(client.fetchGithubRepository(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        )).thenSuccessWith(githubRepository);

        final interactionResult = await delegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateWorkflowId() returns an error if the interaction with the client is not successful",
      () async {
        when(
          client.fetchWorkflow(workflowId),
        ).thenErrorWith();

        final interactionResult = await delegate.validateWorkflowId(workflowId);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateWorkflowId() returns an interaction with the workflow not found message if the interaction with the client is not successful",
      () async {
        when(
          client.fetchWorkflow(workflowId),
        ).thenErrorWith();

        final interactionResult = await delegate.validateWorkflowId(workflowId);
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowNotFround));
      },
    );

    test(
      ".validateWorkflowId() returns an error if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchWorkflow(workflowId),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateWorkflowId(workflowId);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateWorkflowId() returns an interaction with the workflow not found message if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchWorkflow(workflowId),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateWorkflowId(workflowId);
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowNotFround));
      },
    );

    test(
      ".validateWorkflowId() returns a successful interaction if the given workflow identifier is valid",
      () async {
        when(
          client.fetchWorkflow(workflowId),
        ).thenSuccessWith(githubActionsWorkflow);

        final interactionResult = await delegate.validateWorkflowId(workflowId);

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns error",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateJobName() returns workflow id invalid message ",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateJobName() returns error if null",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenSuccessWith(
          null,
        );

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateJobName() returns workflow id invalid message",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenSuccessWith(
          null,
        );

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateJobName() return error if empty ",
      () async {
        whenFetchWorkflowRuns(withJobsPage: emptyWorkflowRunJobsPage)
            .thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateJobName() if empty msg",
      () async {
        whenFetchWorkflowRuns(withJobsPage: emptyWorkflowRunJobsPage)
            .thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );
        final message = interactionResult.message;

        expect(message,
            equals(GithubActionsStrings.noWorkflowRunsToValidateJobName));
      },
    );

    test(
      ".validateJobName() is Error ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunJobs(workflowRuns.first?.id)).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateJobName() is error msg ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunJobs(workflowRuns.first?.id)).thenErrorWith();

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.noJobsToValidateJobName));
      },
    );

    test(
      ".validateJobName() is Error if null ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunJobs(workflowRuns.first?.id)).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateJobName() is error null msg ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunJobs(workflowRuns.first?.id)).thenSuccessWith(null);

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.noJobsToValidateJobName));
      },
    );

    test(
      ".validateJobName() not valid job ",
      () async {
        final testData = GithubActionsTestDataGenerator(
          workflowIdentifier: workflowId,
          jobName: 'job2',
          coverageArtifactName: 'coverage-summary.json',
          coverage: Percent(0.6),
          url: 'url',
          startDateTime: DateTime(2020),
          completeDateTime: DateTime(2021),
          duration: DateTime(2021).difference(DateTime(2020)),
        );

        final defaultJobsPage = WorkflowRunJobsPage(
          values: [testData.generateWorkflowRunJob()],
        );

        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunJobs(workflowRuns.first?.id)).thenSuccessWith(
          defaultJobsPage,
        );

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateJobName() not valid job message",
      () async {
        final testData = GithubActionsTestDataGenerator(
          workflowIdentifier: workflowId,
          jobName: 'job2',
          coverageArtifactName: 'coverage-summary.json',
          coverage: Percent(0.6),
          url: 'url',
          startDateTime: DateTime(2020),
          completeDateTime: DateTime(2021),
          duration: DateTime(2021).difference(DateTime(2020)),
        );

        final defaultJobsPage = WorkflowRunJobsPage(
          values: [testData.generateWorkflowRunJob()],
        );

        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunJobs(workflowRuns.first?.id)).thenSuccessWith(
          defaultJobsPage,
        );

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.jobNameInvalid));
      },
    );

    test(
      ".validateJobName() success",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunJobs(workflowRuns.first?.id)).thenSuccessWith(
          defaultJobsPage,
        );

        final interactionResult = await delegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns error",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns error message",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateCoverageArtifactName() returns error if null",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenSuccessWith(
          null,
        );

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() returns msg ",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage).thenSuccessWith(
          null,
        );

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.workflowIdentifierInvalid));
      },
    );

    test(
      ".validateCoverageArtifactName() error if empty ",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() empty msg ",
      () async {
        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(emptyRunsPage);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );
        final message = interactionResult.message;

        expect(message,
            equals(GithubActionsStrings.noWorkflowRunsToValidateJobName));
      },
    );

    test(
      ".validateCoverageArtifactName() is Error ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunArtifacts(workflowRuns.first?.id)).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() is error msg ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunArtifacts(workflowRuns.first?.id)).thenErrorWith();

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.noArtifactsToValidateName));
      },
    );

    test(
      ".validateCoverageArtifactName() is Error null ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunArtifacts(workflowRuns.first?.id))
            .thenSuccessWith(null);

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() is Error msg ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunArtifacts(workflowRuns.first?.id)).thenSuccessWith(
          null,
        );

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );
        final message = interactionResult.message;

        expect(message, equals(GithubActionsStrings.noArtifactsToValidateName));
      },
    );

    test(
      ".validateCoverageArtifactName() not valid job ",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);
        final artifactsPage = WorkflowRunArtifactsPage(
          values: const [WorkflowRunArtifact()],
          nextPageUrl: testData.url,
        );

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunArtifacts(workflowRuns.first?.id)).thenSuccessWith(
          artifactsPage,
        );

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateCoverageArtifactName() not valid job message",
      () async {
        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);
        final artifactsPage = WorkflowRunArtifactsPage(
          values: const [WorkflowRunArtifact()],
          nextPageUrl: testData.url,
        );

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunArtifacts(workflowRuns.first?.id)).thenSuccessWith(
          artifactsPage,
        );

        final interactionResult = await delegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        );
        final message = interactionResult.message;

        expect(
            message, equals(GithubActionsStrings.coverageArtifactNameInvalid));
      },
    );

    test(
      ".validateCoverageArtifactName() success",
      () async {
        final testData = GithubActionsTestDataGenerator(
          workflowIdentifier: workflowId,
          jobName: jobName,
          coverageArtifactName: coverageArtifactName,
          coverage: Percent(0.6),
          url: 'url',
          startDateTime: DateTime(2020),
          completeDateTime: DateTime(2021),
          duration: DateTime(2021).difference(DateTime(2020)),
        );

        final defaultJobsPage = WorkflowRunJobsPage(
          values: [testData.generateWorkflowRunJob()],
        );

        final workflowRuns = testData.generateWorkflowRunsByNumbers(
          runNumbers: List.generate(30, (index) => index),
        );

        final workflowRunsPage = WorkflowRunsPage(values: workflowRuns);
        final defaultArtifactsPage = WorkflowRunArtifactsPage(values: [
          WorkflowRunArtifact(name: testData.coverageArtifactName),
        ]);

        whenFetchWorkflowRuns(withJobsPage: defaultJobsPage)
            .thenSuccessWith(workflowRunsPage);
        when(client.fetchRunArtifacts(workflowRuns.first?.id)).thenSuccessWith(
          defaultArtifactsPage,
        );

        final interactionResult = await delegate.validateCoverageArtifactName(
          coverageArtifactName: coverageArtifactName,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );
  });
}
