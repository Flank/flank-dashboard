# Buildkite API client

## TL;DR
A client for Buildkite API allows us to introduce the Buildkite CI to the Metrics CI integrations CLI. The purpose of this document is to provide a design the client related implementations should follow.

## Scope
This document describes the design for the Buildkite API client and endpoints we should implement to fit the Metrics requirements.

## Non-scope
Details of the client integration is out of scope of this document.

## References
* [Buildkite API](https://buildkite.com/docs/apis/rest-api)
* [CI integrations CLI architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)
* [Project metrics definition](https://github.com/platform-platform/monorepo/blob/master/docs/05_project_metrics.md)
* [Third-party API testing](https://github.com/platform-platform/monorepo/blob/master/docs/03_third_party_api_testing.md)

## Design
We should implement the BuildkiteClient and related models in a way they will fit the Metrics and CI integration requirements. The main idea is that client performs granular API calls, so the developers can use different methods on demand. Consider the following class diagram that demonstrates a suggested structure.

* Class diagram
![Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/metrics/ci_integrations/docs/source/buildkite/diagrams/buildkite_client_class_diagram.puml)

* Package structure

> * buildkite/
>   * buildkite_client.dart
>   * mappers/
>      * buildkite_build_state_mapper.dart
>   * models/
>      * buildkite_build_state.dart
>      * buildkite_artifact.dart
>      * buildkite_build.dart
>      * buildkite_builds_page.dart
>      * buildkite_artifacts_page.dart

## Table of methods
| Client method | Endpoint name   |  API endpoint | Description |
|---------------|------------------|-------------|---------------|
| fetchBuildkiteBuilds, fetchBuildkiteBuildsNext | [List buildkite builds](https://buildkite.com/docs/apis/rest-api/builds#list-builds-for-a-pipeline) | **`GET`** /organizations/**{org.slug}**/pipelines/**{pipeline.slug}**/builds | List builds for a pipeline. |
| fetchBuildkiteArtifacts, fetchBuildkiteArtifactsNext |[List buildkite artifacts](https://buildkite.com/docs/apis/rest-api/artifacts#list-artifacts-for-a-build) | **`GET`** /organizations/**{org.slug}**/pipelines/**{pipeline.slug}**/builds/**{build.number}**/artifacts | List artifacts for a build. |
| downloadBuildkiteArtifact| [Download an artifact](https://buildkite.com/docs/apis/rest-api/artifacts#download-an-artifact)| **`GET`**&nbsp;/organizations/**{org.slug}**/pipelines/**{pipeline.slug}**/builds/**{build.number}**/jobs/**{job.id}**/artifacts/**{id}**/download | Downloads the specified build artifact. |

## Authorization
* API access tokens allow to call the API without using your username and password. They can be created on your [API Access Tokens page](https://buildkite.com/user/api-access-tokens), limited to individual organizations and permissions, and revoked at any time from the web interface [or the REST API](https://buildkite.com/docs/apis/rest-api/access-token#revoke-the-current-token).
* Each token has its scope of access to the organization within Buildkite. REST API scopes are very granular and the list of them is presented in the [Token scopes section](https://buildkite.com/docs/apis/managing-api-tokens#token-scopes) of the [Managing API Access Tokens documentation](https://buildkite.com/docs/apis/managing-api-tokens). The `BuildkiteClient` implementation requires the given token to have the following scopes: 
    - `read_builds`
    - `read_artifacts`
* For authorization, add the following request header (replace `YOUR_TOKEN` with your valid token):
```
Authorization: token {YOUR_TOKEN}
```

## Testing
The client for Buildkite API should be tested using the Third-party API testing with Mock Server implementation.
