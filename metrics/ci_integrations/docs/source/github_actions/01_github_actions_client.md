# Github Actions API client

## TL;DR
A client for GitHub Actions API allows us to introduce the GitHub Actions CI to the Metrics CI integrations CLI. The implementation of Actions API client is a first step of CI introduction to the Metrics project. The purpose of this document is to provide a design the client related implementations should follow.

## Scope
This document describes the design for the GitHub Actions API client and endpoints we should implement to fit the Metrics requirements.

## Non-scope
Details of the client integration is out of scope of this document.

## References
* [Github Actions API](https://docs.github.com/en/free-pro-team@latest/rest/reference/actions)
* [CI integrations CLI architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)
* [Project metrics definition](https://github.com/platform-platform/monorepo/blob/master/docs/05_project_metrics.md)
* [Third-party API testing](https://github.com/platform-platform/monorepo/blob/master/docs/03_third_party_api_testing.md)

## Design
We should implement the GithubActionsClient and related models in a way they will fit the Metrics and CI integration
 requirements. The main idea is that client performs granular API calls, so the developers can use different methods on demand. Consider the following class diagram that demonstrates a suggested structure.

* Class diagram
![Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/metrics/ci_integrations/docs/source/github_actions/diagrams/github_actions_client_class_diagram.puml)

* Package structure

> * github_actions/
>   * github_actions_client.dart
>   * mappers/
>      * github_action_conclusion_mapper.dart
>      * github_action_status_mapper.dart
>   * models/
>      * github_action_conclusion.dart
>      * github_action_status.dart
>      * workflow_run.dart
>      * workflow_run_artifact.dart
>      * workflow_job.dart
>      * page.dart
>      * workflow_runs_page.dart
>      * workflow_jobs_page.dart
>      * workflow_run_artifacts_page.dart

## Table of methods
| Client method | Endpoint name   |  API endpoint | Description |
|---------------|------------------|-------------|---------------|
| fetchWorkflowRuns, fetchWorkflowRunsNext | [List workflow runs](https://docs.github.com/en/free-pro-team@latest/rest/reference/actions#list-workflow-runs) | **`GET`** /repos/**{owner}**/**{repo}**/actions/workflows/**{workflow_file_name}**/runs | Lists runs for the specified workflow. |
| fetchRunArtifacts, fetchRunArtifactsNext |[List workflow run artifacts](https://docs.github.com/en/free-pro-team@latest/rest/reference/actions#list-workflow-run-artifacts)  | **`GET`** /repos/**{owner}**/**{repo}**/actions/runs/**{run_id}**/artifacts | Lists artifacts for a workflow run. |
| downloadRunArtifactZip| [Download an artifact](https://docs.github.com/en/free-pro-team@latest/rest/reference/actions#download-an-artifact)| **`GET`** /repos/**{owner}**/**{repo}**/actions/artifacts/**{artifact_id}**/zip | Downloads the specified run artifact. |
| fetchRunJobs, fetchRunJobsNext | [List jobs for a workflow run](https://docs.github.com/en/free-pro-team@latest/rest/reference/actions#list-jobs-for-a-workflow-run)  | **`GET`** /repos/**{owner}**/**{repo}**/actions/runs/**{run_id}**/jobs | Lists jobs for a workflow run.|

## Authorization
* Fetching data from private repositories requires authorization. Authorization also increases the maximum number of requests per hour (5000 for authorized users and 60 for unauthorized users).
* For authorization, add the following request header (replace `YOUR_TOKEN` with your valid token):
```
Authorization: token {YOUR_TOKEN}
```
* Here is a [guide](https://docs.github.com/en/enterprise/2.17/user/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) that shows how to generate the authorization token.

## Testing
The client for GitHub Actions API should be tested using the Third-party API testing with Mock Server implementation.
