# Metrics Buildkite integration

> Summary of the proposed change

Describe the mechanism of exporting project build data from Buildkite to Metrics automatically.

# References

> Link to supporting documentation, GitHub tickets, etc.

 - [Buildkite agent setup](https://buildkite.com/docs/agent/v3/installation)
 - [Buildkite SSH keys setup](https://buildkite.com/docs/agent/v3/ssh-keys)
 - [Buildkite secrets and environment hooks](https://buildkite.com/docs/pipelines/secrets#storing-secrets-in-environment-hooks)
 - [Connecting Buildkite and Github](https://buildkite.com/docs/integrations/github#connecting-buildkite-and-github)

# Motivation

> What problem is this project solving?

This document describes how to configure Buildkite to export the build data automatically to the Metrics Web application.

# Goals

> Identify success metrics and measurable goals.

This document aims the following goals: 

- Explain how to configure the `Sync Pipeline`
- Explain how to configure the CI Integration config file.
- Explain how to trigger the `Sync pipeline`
- Describe the overall process of the build data export.

# Non-Goals

> Identify what's not in scope.

This document does not describe how to use the Buildkite CI and any related configurations.

# Design

> Explain and diagram the technical design
>
> Identify risks and edge cases

To be able to track the state of the applications under development, we should configure the Buildkite integration that will export the build data to the Metrics Web application.

To export the data, we should complete the following configurations:

1. [Sync pipeline configuration](#Sync-pipeline-configuration)
2. [Integration config setup](#Integration-config-setup)
3. [Triggering Sync pipeline](#Triggering-Sync-pipeline)

## Sync pipeline configuration
First of all, we need to create a `Sync pipeline` in the Buildkite dashboard. To do that, follow these steps:
  - Browse to [Buildkite](https://buildkite.com/).
  - In the navigation bar, click on a dropdown and select your organization.
  - Click the `+` button to create a new pipeline.
  - Type `Sync Pipeline` as the name of a new pipeline.
  - Enter the Git repository URL you want to perform builds on.
  - Click `Create pipeline` and skip the `Webhook setup`.

Now we need to add a step in Buildkite that uploads our pipeline:
  - Proceed to your organization's web page in [Buildkite](https://buildkite.com/).
  - Click on `Sync Pipeline`.
  - In the pipeline navigation bar, click the `Edit Steps` button.
  - Press `Convert to YAML Steps`.
  - In the editor, replace the contents with the following:
    ```yaml
    steps:
      - command: "buildkite-agent pipeline upload .buildkite/pipelines/sync_pipeline.yml"
        label: "Upload Sync pipeline"
    ```

After we've added the upload step in Buildkite, we need to define the `Sync pipeline`:
  - In a connected repository, create or browse to `.buildkite/pipelines` folder.
  - Create `sync_pipeline.yml` file.
  - Add the following contents to the file:
  ```yaml
  steps:
    - label: "Sync builds"
      commands:
        - cd .metrics/buildkite
        - curl -o ci_integrations -k https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_linux -L && chmod a+x ci_integrations
        - eval "echo \"$(sed 's/"/\\"/g' integration_config.yml)\"" >> integration.yml
        - ./ci_integrations sync --config-file integration.yml
  ```

The given pipeline consist of four commands:
 - Navigating to the `.metrics/buildkite` folder in a repository, which contains the config file. Please consider [Integration config setup](#Integration-config-setup).
 - Downloading the `CI integration tool`.
 - Applying environment variables to the `integration_config.yaml`.
 - Running the `sync` command of the `CI integration tool` with the prepared config to synchronize builds.

So, after we created and defined this pipeline, we need to set up the integration config.

## Integration config setup

An `integration config` is a YAML file, that the `CI integration tool` uses to export build data from the source to the destination.

Now let's create an integration config. Please follow these steps:
- In your repository, create or navigate to the `.metrics/buildkite` folder.
- Create `integration_config.yml`.
- Add the following contents to the file:
```yaml
source:
  buildkite:
    access_token: $BUILDKITE_TOKEN
    pipeline_slug: $PIPELINE_SLUG
    organization_slug: YOUR_ORGANIZATION_SLUG
destination:
  firestore:
    firebase_project_id: YOUR_FIREBASE_PROJECT_ID
    firebase_user_email: $WEB_APP_USER_EMAIL
    firebase_user_pass: $WEB_APP_USER_PASSWORD
    firebase_public_api_key: $CI_INTEGRATIONS_FIREBASE_API_KEY
    metrics_project_id: $METRICS_PROJECT_ID
```

Here's an overview of each field in this config.

There are three types of config values depending on how they are exposed:
  1. `secrets` must be stored securely and exposed in the `environment hooks`. These values have ***Secret*** label in the description. Please consider [this link about secrets management in Buildkite](https://buildkite.com/docs/pipelines/secrets#storing-secrets-in-environment-hooks).
  2. `pipeline parameters` are passed from the pipelines that trigger this `Sync pipeline`. These values have ***Pipeline parameter*** label. They would be defined in the [Triggering Sync pipeline](#Triggering-Sync-pipeline) section.
  3. `replace` is defined directly in the config file and **must be substituted** with your specific values. These values have ***Replace*** label.


  - `access_token` - is a [Buildkite access token](https://buildkite.com/docs/apis/rest-api#authentication). ***Secret***
  - `pipeline_slug` - is a unique slug (identifier) of the pipeline in Buildkite the integration should work with. ***Pipeline parameter***
  - `organization_slug` - is a unique slug (identifier) of the organization in Buildkite in the scope of which the integration should work and perform requests. ***Replace***
  - `firebase_project_id` - is a Firebase project identifier, which you can see in the list of projects in the [Firebase console](https://console.firebase.google.com/). ***Replace***
  - `firebase_user_email` - a Firebase user email. ***Secret***
  - `firebase_user_pass` - a Firebase user password. ***Secret***
  - `firebase_public_api_key` - a Firebase public API key. May be ***Replace*** or ***Secret*** if you are using Firebase key protection.
  - `metrics_project_id` - a Firestore metrics project identifier. ***Pipeline parameter***

So after you've configured the `Integration config` let's configure the `Sync pipeline` that exports the build data to the Metrics Web application.

## Triggering Sync pipeline

To make build data exports we need to add a step that notifies the `Sync pipeline`.
Now, to trigger the `Sync pipeline`, add the following step to the end of the pipeline you want to export the build data from.

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

It is very important to run this step regardless of the result of the previous steps. To do that, you need to add `depends_on` for each step to make sure the build continues running if previous steps fail.

Here's an overview of each field in this step:

- `trigger` is a command that triggers another pipeline with the given `pipeline_slug`(in our case - `sync-pipeline`).
- `depends_on` - is a command, that indicates that this step will not run until the `step_key` step has been completed you need to replace the `step_key` with the previous step's key this step depends on.
- `allow_dependency_failure` - is a command, that forces this step to run even if the previous jobs fail or did not run.
- `async` - is a command, that must be set to `true` and forces this step to finish before the triggered pipeline finishes.

Also, you need to define the `environment variables` passed to the `Trigger sync pipeline` from the current pipeline:
 - `PIPELINE_SLUG` - is a unique identifier of the current pipeline. This variable is pre-defined in the pipeline, so you don't need to change it.
 - `METRICS_PROJECT_ID` - is a Firestore Metrics project identifier - you need to replace it with your id.

# API

> What will the proposed API look like?

Once we've configured the Buildkite integration, let's consider the sequence diagram that will explain the main relationships between the different pipelines on the example with the `AwesomePipeline`:
![Buildkite Sync Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/buildkite_integration_docs/docs/diagrams/buildkite_sync_sequence_diagram.puml)

# Dependencies

> What is the project blocked on?

This project has no dependencies.

# Results

> What was the outcome of the project?

The process of configuring the automatic build data exports from Buildkite to Metrics.
