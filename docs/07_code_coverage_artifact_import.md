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

## Create personal access token for API
The authorization is required to communicate with Bitrise API. For this purpose the user can generate a Personal access token.
1. On Bitrise navigate to your [Account settings](https://www.bitrise.io/me/profile) and click on the [Security tab](https://app.bitrise.io/me/profile#/security).
2. Scroll to the **Personal access token (BETA)** section and press the **Generate new** button.
3. Provide token description (must be unique) and select expiration duration in the popup. **Save & Continue** to proceed.
4. Next popup will contain token generated. **Make sure to copy your new personal access token. You won’ be able to see it again!**
5. Done.

For more detailed instructions please see [discussion](https://discuss.bitrise.io/t/personal-access-tokens-beta/1383) and [documentation](https://devcenter.bitrise.io/jp/api/authentication/). 

## Retrieve artifact via API
Bitrise provides several endpoints to work with builds and artifacts. Here is a list of endpoints you can use to import code coverage artifact:
 - **GET** `/apps/{app-slug}/builds` responses with a list of builds. Each build contains `slug` field which stands for ID of this build. Select one you want to load code coverage artifact for and proceed to next endpoint.
 - **GET** `/apps/{app-slug}/builds/{build-slug}/artifacts` responses with a list of artifacts generated and deployed during the build specified by `build-slug` path parameter. Select one you need and use it `slug` field within the next endpoint.
 - **GET** `/apps/{app-slug}/builds/{build-slug}/artifacts/{artifact-slug}` responses with an artifact description specified by `artifact-slug` path parameter. The response body contains JSON with `expiring_download_url` field containing URL for downloading artifact.

More information in accessing artifacts you can find in [documentation](https://devcenter.bitrise.io/getting-started/managing-files-on-bitrise/). Bitrise API [specification](https://api-docs.bitrise.io/#/).

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