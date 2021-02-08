// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:ci_integration/client/github_actions/constants/github_actions_constants.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import 'test_utils/mock/github_actions_mock_server.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsClient", () {
    const githubApiUrl = 'url';
    const repositoryOwner = 'owner';
    const repositoryName = 'name';

    const testPageNumber = 1;
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

    setUpAll(() async {
      await githubActionsMockServer.start();
      client = _createClient(githubApiUrl: githubActionsMockServer.url);
    });

    tearDownAll(() async {
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
        const expectedHeaderValue = GithubActionsConstants.acceptHeader;

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
      ".fetchWorkflowRuns() fails if there is no workflow with such identifier",
      () async {
        final interactionResult = await client.fetchWorkflowRuns("test");
        final isError = interactionResult.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchWorkflowRuns() applies the default per page parameter if it is not specified",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(workflowId);
        final runsPage = interactionResult.result;

        expect(runsPage.perPage, isNotNull);
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interactionResult = await client.fetchWorkflowRuns(
          workflowId,
          perPage: expectedPerPage,
        );
        final runsPage = interactionResult.result;

        expect(runsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchWorkflowRuns() fetches the first page if the given page parameter is null",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(
          workflowId,
          page: null,
        );
        final runsPage = interactionResult.result;

        expect(runsPage.page, equals(1));
      },
    );

    test(
      ".fetchWorkflowRuns() fetches the first page if the given page parameter is less than zero",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(
          workflowId,
          page: -1,
        );
        final runsPage = interactionResult.result;

        expect(runsPage.page, equals(1));
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interactionResult = await client.fetchWorkflowRuns(
          workflowId,
          page: expectedPage,
        );
        final runsPage = interactionResult.result;

        expect(runsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the next page url",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(workflowId);
        final runsPage = interactionResult.result;

        expect(runsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with the null next page url if there are no more pages available",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(
          workflowId,
          perPage: 100,
        );
        final runsPage = interactionResult.result;

        expect(runsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page with a list of workflow runs",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(workflowId);
        final runs = interactionResult.result.values;

        expect(runs, isNotNull);
      },
    );

    test(
      ".fetchWorkflowRuns() returns a workflow runs page containing workflow runs with the given status",
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
      ".fetchWorkflowRunsNext() returns a next workflow runs page after the given one",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(
          workflowId,
          page: testPageNumber,
        );
        final runsPage = interactionResult.result;

        final nextInteractionResult = await client.fetchWorkflowRunsNext(
          runsPage,
        );
        final nextRunsPage = nextInteractionResult.result;

        expect(nextRunsPage.page, equals(testPageNumber + 1));
      },
    );

    test(
      ".fetchWorkflowRunsNext() returns an error if the given page is the last page",
      () async {
        final interactionResult = await client.fetchWorkflowRuns(
          workflowId,
          perPage: 100,
        );
        final firstPage = interactionResult.result;

        final nextInteractionResult = await client.fetchWorkflowRunsNext(
          firstPage,
        );
        final isError = nextInteractionResult.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchWorkflowRunByUrl() fails if a workflow run with the given url is not found",
      () async {
        final url =
            '${githubActionsMockServer.url}${githubActionsMockServer.basePath}/runs/2';

        final result = await client.fetchWorkflowRunByUrl(url);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".fetchWorkflowRunByUrl() responds with a workflow run matching the given url",
      () async {
        final url =
            '${githubActionsMockServer.url}${githubActionsMockServer.basePath}/runs/$runId';
        final expected = WorkflowRun(id: runId, apiUrl: url);

        final interaction = await client.fetchWorkflowRunByUrl(url);
        final result = interaction.result;

        expect(result, equals(expected));
      },
    );

    test(
      ".fetchRunJobs() fails if an associated workflow run with such id is not found",
      () async {
        final interactionResult = await client.fetchRunJobs(10);
        final isError = interactionResult.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchRunJobs() applies the default per page parameter if it is not specified",
      () async {
        final interactionResult = await client.fetchRunJobs(runId);
        final jobsPage = interactionResult.result;

        expect(jobsPage.perPage, isNotNull);
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interactionResult = await client.fetchRunJobs(
          runId,
          perPage: expectedPerPage,
        );
        final jobsPage = interactionResult.result;

        expect(jobsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchRunJobs() fetches the first page if the given page parameter is null",
      () async {
        final interactionResult = await client.fetchRunJobs(runId, page: null);
        final jobsPage = interactionResult.result;

        expect(jobsPage.page, equals(1));
      },
    );

    test(
      ".fetchRunJobs() fetches the first page if the given page parameter is less than zero",
      () async {
        final interactionResult = await client.fetchRunJobs(runId, page: -1);
        final jobsPage = interactionResult.result;

        expect(jobsPage.page, equals(1));
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interactionResult = await client.fetchRunJobs(
          runId,
          page: expectedPage,
        );
        final jobsPage = interactionResult.result;

        expect(jobsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the next page url",
      () async {
        final interactionResult = await client.fetchRunJobs(runId);
        final runsPage = interactionResult.result;

        expect(runsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with the null next page url if there are no more pages available",
      () async {
        final interactionResult = await client.fetchRunJobs(
          runId,
          perPage: 100,
        );
        final runsPage = interactionResult.result;

        expect(runsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page with a list of workflow run jobs",
      () async {
        final interactionResult = await client.fetchRunJobs(runId);
        final runs = interactionResult.result.values;

        expect(runs, isNotNull);
      },
    );

    test(
      ".fetchRunJobs() returns a workflow run jobs page containing workflow run jobs with the given status",
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
      ".fetchRunJobsNext() returns a next workflow run jobs page after the given one",
      () async {
        final interactionResult = await client.fetchRunJobs(
          runId,
          page: testPageNumber,
        );
        final jobsPage = interactionResult.result;

        final nextInteractionResult = await client.fetchRunJobsNext(jobsPage);
        final nextJobsPage = nextInteractionResult.result;

        expect(nextJobsPage.page, equals(testPageNumber + 1));
      },
    );

    test(
      ".fetchRunJobsNext() returns an error if the given page is the last page",
      () async {
        final interactionResult = await client.fetchRunJobs(
          runId,
          perPage: 100,
        );
        final firstPage = interactionResult.result;

        final nextInteractionResult = await client.fetchRunJobsNext(firstPage);
        final isError = nextInteractionResult.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchRunArtifacts() fails if an associated workflow run is not found",
      () async {
        final interactionResult = await client.fetchRunArtifacts(10);
        final isError = interactionResult.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".fetchRunArtifacts() applies the default per page parameter if it is not specified",
      () async {
        final interactionResult = await client.fetchRunArtifacts(runId);
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.perPage, isNotNull);
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interactionResult = await client.fetchRunArtifacts(
          runId,
          perPage: expectedPerPage,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchRunArtifacts() fetches the first page if the given page parameter is null",
      () async {
        final interactionResult = await client.fetchRunArtifacts(
          runId,
          page: null,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.page, equals(1));
      },
    );

    test(
      ".fetchRunArtifacts() fetches the first page if the given page parameter is less than zero",
      () async {
        final interactionResult = await client.fetchRunArtifacts(
          runId,
          page: -1,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.page, equals(1));
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interactionResult = await client.fetchRunArtifacts(
          runId,
          page: expectedPage,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the next page url",
      () async {
        final interactionResult = await client.fetchRunArtifacts(runId);
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with the null next page url if there are no more pages available",
      () async {
        final interactionResult = await client.fetchRunArtifacts(
          runId,
          perPage: 100,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchRunArtifacts() returns a workflow run artifacts page with a list of workflow run artifacts",
      () async {
        final interactionResult = await client.fetchRunArtifacts(runId);
        final artifacts = interactionResult.result.values;

        expect(artifacts, isNotNull);
      },
    );

    test(
      ".fetchRunArtifactsNext() returns a next workflow run artifacts page after the given one",
      () async {
        final interactionResult = await client.fetchRunArtifacts(
          runId,
          page: testPageNumber,
        );
        final artifactsPage = interactionResult.result;

        final nextInteractionResult = await client.fetchRunArtifactsNext(
          artifactsPage,
        );
        final nextArtifactsPage = nextInteractionResult.result;

        expect(nextArtifactsPage.page, equals(testPageNumber + 1));
      },
    );

    test(
      ".fetchRunArtifactsNext() returns an error if the given page is the last page",
      () async {
        final interactionResult = await client.fetchRunArtifacts(
          runId,
          perPage: 100,
        );
        final firstPage = interactionResult.result;

        final nextInteractionResult = await client.fetchRunArtifactsNext(
          firstPage,
        );
        final isError = nextInteractionResult.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".downloadRunArtifactZip() fails with the error if the given url is null",
      () async {
        final interactionResult = await client.downloadRunArtifactZip(null);
        final isError = interactionResult.isError;

        expect(isError, isTrue);
      },
    );

    test(
      ".downloadRunArtifactZip() fails with the error if the artifact associated with the given download url is not found",
      () async {
        final downloadUrl = '${client.basePath}artifacts/test/zip';
        final interactionResult = await client.downloadRunArtifactZip(
          downloadUrl,
        );
        final isError = interactionResult.isError;

        expect(isError, isTrue);
      },
    );
  });
}
