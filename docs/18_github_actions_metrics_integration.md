# Metrics GitHub Actions integration.

> Summary of the proposed change

Describe Metrics integration for projects that use GitHub Actions.

# References

> Link to supporting documentation, GitHub tickets, etc.
>
- [Coverage converter](../metrics/coverage_converter/docs/01_coverage_converter_design.md)
- [CI integrations](../metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

# Motivation

> What problem is this project solving?

This document describes the configuration process of GitHub Actions to syncronize build data with Metrics application.

# Goals

> Identify success metrics and measurable goals.

This document aims the following goals: 

- Code coverage data export configuration.
- Explain the CI Integrations configuration process.
- Explain the mechanism of automation build imports using the GitHub Actions and CI Integrations tool.

# Non-Goals

> Identify what's not in scope.

This document does not describe the configuration of building or publishing jobs.

# Coverage artifact uploading

> Explain the process of publishing build artifacts

The `CI Integrations` tool provides an ability to sync the build data with the coverage reports to the Metrics Application. Once you want to include the coverage info in the data imports, you should upload the coverage artifact from the project building job. To export the artifact from the GitHub Actions workflow you can use an [Upload a Build Artifact](https://github.com/marketplace/actions/upload-a-build-artifact) from GitHub Actions Marketplace.

Exported artifact should be in a [specific format](../metrics/ci_integrations/docs/01_ci_integration_module_architecture.md#coverage-report-format). To help with coverage format conversions you can use [Coverage converter](metrics/coverage_converter) tool if your source format is supported by the tool.

Let's consider the example step that will upload the `coverage-summary.json` artifact: 

```yaml
- name: Upload coverage report
  uses: actions/upload-artifact@v2
  with:
    name: coverage_report
    path: directory/coverage/coverage-summary.json
    if-no-files-found: error
```

Let's consider the main parameters of this action: 

- `name` is a name of the artifact available in workflow outputs;
- `path` is a path to the artifact that will be exported;
- `if-no-files-found` specifies whether this job will fail your workflow if no files found by specified `path`.

For more detailed description of all properties see an [Upload a Build Artifact](https://github.com/marketplace/actions/upload-a-build-artifact) marketplace page.

# CI Integrations tool configuration

> Explain the process of creating the CI Integrations tool configuration

To be able to synchronize the build data using the CI Integrations tool we should create `YAML` configuration files for each project that will be used by the CI Integrations tool to sync the build data with the Metrics Web application. Assume we have an `Awesome Project` and an `awesome_actions.yml` workflow file with `Awesome Project Actions` job used to run tests of the `Awesome Project` and publish the `coverage_report` as a build artifact. If so, let's create a sample configuration file for this project: 

```yaml
source:
  github_actions:
    workflow_identifier: awesome_actions.yml
    repository_name: awesome_repository
    repository_owner: awesome
    access_token: $GITHUB_TOKEN
    job_name: Awesome Project Actions
    coverage_artifact_name: coverage_report
destination:
  firestore:
    firebase_project_id: project_id
    firebase_user_email: $FIREBASE_USER_EMAIL
    firebase_user_pass: $FIREBASE_USER_PASSWORD
    firebase_public_api_key: $FIREBASE_PUBLIC_API_KEY
    metrics_project_id: awesome_project
```

So, the configuration consists of the following prperties: 

| Property name           | Type           | Description  |
| ----------------------- |:--------------:| ----------------------------------|
| workflow_identifier     | Public         | An identifier of the building workflow to export data from. The workflow identifier is a workflow file name. |
| repository_name         | Public         | A name of the repository that contains the specified workflow. |
| repository_owner        | Public         | A username or an organization name that owns the repository. |
| access_token            | Secret         | A GitHub API access token. Since we are using the GitHub actions to run the synchronization, we can use the default token from secrets `${{ secrets.GITHUB_TOKEN }}`, but, you can create separate personal access token using this [guide](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token). Your token should have the `repo` scope to be able to load the data from the GitHub Actions API.|
| job_name                | Public         | A name of the job inside of the workflow with the provided `workflow_identifier`. The build data of this job will be exported to the Metrics Web Application.|
| coverage_artifact_name  | Public         | A name of the coverage artifact exported from the building workflow with the specified `workflow_identifier`. Notice, that the coverage artifact should be in the [CI Integrations format](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md#coverage-report-format). |
| firebase_project_id      | Public | A firebase project identifier where to export the data. |
| firebase_user_email      | Secret | A firebase user email used to log in to the Metrics Web Application. |
| firebase_user_pass       | Secret | A firebase user password used to log in to the Metrics Web Application. |
| firebase_public_api_key  | Public/Secret |  A public API key that could be created using the Google Cloud Platform in the [API & Services credentials](https://console.cloud.google.com/apis/credentials?project=metrics-d9c67) section. This key should have access to the `Identity Toolkit API`. For more information about Firebase API Keys check [this article](https://firebase.google.com/docs/projects/api-keys). <br /> This value can be stored both as a secret and as a public one, bet we suggest storing it as a secret as it's hard to place proper restrictions on it (GitHub Actions builders pool of IP addresses is large, etc.). |
| metrics_project_id       | Public | A firestore document identifier of the project to import data to. |

__*Please, NOTE*__ that the `Secret` values must be stored as [GitHub Secrets](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets). The configuration file can contain these fields as environment variables. To replace them in the GitHub actions workflow, you can use `envsubst` command from the `gettext` package or replace it using the `sed` tool. An example of the step which replaces the environment variables in the configuration file provided below:  

```yaml
      - name: Apply environment variables
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          WEB_APP_USER_EMAIL: ${{ secrets.WEB_APP_USER_EMAIL }}
          WEB_APP_USER_PASSWORD: ${{ secrets.WEB_APP_USER_PASSWORD }}
          CI_INTEGRATIONS_FIREBASE_API_KEY: ${{ secrets.CI_INTEGRATIONS_FIREBASE_API_KEY }}
        run: eval "echo \"$(sed 's/"/\\"/g' awesome_config.yml)\"" >> integration.yml
```

As you can see, you should specify all the environment variables used in the configuration file in the `env` section of the step. To get access to the `GitHub Secrets` in the `GitHub Actions`, you can use the following notation `${{ secrets.YOUR_SECRET_NAME }}`, where the `YOUR_SECRET_NAME` is a name of the secret configured in your GitHub Repository.

Then you should specify the command used to replace the environment variables in the file. You can use the command from the example that does not require any additional packages installed for macOS and Linux platforms but can be less readable, or use the `envsubst` command from the `gettext` command-line tool to make it more human-readable. The example of using the `envsubst` provided below: 

`envsubst < awesome_config.yml > integration.yml`

The `gettext` installation process described in this article: [Install Gettext](https://www.drupal.org/docs/8/modules/potion/how-to-install-setup-gettext).

# GitHub Actions configuration

> Explain the process of creating the GitHub Actions used to synchronize the build data

Once we've finished creating the configuration file, we should configure the GitHub Actions, which will export the build data to the Metrics Web application. Let's review a sequence diagram that will show the main actions and explain the relationships between them:

![GitHub Actions Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/github_actions_integrations_doc/docs/diagrams/github_actions_sequence_diagram.puml)

As we see in the diagram above, we should configure the following actions for synchronization: 

- [`Notify about the finishing awesome project build`](#Notify-about-the-finishing-awesome-project-build) - the job needed to notify the `Metrics Integration Actions` that some project build is about to finish.
- [`Metrics Integration Actions`](#Metrics-Integration-Actions) - the workflow needed to export the data to the Metrics Web application using the CI Integrations component.

Let's consider each action in more detail.

## Notify about the finishing awesome project build

The `Notify about the finishing awesome project build` step notifies the `Metrics Integration Actions` about some project's build is about to finish. This job should emit a repository dispatch event containing `client_payload` with the `building_awesome_project` boolean field in the `client_payload`. To send the repository dispatch event, we are using the [Repository Dispatch](https://github.com/marketplace/actions/repository-dispatch) action.

This job is required because the `CI Integrations` tool only synchronizes the build data, and we should ensure that the build is finished before running the synchronization. It is needed because we should be sure that the `CI Integrations` tool will import the real build status and build duration to the Metrics Application.  Also, the `CI Integrations` tool collects the coverage information for the build assets, and the GitHub Actions exposes the assets only when the workflow finishes.

Also, to reduce the amount of time taken for the `Metrics Integration Actions` workflow, we should run the `Notify about the finishing awesome project build` job after all jobs in the project building workflow. To do so, this job should depend on all jobs from the current workflow, defining the [needs](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobsjob_idneeds) key in the configuration file. Moreover, the `Notify about the finishing awesome project build` job should run even if any of the other jobs canceled/failed, so it should include the `if: "always()"` option.

Let's consider the example of the `Notify about the finishing awesome project build` job for `Awesome project` in our repository: 

Assume we have a workflow containing the following jobs: 

- `Run tests` with `run_awesome_tests` identifier.
- `Build and publish` with `build_and_publish_app` identifier.


So, the `Notify about the finishing awesome project build` for this project will look like this: 

```yml
  notify-actions:
    name: Notify about building the Awesome project
    runs-on: macos-latest
    needs: [ run_awesome_tests, build_and_publish_app ]
    if: "always()"
    steps:
      - name: Notify about building the Awesome project
        uses: peter-evans/repository-dispatch@v1
        with:
          token: ${{ secrets.ACTIONS_TOKEN }}
          repository: platform-platform/monorepo
          event-type: building_project
          client-payload: '{"building_awesome_project": "true"}'
```

As you can see above, the `Notify about building the Awesome project` uses `ACTIONS_TOKEN` secret environment variable. This secret is a [GitHub personal access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) configured to have access to all public and private repositories of the user.


## Metrics Integration Actions

A `Metrics Integration Actions` is a workflow used to export the build data to the Metrics Web application. This workflow triggers on repository dispatch event with `building_project` type sent by `Notify about the finishing awesome project build` job. The `building_project` repository dispatch event, in its turn, should contain the information about which project build started as a `client_payload` JSON. 

Let's consider the sample `Metrics Integration Actions` workflow file: 

```yaml
name: Metrics Integration Actions

on:
  repository_dispatch:
    types: [ building_project ]

jobs:
  awesome_project_sync:
    name: Awesome Project build data sync
    runs-on: macos-latest
    if: github.event.client_payload.building_awesome_project == 'true'
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 1
          ref: ${{ github.ref }}
      - name: Download Ci integrations
        run: |
          curl -o ci_integrations -k https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_macos -L
          chmod a+x ci_integrations
      - name: Wait For Awesome Project check finished
        uses: fountainhead/action-wait-for-check@v1.0.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          checkName: Notify about building the Awesome Project
          ref: ${{ github.sha }}
          timeoutSeconds: 3600
      - name: Apply environment variables
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          WEB_APP_USER_EMAIL: ${{ secrets.WEB_APP_USER_EMAIL }}
          WEB_APP_USER_PASSWORD: ${{ secrets.WEB_APP_USER_PASSWORD }}
          CI_INTEGRATIONS_FIREBASE_API_KEY: ${{ secrets.CI_INTEGRATIONS_FIREBASE_API_KEY }}
        run: eval "echo \"$(sed 's/"/\\"/g' awesome_config.yml)\"" >> integration.yml
        working-directory: awesome_project/
      - name: Awesome Project build data sync
        run: ./ci_integrations sync --config-file .metrics/integration.yml
```

So, once the `Metrics Integration Actions` workflow receives the `building_project` repository dispatch event, it gets the project that is currently building from the `client_payload` and starts the synchronization job that corresponds to the building project to export the building data. The synchronization job, in its turn, checkouts the repository, waits until the project's building job gets finished, downloads the `CI Integrations` tool, and runs the synchronization process.

__*Please, NOTE*__  that since we are using the [Wait For Check](https://github.com/marketplace/actions/wait-for-check) action that allows us to wait until the job gets finished, we should wait until the last workflow job gets finished. Usually, this job is a `Notify about the finishing awesome project build`. It is needed to be sure that the project's building workflow is finished and we can get the building artifacts from this workflow if there any.


# Dependencies

> What is the project blocked on?

This project has no dependencies.

> What will be impacted by the project?

The GitHub actions configuration process will be impacted.

# Testing

> How will the project be tested?

This project will be tested manually. 

# Alternatives Considered

> Summarize alternative designs (pros & cons)

No alternatives considered.

# Results

> What was the outcome of the project?

The configuration process was described with examples provided.
