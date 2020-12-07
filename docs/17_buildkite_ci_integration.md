# Metrics Buildkite integration
> Summary of the proposed change.

Describe the mechanism of exporting project build data from Buildkite to Metrics automatically.

# References
> Link to supporting documentation, GitHub tickets, etc.

 - [Buildkite agent setup](https://buildkite.com/docs/agent/v3/installation)
 - [Buildkite SSH keys setup](https://buildkite.com/docs/agent/v3/ssh-keys)
 - [Buildkite secrets and environment hooks](https://buildkite.com/docs/pipelines/secrets#storing-secrets-in-environment-hooks)
 - [Connecting Buildkite and Github](https://buildkite.com/docs/integrations/github#connecting-buildkite-and-github)

# Motivation
> What problem is this project solving?

This document describes how to configure Buildkite CI to export the build data automatically to the Metrics project.

# Goals
> Identify success metrics and measurable goals.

- Provide steps on how to create and configure a pipeline for exporting build data.
- Provide CI integrations configurations to work with Buildkite.
- Describe the overall process of the build data exporting.

# Non-Goals
> Identify what's not in scope.

The Buildkite CI using and related configurations (agents, pipelines, etc.) are out of the scope.

# Design
> Explain and diagram the technical design.
>
> Identify risks and edge cases.

The Metrics Web Application provides the ability to review software project metrics. To make these metrics available in the application, and make these metrics relevant, one should export builds data to the database of the Metrics project. 

With the CI integrations tool, it is possible to automate build data exporting with Buildkite CI. To configure this automation the following steps are required: 

1. [Create and configure a new **Sync Pipeline**](#Create-and-configure-the-Sync-Pipeline)
2. [Create a configuration file for the CI integrations](#Create-CI-integrations-config)
3. [Configure triggering **Sync Pipeline**](#Triggering-Sync-Pipeline)

## Create and configure the Sync Pipeline

First, let's create a new **Sync Pipeline** in the Buildkite dashboard. Consider the following steps:

  1. Browse and log in to the [Buildkite](https://buildkite.com/).
  2. Select your organization in the dropdown on the top bar.
  3. Press the `New Pipeline` (a plus **+**) button above the list of organization pipelines.
  4. Name a new pipeline as `Sync Pipeline` and enter the Git repository URL for a project you would like to export build data.
  5. Press the `Create Pipeline` button and skip the `Webhook setup`.

Once a new pipeline is created, let's configure it to use the pipeline YAML file from the remote. Consider the next steps:

  1. Select a new `Sync Pipeline` on the same page with your organization's pipelines.
  2. Press the `Edit Steps` button on the navigation bar at the top. 
  3. Press the `Convert to YAML Steps` button.
  4. Replace the contents of the opened editor with the following (**.buildkite/path/to/** is a path to the sync pipeline YAML file in your Git repository):
  ```yaml
  steps:
    - command: "buildkite-agent pipeline upload .buildkite/path/to/sync_pipeline.yml"
      label: "Upload Sync Pipeline"
  ```

Finally, let's create a pipeline YAML file for the **Sync Pipeline**. In the connected repository create a new file `.buildkite/path/to/sync_pipeline.yml` with the following contents:
  ```yaml
  steps:
    - label: "Sync builds"
      commands:
        - cd path/to/config/directory
        - curl -o ci_integrations -k https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_linux -L && chmod a+x ci_integrations
        - eval "echo \"$(sed 's/"/\\"/g' integration_config.yml)\"" >> integration.yml
        - ./ci_integrations sync --config-file integration.yml
  ```

Let's take a closer look at the pipeline commands:

 1. Navigating to the directory with configuration file `path/to/config/directory` (consider the [Create CI integrations config](#Create-CI-integrations-config) section).
 2. Downloading the `CI integration` tool we need to use for exporting build data.
 3. Applying environment variables to the configuration file and saving results to the `integration.yml` file.
 4. Running the `sync` command of the `CI integration` tool with the prepared integration config.

Once all the above steps are completed, we're ready to proceed with builds data exporting. The next step is to create the configuration file required for the `CI integration` tool.

## Create CI integrations config

The configuration file is a YAML file that the `CI integration` tool uses to export build data from the source CI to the destination Metrics project database. As some of the values the tool requires shouldn't be public, consider familiarizing yourself with [managing secrets](https://buildkite.com/docs/pipelines/secrets) and [storing secrets in environment hooks](https://buildkite.com/docs/pipelines/secrets#storing-secrets-in-environment-hooks) in Buildkite.

Please note that `Sync Pipeline` uses the configuration file and contains a path to the directory where this file is located. So we should create a config under the same directory as specified in the `Sync Pipeline`. Also, its name should match the name from the pipeline. 
Once the file `path/to/config/directory/integration_config.yml` is created, add the following lines:
```yaml
source:
  buildkite:
    access_token: $BUILDKITE_TOKEN
    pipeline_slug: $PIPELINE_SLUG
    organization_slug: <YOUR_ORGANIZATION_SLUG>
destination:
  firestore:
    firebase_project_id: <YOUR_FIREBASE_PROJECT_ID>
    firebase_user_email: $WEB_APP_USER_EMAIL
    firebase_user_pass: $WEB_APP_USER_PASSWORD
    firebase_public_api_key: $CI_INTEGRATIONS_FIREBASE_API_KEY
    metrics_project_id: $METRICS_PROJECT_ID
```

First, let's consider these types of values in the config file:

  - `Secret` is a value that must be stored securely using the [Buildkite secrets in environment hooks](https://buildkite.com/docs/pipelines/secrets#storing-secrets-in-environment-hooks).
  - `Pipeline` is a pipeline environment variable value that is set from a trigger step environment. Read more about this in a [Triggering `Sync Pipeline` section](#Triggering-Sync-Pipeline).
  - `Public` is a value that can be defined directly in the config file and is **specific to you**.

  Using the above definitions, consider the following table with configuration keys:

 | Key | Type | Description | 
 | ---- | ---- | ---- |
 | `access_token` | `Secret` | A [Buildkite access token](https://buildkite.com/docs/apis/rest-api#authentication) with the `read_artifacts` and `read_builds` access scopes |
 | `pipeline_slug` | `Pipeline` | A unique slug of the Pipeline, which builds would be exported | 
 | `organization_slug` | `Public` | A unique slug of your organization in Buildkite |
 | `firebase_project_id` | `Public` |  A Firebase project identifier from the [Firebase console](https://console.firebase.google.com/) |
 | `firebase_user_email` | `Secret` | A Firebase user email to authorize with Metrics |
 | `firebase_user_pass` | `Secret` | A Firebase user password to authorize with Metrics | 
 | `firebase_public_api_key` | `Public` / `Secret` (if `Firebase key protection` is enabled) | A Firebase API key |
 | `metrics_project_id` | `Pipeline` | A Firestore Metrics project identifier |

As the Sync Pipeline is created and the configuration file for CI integration is ready to use, it's time to configure the pipeline, that we want to export build data for, to trigger synchronization.

## Triggering Sync Pipeline

The main idea of auto-exporting build data is asynchronous triggering the `Sync Pipeline` from the pipeline we want to synchronize. Thus, when the pipeline finishes all of its general steps, it triggers a `Sync Pipeline` to start and provides variables with information about itself. After the async trigger, the pipeline completes, and its results are exported to the Metrics project. The trigger step must depend on the very last pipeline-related step. In other words, the trigger step must be the latest.

Let's consider the step described:
```yaml
  - label: "Trigger sync pipeline"
    trigger: sync-pipeline
    depends_on: "step_key"
    allow_dependency_failure: true
    async: true
    build:
      env:
        PIPELINE_SLUG: "${BUILDKITE_PIPELINE_SLUG}"
        METRICS_PROJECT_ID: "metrics_project_id"
```


The `allow_dependency_failure` flag allows running the trigger even if the step with the key `step_key` finishes with an error. We strongly recommend setting the `depends_on` value to the key of a step that finalizes your build (waits on any other steps to finish).

The `build` section provides the `Sync Pipeline` with environment variables containing the information about what pipeline is triggering export (`PIPELINE_SLUG` variable with `BUILDKITE_PIPELINE_SLUG` value) and what project in the database matches this pipeline (`METRICS_PROJECT_ID` variable with the **specific to you** value).

To read more about the `trigger` step, consider the Buildkite [Trigger Step](https://buildkite.com/docs/pipelines/trigger-step) documentation. Also, the [Managing Step Dependencies](https://buildkite.com/docs/pipelines/dependencies) documentation can help you to understand how to make your trigger step to be the latest.

Well done! Once the trigger step is configured, the auto-exporting is ready to use.

# API
> What will the proposed API look like?

The algorithm for auto-exporting builds data in Buildkite uses three main components: the pipeline we want to export, the `CI integration` tool, and the `Sync Pipeline`. The following sequence diagram demonstrates how these components behave together and how the exporting happens (assume the pipeline to export as `Awesome Pipeline`):

![Buildkite Sync Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/docs/diagrams/buildkite_sync_sequence_diagram.puml)

# Dependencies
> What is the project blocked on?

This project has no dependencies.

# Results
> What was the outcome of the project?

The document that describes the process of configuring the automatic build data exports from Buildkite to Metrics.
