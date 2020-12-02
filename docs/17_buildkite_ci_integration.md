# Overview

`Buildkite` - an Integrated continuous integration and continuous deployment for software projects.

To get started you only need to understand its `Core Concepts`:

 - [Agent](#agent-description)
 - [Pipeline](#pipeline-description)
 - [Steps](#steps-description)

## Agent

`Buildkite agents` are small, reliable and cross-platform build runners that run automated builds. It runs on your own machine, whether it's a VPS, server, desktop computer, etc.

To learn more about `agents` consider the following link: https://buildkite.com/docs/agent/v3

## Pipeline

A `pipeline` is a template of the steps you want to run. Connecting `pipelines` to your source control(e.g. Github) allows you to run builds when your code changes.

When you run a pipeline, a build is created.

To learn more about `pipelines` consider the following link: https://buildkite.com/docs/pipelines

## Steps

`Steps` are the lists of commands need to run for the specific `pipeline`.

Pipeline `steps` are defined in YAML and are either stored in Buildkite or in your repository using a `pipeline.yml`(gives you access to more configuration options and environment variables) file.

The following example YAML defines a pipeline with two command steps:

```yaml
steps:
  - label: "Example Test"
    command: echo "Hello!"
  - label: "Tests"
    command:
      - "npm install"
      - "tests.sh"
```

To learn more about `steps` consider the following link: https://buildkite.com/docs/pipelines/defining-steps

The following sequence diagram shows how the Buildkite works:

![Buildkite sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/docs/diagrams/buildkite_sequence_diagram.puml)

# Metrics integration

To be able to track the state of the applications under development, we should configure the Buildkite integration that will export the build data to the Metrics Web application.

## Table of contents

1. [Configuring the Sync Pipeline](#Sync-pipeline-configuration)
2. [Creating the Integration config YAML](#Integration-config-YAML)
2. second
3. third

## Sync pipeline configuration

### Overview

First of all, we need to create a `Sync pipeline` in the Buildkite dashboard. To do that, follow these steps:
  - Browse to [Buildkite](https://buildkite.com/).
  - In the navigation bar, click on a dropdown and select your organization.
  - Click `+` button to create a new pipeline.
  - Type `Sync Pipeline` as a name of a new pipeline.
  - Enter the Git repository URL you want to perform builds on.
  - Click `Create pipeline` and skip the `Webhook setup`.

Now we need to add a step in Buildkite that uploads our pipeline:
  - Proceed to your organization's web page in [Buildkite](https://buildkite.com/).
  - Click on `Sync Pipeline`.
  - In the pipeline navigation bar, click `Edit Steps` button.
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

So, after we created and defined this pipeline, we need to setup integration config.

### Integration config setup

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

Here's an overview of an each field in this config.

There three types of config values depending on how they are exposed:
  1. `secrets` must be stored securely and exposed in the `environment hooks`. These values have ***Secret*** label in the description. Please consider [this link about secrets management in Buildkite](https://buildkite.com/docs/pipelines/secrets#storing-secrets-in-environment-hooks).
  2. `pipeline parameters` are passed from the pipelines that trigger this `Sync pipeline`. These values have ***Pipeline parameter*** label. They would be defined in the [Triggering Sync pipeline](#Triggering-Sync-pipeline) section.
  3. `replace` are defined directly in the config file and **must be substituted** with your specific values. These values have ***Replace*** label.


  - `access_token` - is a [Buildkite access token](https://buildkite.com/docs/apis/rest-api#authentication). ***Secret***
  - `pipeline_slug` - is a unique slug (identifier) of the pipeline in Buildkite the integration should work with. ***Pipeline parameter***
  - `organization_slug` - is a unique slug (identifier) of the organization in Buildkite in the scope of which the integration should work and perform requests. ***Replace***
  - `firebase_project_id` - is a Firebase project identifier, which you can see in the list of projects in the [Firebase console](https://console.firebase.google.com/). ***Replace***
  - `firebase_user_email` - a Firebase user email. ***Secret***
  - `firebase_user_pass` - a Firebase user password. ***Secret***
  - `firebase_public_api_key` - a Firebase public API key. May be ***Replace*** or ***Secret*** if you are using Firebase key protection.
  - `metrics_project_id` - a Firestore metrics project identifier. ***Pipeline parameter***

So after you've configured the `Integration config` let's proceed to configuring the `Sync pipeline` that exports the build data to Metrics Web application.

### Triggering Sync pipeline

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

Here's an overview of an each field in this step:

- `trigger` is a command that triggers another pipeline with the given `pipeline_slug`(in our case - `sync-pipeline`).
- `depends_on` - is a command, that indicates that this step will not run until the `step_key` step has completed you need to replace the `step_key` with the the previous step's key this step depends on.
- `allow_dependency_failure` - is a command, that forces this step to run even if the previous jobs fail or did not run.
- `async` - is a command, that must be set to `true` and forces this step to finish before the triggered pipeline finishes.

Also, you need to define the `environment variables` passed to the `Trigger sync pipeline` from the current pipeline:
 - `PIPELINE_SLUG` - is a unique identifier of the current pipeline. This variable is pre-defined in the pipeline, so you don't need to change it.
 - `METRICS_PROJECT_ID` - is a Firestore Metrics project identifier - you need to replace it with your id.

## Metrics integration sequence diagram
How it works

## Other configuration

 - [Agent setup](https://buildkite.com/docs/agent/v3/installation)
 - [SSH Keys](https://buildkite.com/docs/agent/v3/ssh-keys)
 - [Secrets and environment hooks](https://buildkite.com/docs/pipelines/secrets#storing-secrets-in-environment-hooks)
 - [Github integration](https://buildkite.com/docs/integrations/github#connecting-buildkite-and-github)
