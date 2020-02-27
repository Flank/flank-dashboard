# Project name
> Summary of the proposed change

# References
> Link to supporting documentation, GitHub tickets, etc.

# Motivation
> What problem is this project solving?

# Goals
> Identify success metrics and measurable goals.

# Non-Goals
> Identify what's not in scope.

# Design
> Explain and diagram the technical design
>
> Identify risks and edge cases

# API
> What will the proposed API look like?

# Bitrise

## Deploy artifacts to Bitrise
Artifacts are deployed into bitrise.io with the help of the **Deploy to Bitrise.io** Step. Use the following steps to get generated files accessible within build:
1. Generate artifacts during one of workflow steps.
2. Insert the Deploy to Bitrise.io Step AFTER the Step(s) that generate the artifacts.
3. Change target directory directory path in the **Deploy directory or file path** field under the **Config** section of the step if required.
   For example `$BITRISE_SOURCE_DIR/build/` or `$BITRISE_SOURCE_DIR/coverage/`. 

More information [here](https://devcenter.bitrise.io/builds/build-artifacts-online/).

## Create Personal Access Token for API
The authorization is required to communicate with Bitrise API. For this purpose the user can generate a Personal access token.
1. On Bitrise navigate to your [Account settings](https://www.bitrise.io/me/profile) and click on the [Security tab](https://app.bitrise.io/me/profile#/security).
2. Scroll to the **Personal access token (BETA)** section and press the **Generate new** button.
3. Provide token description (must be unique) and select expiration duration in the popup. **Save & Continue** to proceed.
4. Next popup will contain token generated. **Make sure to copy your new personal access token. You won’ be able to see it again!**
5. Use a new token in requests by setting `Authorization: <access token>` header.

For more detailed instructions please see [discussion](https://discuss.bitrise.io/t/personal-access-tokens-beta/1383) and [documentation](https://devcenter.bitrise.io/jp/api/authentication/). 

## Retrieve artifacts via API
Bitrise provides several endpoints to work with builds and artifacts. Here is a list of endpoints you can use to import code coverage artifact:
 - **GET** `/apps/{app-slug}/builds` responses with a list of builds. Each build contains `slug` field which stands for ID of this build. Select one you want to load code coverage artifact for and proceed to next endpoint.
 - **GET** `/apps/{app-slug}/builds/{build-slug}/artifacts` responses with a list of artifacts generated and deployed during the build specified by `build-slug` path parameter. Select one you need and use it `slug` field within the next endpoint.
 - **GET** `/apps/{app-slug}/builds/{build-slug}/artifacts/{artifact-slug}` responses with an artifact description specified by `artifact-slug` path parameter. The response body contains JSON with the `expiring_download_url` field containing URL for downloading artifact.

More information in accessing artifacts you can find in [documentation](https://devcenter.bitrise.io/getting-started/managing-files-on-bitrise/). Bitrise API [specification](https://api-docs.bitrise.io/#/).

# Buildkite

## Deploy artifacts to Buildkite
Artifacts can be uploaded automatically after a pipeline's build step finishes its execution. This requires additional configurations to the build step using either web UI on Builkite or `pipeline.yml` configuration file in your project.
- **Using web UI**:
    1. Under the **Steps** section within pipeline settings create a new step pressing **Add** button or select an existing step from the list.
    2. On the right-side of step's configuration panel expand the **Automatic Artifact Uploading** option.
    3. Define path pattern to the artifacts you want to upload after the step finishes (multiple paths must be separated by a semicolon). For example, `logs/**/*`, `tmp/**/*.png`, `logs/**/*;tmp/**/*.png` and so on.
- **Using `pipeline.yml`**:
    1. Go to the step you want to configure artifacts uploading for.
    2. Set the `artifact_paths` attribute on your command step with path pattern(s) (see example below).
    ```yaml
    steps:
      - label: ":test: Coverage"
        commands:
          - bash coverage.sh
        artifact_paths:
          - coverage/*
    ```

To get more familiar with Buildkite [pipelines](https://buildkite.com/docs/pipelines), [artifacts](https://buildkite.com/docs/pipelines/artifacts), etc. please consider to read [documentation](https://buildkite.com/docs/tutorials/getting-started).

## Create API Access Token
The authorization is required to communicate with Buildkit API. Buildkite provides an ability to [manage](https://buildkite.com/docs/apis/managing-api-tokens) API Access Tokens and their scopes within organization and within [user settings](https://buildkite.com/user/api-access-tokens). The following steps may be used to create a new Access Token:
1. Navigate to [user personal settings](https://buildkite.com/user/settings) and click one the [API Access Token tab](https://buildkite.com/user/api-access-tokens).
2. Press the **New API Access Token** button to create new token.
3. On token creation form set the Organization Access and desired **REST API Scopes** (for example, importing artifacts requires `read_builds` and `read_artifacts` scopes).
4. Submit creating new token by pressing the **Create New API Access Token** button at the bottom of the page.
5. Confirm your password and take a copy of new token created, as it won't be visible again.
6. Use a new token in requests by setting `Authorization: Bearer <access token>` header.

## Retrieve artifacts via API
There are several ways to retrieve artifacts using Buildkite API.
- **GET** `/organizations/{organization_slug}/builds` responses with a list of builds for the organization specified by `organization_slug`. Each build contains a list of jobs (i.e. Step execution) and each job contain a URL you can use to retrieve its artifacts.
    ```text
    {
      "id": "build_id",
      // ...
      "jobs": [
        {
          "id": "job_id",
          // ...
          "artifacts_url": "https://.../organizations/{organization_slug}/pipelines/{pipeline_slug}/builds/{build_number}/jobs/{job_id}/artifacts"
        }
      ] 
    }
    ```
- **GET** `/organizations/{organization_slug}/pipelines/{pipeline_slug}/builds` responses with a list of builds for the pipeline specified by `pipeline_slug`. This endpoint acts like the above one but is more specific.
- **GET** `/organizations/{organization_slug}/pipelines/{pipeline_slug}/builds/{build_number}/artifacts` responses with a list of artifacts generated by all jobs of a build specified by `build_number`. Each artifact contains the `download_url` field which you can use to download artifact.
    ```text
    {
      "id": "artifact_id",
      // ...
      "download_url": "https://.../organizations/{organization_slug}/pipelines/{pipeline_slug}/builds/{build_number}/jobs/{job_id}/artifacts/{artifact_id}/download"
    }
    ```
- **GET** `/organizations/{organization_slug}/pipelines/{pipeline_slug}/builds/{build_number}/jobs/{job_id}/artifacts` responses with a list of artifacts generated by job specified by `job_id`. Artifact object structure is the same as in the above endpoint.
- **GET** `/organizations/{organization_slug}/pipelines/{pipeline_slug}/builds/{build_number}/jobs/{job_id}/artifacts/{id}/download` responses with an artifact specified by `id`. This endpoint stands for the download URL of artifact.

More information in accessing artifacts you can find in [Artifacts API documentation](https://buildkite.com/docs/apis/rest-api/artifacts). Bitrise API [documentation](https://buildkite.com/docs/apis).

# CircleCI

## Deploy artifacts to Buildkite
CircleCI build job can be configured to store generated artifacts as follows:
1. In `.circleci/config.yml` go to a job you want to configure artifacts uploading for.
2. Add the `store_artifacts` attribute to the `steps` section of the job. There is no limitations in number of `store_artifacts` steps within one job.
3. In `store_artifacts` specify the `path` with path to directory/file you want to deploy (see example of such file below).
```yaml
version: 2.1
workflows:
  main:
    jobs:
      - build
jobs:
  build:
    machine:
      image: ubuntu-1604:201903-01
    steps:
      - checkout
      - run:
          name: Creating Code Coverage Artifact
          command: bash coverage.sh
      - run:
          name: Check codecove
          command: ls
      - store_artifacts:
          path: coverage/

```

More information in artifacts storing can be found [here](https://circleci.com/docs/2.0/artifacts/). To get more familiar with CircleCI follow this [link](https://circleci.com/docs/2.0/about-circleci/#section=welcome).

## Create API Access Token
Some CircleCI endpoints requires authorization to communicate with them. CircleCI provides an ability to create Personal API Token that allows to act through API with no limitations. The following steps may be used to create a new token:
1. Navigate to [Personal API Tokens tab](https://account.circleci.com/tokens) under [User Settings page](https://account.circleci.com/settings/user).
2. Press the **Create New Token** button and type token name in the popup.
3. Proceed by pressing **Add API Token** and copy a new token (make sure to take a copy at this step as token won't be visible again).
4. Use the token in requests by using either a Basic Auth with **Authorization**, **Circle-Token** header or another way provided in CircleCI API ([v1.1](https://circleci.com/docs/api/#get-authenticated), [v2](https://circleci.com/docs/api/v2/#authentication)).

## Retrieve artifacts via API


# Dependencies
> What is the project blocked on?

> What will be impacted by the project?

# Testing
> How will the project be tested?

# Alternatives Considered
> Summarize alternative designs (pros & cons)

# Timeline
> Document milestones and deadlines.

DONE:

  - 

NEXT:

  - Populate the document with missing sections.
  - Document importing code coverage artifact for all supported CI tools.
  
# Results
> What was the outcome of the project?

Work in progress.