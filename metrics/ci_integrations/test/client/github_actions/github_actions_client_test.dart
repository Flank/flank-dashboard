import 'dart:io';
import 'dart:typed_data';

import 'package:ci_integration/client/github_actions/constants/github_actions_constants.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import 'test_utils/mock/github_actions_mock_server.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsClient", () {
    const githubApiUrl = 'url';
    const repositoryOwner = 'owner';
    const repositoryName = 'name';

    const defaultPage = 1;
    const defaultPerPage = 10;
    const workflowId = 'workflow_id';
    const runId = 1;

    final authorization = BearerAuthorization('token');
    final githubActionsMockServer = GithubActionsMockServer();

    GithubActionsClient _createClient({
      String githubApiUrl = githubApiUrl,
      String repositoryOwner = repositoryOwner,
      String repositoryName = repositoryName,
      AuthorizationBase authorization,
    }) {
      return GithubActionsClient(
        githubApiUrl: githubApiUrl,
        repositoryOwner: repositoryOwner,
        repositoryName: repositoryName,
        authorization: authorization,
      );
    }

    GithubActionsClient client;

    setUp(() async {
      await githubActionsMockServer.start();
      client = _createClient(githubApiUrl: githubActionsMockServer.url);
    });

    tearDown(() async {
      client.close();
      await githubActionsMockServer.close();
    });

    test(
      "throws an ArgumentError if the given Github API URL is null",
      () {
        expect(() => _createClient(githubApiUrl: null), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given Github API URL is empty",
      () {
        expect(() => _createClient(githubApiUrl: ''), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository owner is null",
      () {
        expect(() => _createClient(repositoryOwner: null), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository owner is empty",
      () {
        expect(() => _createClient(repositoryOwner: ''), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository name is null",
      () {
        expect(() => _createClient(repositoryName: null), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository name is empty",
      () {
        expect(() => _createClient(repositoryName: ''), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given values",
      () {
        final client = GithubActionsClient(
          githubApiUrl: githubApiUrl,
          repositoryOwner: repositoryOwner,
          repositoryName: repositoryName,
          authorization: authorization,
        );

        expect(client.githubApiUrl, equals(githubApiUrl));
        expect(client.repositoryOwner, equals(repositoryOwner));
        expect(client.repositoryName, equals(repositoryName));
        expect(client.authorization, equals(authorization));
      },
    );

    test(
      ".headers contain the 'accept' header with the GithubActionsConstants.acceptHeader value",
      () {
        final expectedHeaderValue = GithubActionsConstants.acceptHeader;

        final headers = client.headers;

        expect(
          headers,
          containsPair(HttpHeaders.acceptHeader, expectedHeaderValue),
        );
      },
    );

    test(
      ".headers include authorization info if the authorization is given",
      () {
        final client = _createClient(authorization: authorization);
        final headers = client.headers;

        final authHeader = authorization.toMap().entries.first;

        expect(headers, containsPair(authHeader.key, authHeader.value));
      },
    );

    test(
      ".headers do not include authorization info if the authorization is not given",
      () {
        final headers = client.headers;

        final authHeader = authorization.toMap().entries.first;

        expect(headers, isNot(containsPair(authHeader.key, authHeader.value)));
      },
    );

    test(
      ".fetchWorkflowRuns() fails if a workflow is not found",
      () async {
        final interaction = await client.fetchWorkflowRuns("test");
        final isError = interaction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page",
      () async {
        final interaction = await client.fetchWorkflowRuns(workflowId);
        final runsPage = interaction.result;

        expect(runsPage, isA<WorkflowRunsPage>());
      },
    );

    test(
      ".fetchWorkflowRuns() applies the default per page parameter if it is not specified",
      () async {
        final interaction = await client.fetchWorkflowRuns(workflowId);
        final runsPage = interaction.result;

        expect(runsPage.perPage, equals(defaultPerPage));
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interaction = await client.fetchWorkflowRuns(
          workflowId,
          perPage: expectedPerPage,
        );
        final runsPage = interaction.result;

        expect(runsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchWorkflowRuns() fetches the first page if the given page parameter is null",
      () async {
        final interaction = await client.fetchWorkflowRuns(
          workflowId,
          page: null,
        );
        final runsPage = interaction.result;

        expect(runsPage.page, equals(1));
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interaction = await client.fetchWorkflowRuns(
          workflowId,
          page: expectedPage,
        );
        final runsPage = interaction.result;

        expect(runsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the next page url",
      () async {
        final interaction = await client.fetchWorkflowRuns(workflowId);
        final runsPage = interaction.result;

        expect(runsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the null next page url if there are no more pages available",
      () async {
        final interaction = await client.fetchWorkflowRuns(
          workflowId,
          perPage: 100,
        );
        final runsPage = interaction.result;

        expect(runsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with a list of workflow runs",
      () async {
        final interaction = await client.fetchWorkflowRuns(workflowId);
        final runs = interaction.result.values;

        expect(runs, everyElement(isA<WorkflowRun>()));
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with workflow runs with the given status",
      () async {
        const expectedStatus = GithubActionStatus.completed;

        final result = await client.fetchWorkflowRuns(
          workflowId,
          status: expectedStatus,
        );

        final runs = result.result.values;

        expect(
          runs,
          everyElement(
            isA<WorkflowRun>().having(
              (run) => run.status,
              'status',
              equals(expectedStatus),
            ),
          ),
        );
      },
    );

    test(
      ".fetchWorkflowRunsNext() returns a workflow runs page",
      () async {
        final interaction = await client.fetchWorkflowRuns(workflowId);
        final runsPage = interaction.result;

        final nextInteraction = await client.fetchWorkflowRunsNext(runsPage);
        final nextRunsPage = nextInteraction.result;

        expect(nextRunsPage, isA<WorkflowRunsPage>());
      },
    );

    test(
      ".fetchWorkflowRunsNext() returns a next workflow runs page after the given one",
      () async {
        final interaction = await client.fetchWorkflowRuns(
          workflowId,
          page: defaultPage,
        );
        final runsPage = interaction.result;

        final nextInteraction = await client.fetchWorkflowRunsNext(runsPage);
        final nextRunsPage = nextInteraction.result;

        expect(nextRunsPage.page, equals(defaultPage + 1));
      },
    );

    test(
      ".fetchWorkflowRunsNext() returns an error if the given page is the last page",
      () async {
        final interaction = await client.fetchWorkflowRuns(
          workflowId,
          perPage: 100,
        );
        final firstPage = interaction.result;

        final nextInteraction = await client.fetchWorkflowRunsNext(firstPage);
        final isError = nextInteraction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchWorkflowRunsNext() returns a workflow runs page with the next workflow runs",
      () async {
        final interaction = await client.fetchWorkflowRuns(workflowId);
        final firstPage = interaction.result;
        final firstRuns = firstPage.values;

        final nextInteraction = await client.fetchWorkflowRunsNext(firstPage);
        final nextPage = nextInteraction.result;
        final nextRuns = nextPage.values;

        expect(nextRuns, isNot(equals(firstRuns)));
      },
    );

    test(
      ".fetchRunJobs() fails if an associated workflow run with such id is not found",
      () async {
        final interaction = await client.fetchRunJobs(10);
        final isError = interaction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page",
      () async {
        final interaction = await client.fetchRunJobs(runId);
        final jobsPage = interaction.result;

        expect(jobsPage, isA<WorkflowRunJobsPage>());
      },
    );

    test(
      ".fetchRunJobs() applies the default per page parameter if it is not specified",
      () async {
        final interaction = await client.fetchRunJobs(runId);
        final jobsPage = interaction.result;

        expect(jobsPage.perPage, equals(defaultPerPage));
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interaction = await client.fetchRunJobs(
          runId,
          perPage: expectedPerPage,
        );
        final jobsPage = interaction.result;

        expect(jobsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchRunJobs() fetches the first page if the given page parameter is null",
      () async {
        final interaction = await client.fetchRunJobs(runId, page: null);
        final jobsPage = interaction.result;

        expect(jobsPage.page, equals(1));
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interaction = await client.fetchRunJobs(
          runId,
          page: expectedPage,
        );
        final jobsPage = interaction.result;

        expect(jobsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the next page url",
      () async {
        final interaction = await client.fetchRunJobs(runId);
        final runsPage = interaction.result;

        expect(runsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the null next page url if there are no more pages available",
      () async {
        final interaction = await client.fetchRunJobs(runId, perPage: 100);
        final runsPage = interaction.result;

        expect(runsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with a list of workflow run jobs",
      () async {
        final interaction = await client.fetchRunJobs(runId);
        final runs = interaction.result.values;

        expect(runs, everyElement(isA<WorkflowRunJob>()));
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with workflow run jobs with the given status",
      () async {
        const expectedStatus = GithubActionStatus.completed;

        final result = await client.fetchRunJobs(runId, status: expectedStatus);
        final runs = result.result.values;

        expect(
          runs,
          everyElement(
            isA<WorkflowRunJob>().having(
              (run) => run.status,
              'status',
              equals(expectedStatus),
            ),
          ),
        );
      },
    );

    test(
      ".fetchRunJobsNext() returns a workflow run jobs page",
      () async {
        final interaction = await client.fetchRunJobs(runId);
        final jobsPage = interaction.result;

        final nextInteraction = await client.fetchRunJobsNext(jobsPage);
        final nextJobsPage = nextInteraction.result;

        expect(nextJobsPage, isA<WorkflowRunJobsPage>());
      },
    );

    test(
      ".fetchRunJobsNext() returns a next workflow run jobs page after the given one",
      () async {
        final interaction = await client.fetchRunJobs(runId, page: defaultPage);
        final jobsPage = interaction.result;

        final nextInteraction = await client.fetchRunJobsNext(jobsPage);
        final nextJobsPage = nextInteraction.result;

        expect(nextJobsPage.page, equals(defaultPage + 1));
      },
    );

    test(
      ".fetchRunJobsNext() returns an error if the given page is the last page",
      () async {
        final interaction = await client.fetchRunJobs(runId, perPage: 100);
        final firstPage = interaction.result;

        final nextInteraction = await client.fetchRunJobsNext(firstPage);
        final isError = nextInteraction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchRunJobsNext() returns a workflow run jobs page with the next workflow run jobs",
      () async {
        final interaction = await client.fetchRunJobs(runId);
        final firstPage = interaction.result;
        final firstJobs = firstPage.values;

        final nextInteraction = await client.fetchRunJobsNext(firstPage);
        final nextPage = nextInteraction.result;
        final nextJobs = nextPage.values;

        expect(nextJobs, isNot(equals(firstJobs)));
      },
    );

    test(
      ".fetchRunArtifacts() fails if an associated workflow run is not found",
      () async {
        final interaction = await client.fetchRunArtifacts(10);
        final isError = interaction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchRunArtifacts() returns a run artifacts page",
      () async {
        final interaction = await client.fetchRunArtifacts(runId);
        final artifactsPage = interaction.result;

        expect(artifactsPage, isA<WorkflowRunArtifactsPage>());
      },
    );

    test(
      ".fetchRunArtifacts() applies the default per page parameter if it is not specified",
      () async {
        final interaction = await client.fetchRunArtifacts(runId);
        final artifactsPage = interaction.result;

        expect(artifactsPage.perPage, equals(defaultPerPage));
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interaction = await client.fetchRunArtifacts(
          runId,
          perPage: expectedPerPage,
        );
        final artifactsPage = interaction.result;

        expect(artifactsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchRunArtifacts() fetches the first page if the given page parameter is null",
      () async {
        final interaction = await client.fetchRunArtifacts(runId, page: null);
        final artifactsPage = interaction.result;

        expect(artifactsPage.page, equals(1));
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interaction = await client.fetchRunArtifacts(
          runId,
          page: expectedPage,
        );
        final artifactsPage = interaction.result;

        expect(artifactsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the next page url",
      () async {
        final interaction = await client.fetchRunArtifacts(runId);
        final artifactsPage = interaction.result;

        expect(artifactsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the null next page url if there are no more pages available",
      () async {
        final interaction = await client.fetchRunArtifacts(runId, perPage: 100);
        final artifactsPage = interaction.result;

        expect(artifactsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with a list of workflow run artifacts",
      () async {
        final interaction = await client.fetchRunArtifacts(runId);
        final artifacts = interaction.result.values;

        expect(artifacts, everyElement(isA<WorkflowRunArtifact>()));
      },
    );

    test(
      ".fetchRunArtifactsNext() returns a workflow run artifacts page",
      () async {
        final interaction = await client.fetchRunArtifacts(runId);
        final artifactsPage = interaction.result;

        final nextInteraction = await client.fetchRunArtifactsNext(
          artifactsPage,
        );
        final nextArtifactsPage = nextInteraction.result;

        expect(nextArtifactsPage, isA<WorkflowRunArtifactsPage>());
      },
    );

    test(
      ".fetchRunArtifactsNext() returns a next workflow run artifacts page after the given one",
      () async {
        final interaction = await client.fetchRunArtifacts(
          runId,
          page: defaultPage,
        );
        final artifactsPage = interaction.result;

        final nextInteraction = await client.fetchRunArtifactsNext(
          artifactsPage,
        );
        final nextArtifactsPage = nextInteraction.result;

        expect(nextArtifactsPage.page, equals(defaultPage + 1));
      },
    );

    test(
      ".fetchRunArtifactsNext() returns an error if the given page is the last page",
      () async {
        final interaction = await client.fetchRunArtifacts(runId, perPage: 100);
        final firstPage = interaction.result;

        final nextInteraction = await client.fetchRunArtifactsNext(firstPage);
        final isError = nextInteraction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchRunArtifactsNext() returns a workflow run artifacts page with the next workflow run artifacts",
      () async {
        final interaction = await client.fetchRunArtifacts(runId);
        final firstPage = interaction.result;
        final firstArtifacts = firstPage.values;

        final nextInteraction = await client.fetchRunArtifactsNext(firstPage);
        final nextPage = nextInteraction.result;
        final nextArtifacts = nextPage.values;

        expect(nextArtifacts, isNot(equals(firstArtifacts)));
      },
    );

    test(
      ".downloadRunArtifactZip() fails with the error if the given url is null",
      () async {
        final interaction = await client.downloadRunArtifactZip(null);
        final isError = interaction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".downloadRunArtifactZip() fails with the error if the artifact associated with the given download url is not found",
      () async {
        final downloadUrl = '${client.basePath}artifacts/test/zip';
        final interaction = await client.downloadRunArtifactZip(downloadUrl);
        final isError = interaction.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".downloadRunArtifactZip() returns the body bytes of the run artifact",
      () async {
        const artifactId = 'artifact_id';
        final downloadUrl = '${client.basePath}artifacts/$artifactId/zip';

        final interaction = await client.downloadRunArtifactZip(downloadUrl);
        final bodyBytes = interaction.result;

        expect(bodyBytes, isA<Uint8List>());
      },
    );
  });
}
