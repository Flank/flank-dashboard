# CI Integrations User Guide

## TL;DR

Importing builds data to the Metrics project requires using the [`CI Integrations`](https://github.com/platform-platform/monorepo/tree/master/metrics/ci_integrations) tool. This tool requires configurations to be set up to perform synchronization correctly and make builds data available in the `Metrics Web Application`. This document clarifies using and configuring the `CI Integrations` tool to make it more clear for a user.

## References
> Link to supporting documentation, GitHub tickets, etc.

* [CI Integrations Tool Architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)
* [Buildkite CI Integration](https://github.com/platform-platform/monorepo/blob/master/docs/17_buildkite_ci_integration.md)

## Using The CI Integrations Tool

The following subsections cover the points we should clarify in using the CI Integrations tool. Here is a list of them:
1. [Glossary](#glossary)
2. [Downloading the CI Integration tool](#downloading-the-ci-integrations-tool)
3. [Creating a configuration file](#creating-configuration-file)
4. [Making things work](#making-things-work)

### Glossary

First, let's consider a couple of terms the CI Integration tool uses and what the tool is itself. 

| Term | Description |
| --- | --- |
| **CI Integration Tool** | A command-line application that helps to import build data to the Metrics project making it available in the Metrics Web Application. Further in the text, **Tool** stands for the `CI Integrations tool` unless otherwise stated |
| **source** | Is where builds data come from. This is usually a CI you are using to perform your project builds but this also can be a persistent store with your builds data. In general, anything that holds builds data you want to make available in the Metrics Web Application is a **source** |
| **destination** | Is where builds data are to be stored. This is a persistent store that holds your builds data and that the Metrics Web Application uses to access this data. Currently, we are using the [Cloud Firestore](https://firebase.google.com/docs/firestore) database as a **destination** |

### Downloading The CI Integrations Tool

You can download the built CI Integration tool from the [CI Integrations releases](https://github.com/platform-platform/monorepo/releases/tag/ci_integrations-snapshot) page. Select a release depending on your operation system (at the moment, it can be either `Linux` or `macOS`) and download a binary file. You can also use the following links: 
- [`CI Integrations for Linux`](https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_linux);
- [`CI Integrations for macOS`](https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_macos).

#### CI Integrations CLI

Once you've downloaded the tool, you should mark the appropriate binary file as an executable to be able to use the tool from the terminal. Assume you've downloaded the binary file as the `ci_integration`. You can mark it as executable by running the `chmod` command from the terminal as follows:
 
```bash 
chmod a+x path/to/ci_integrations
```

Or, being in the same directory:

```bash 
chmod a+x ci_integrations
```

Now you can use the tool from the terminal by running `./ci_integrations <command> [arguments]`, where `command` is one of the available commands. To know more about the tool usage you can run the help command or specify the `--help` flag (or `-h` shorthand that stands for `--help`). For example, the following code prints usage information for the tool itself:

```bash 
./ci_integrations --help
```

And the following code prints usage information for the `help` command:

```bash 
./ci_integrations help help
```

#### Advanced Configurations

If you want to be able to use the tool from any place, you can add the `/path/to/ci_integrations` to the `PATH` environment variable. By running the following command from the directory where you've downloaded the `ci_integration`, you can know the full path to the tool:

```bash
echo $PWD/ci_integrations
```

Then use appropriate instructions for your platform on how to add executable to the `PATH` variable. For example, if you're using `bash_profile`:

```bash
echo 'export PATH="$PATH:/path/to/ci_integrations"' >> ~/.bash_profile
```

### Creating Configuration File

The CI Integration tool uses the configuration file to perform the `sync` command that imports builds data from the specified `source` to the specified `destination`. 
The configuration file itself is a `YAML` file with key-value pairs that contain settings required for `source` and `destination` integrations. This file has the following structure:

```yaml
# The `source` key indicates that the nested key-value pairs are related to source integration.
source:
    # This key is an identifier that uniquely defines a source integration that 
    # the CI Integrations tool should use to perform synchronization. 
    <source_integration_indentifier>:
        # Key-value pairs with integration configurations

# The `destination` key indicates that the nested key-value pairs are related to destination integration.
destination:
    # This key is an identifier that uniquely defines a destination integration that 
    # the CI Integrations tool should use to perform synchronization. 
    <destination_integration_indentifier>:
        # Key-value pairs with integration configurations
```

Both the `source_integration_indentifier` and `destination_integration_indentifier` stands for the specific implementation of clients used to perform builds importing. 
Each such client has its own specific list of configuration items it requires. The following table provides you with available integrations, their identifiers, and links to the configuration templates (template for a configuration file that contains this integration):

| Integration | Type | Key | Template | 
| --- | --- | --- | --- |
| GitHub Actions | `source` | `github_actions` | [Configuration template](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/source/github_actions/config/configuration_template.yaml) |
| Jenkins | `source` | `jenkins` | [Configuration template](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/source/jenkins/config/configuration_template.yaml) |
| Buildkite | `source` | `buildkite` | [Configuration template](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/source/buildkite/config/configuration_template.yaml) |
| Firestore | `destination` | `firestore` | [Configuration template](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/destination/firestore/config/configuration_template.yaml) |

### First sync fetch limit

When the CI Integration tool runs sync for the first time for a specific project, it fetches all the project's latest builds. By default, the CI Integrations tool fetches 28 latest build. 

To customize this behaviour, consider the following CLI argument: `--first-sync-fetch-limit <YOUR_FIRST_SYNC_FETCH_LIMIT>`. Now, the CI Integrations tool will fetch no more than `<YOUR_FIRST_SYNC_FETCH_LIMIT>` builds.

_**Note**: The `first-sync-fetch-limit` must be an integer greater than 0. If the user provides an invalid limit, the CI Integration Tool fails with an error._

#### Example

Imagine that you want to expose your GitHub Actions builds to the `Metrics Web Application`. In this case, your `source` integration is GitHub Actions and `destination` is Firestore. Assume that you've already downloaded and configured the CI Integrations tool. The next stage is creating a configuration file for the integrations you require. Let's consider the following steps:
1. Create a new YAML file with a clear, self-speaking name. Let this file be `github_actions_firestore.yaml`.
2. Open the [GitHub Actions configuration template](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/source/github_actions/config/configuration_template.yaml) and copy the `source` part from it. Paste the copied code to the `github_actions_firestore.yaml`.
3. Open the [Firestore configuration template](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/destination/firestore/config/configuration_template.yaml) and copy the `destination` part from it. Paste the copied code to the `github_actions_firestore.yaml`.
4. Fill the configuration file with your values by replacing the `...` for each key. Each configuration template contains the information about how the CI Integration tool uses the values you provide and how you can obtain them. Follow the comments in configuration templates to fill your configuration file with appropriate data.
5. Save your configuration file and keep it private as most of the values you provide should be kept safe.

The following example demonstrates the resulting configuration file:

```yaml
source:
  github_actions:
    workflow_identifier: <GITHUB_WORKFLOW_IDENTIFIER>
    repository_name: <GITHUB_REPOSITORY_NAME>
    repository_owner: <GITHUB_REPOSITORY_OWNER>
    access_token: <GITHUB_ACCESS_TOKEN>
destination:
  firestore:
    firebase_project_id: <FIREBASE_PROJECT_ID>    
    firebase_user_email: <FIREBASE_USER_EMAIL>
    firebase_user_pass: <FIREBASE_USER_PASS>
    firebase_web_api_key: <FIREBASE_WEB_API_KEY>
    metrics_project_id: <METRICS_PROJECT_ID>
```

_**Note**: The order of source and destination parts doesn't matter - the first part can be `destination` and the second can be `source`. But both parts are required and must be presented in the configuration part._

Well done! Your configuration file is ready to use within the `ci_integrations sync` command. The [next section](#making-things-work) describes
 how
 to make all things work together!

### Making Things Work

Once you've [downloaded and configured](#downloading-the-ci-integrations-tool) the CI Integration tool and [created](#creating-configuration-file) a configuration file, you're ready to synchronize your builds and make it available in the Metrics Web Application. 
The main idea is to use the `sync` command the tool provides and specify a path to the configuration file. The tool then creates appropriate clients and uses them to import builds data from the `source` to `destination`. 
For example:

```bash
ci_integrations sync --config-file="path/to/config_file.yaml" --first-sync-fetch-limit 20
```

#### Controlling Builds Coverage Synchronization

By default, the CI Integrations tool fetches coverage data for each build. This coverage data comes from an appropriate coverage artifact published during the CI build. The algorithm fetches artifacts and looks for the required coverage one and then downloads it for parsing. This is a mandatory step, and if fetching or downloading an artifact fails - the synchronization process fails as well. 

If your CI project is not ready to publish coverage data, or if you for some reason want to skip this step and disable coverage fetching, you may use the `--no-coverage` flag. This flag disables any artifacts fetching and manipulating for the sync process. Consider the following example of using the `--no-coverage` flag:

```bash
ci_integrations sync --config-file="path/to/config_file.yaml" --no-coverage
```

_**Note**: All builds synchronized with the `--no-coverage` flag won't contain any coverage information. This may affect the coverage metric available on the Metrics Web Application._

#### Automating CI Integrations

Obviously, it is not very handy to manually run the CI Integrations tool every time you have a new build. You should wait for a new build to finish, then check your configuration file is up-to-date, run a sync command with this configuration file, and then wait for a sync process to complete. 
Moreover, storing a configuration file on your machine may be not as safe as it would like to be. 

The solution is to automate builds data importing within the CI tool you are using. 
The implementation of such automation is out of the scope for this user guide and can be tricky, but the result worth all the efforts. For more information, consider the [Buildkite CI Integration](https://github.com/platform-platform/monorepo/blob/master/docs/17_buildkite_ci_integration.md) document that provides an example of how to configure automatic builds importing for `Buildkite` CI.

## Results
> What was the outcome of the project?

A guide for users that clarifies the CI Integrations tool using.
