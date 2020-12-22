# CI Integrations User Guide

## TL;DR

Importing builds data to the Metrics project requires using the [`CI Integrations`](https://github.com/platform-platform/monorepo/tree/ci_integrations-snapshot/metrics/ci_integrations) tool. 
This tool requires configurations to be set up to perform synchronization correctly and make builds data available in the `Metrics Web Application`. 
This document clarifies using and configuring the `CI Integrations` tool to make it more clear for a user.

## References
> Link to supporting documentation, GitHub tickets, etc.

* [CI Integrations Tool Architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)
* [Buildkite CI Integration](https://github.com/platform-platform/monorepo/blob/master/docs/17_buildkite_ci_integration.md)

## Using The CI Integrations Tool

The following subsections cover the points we should clarify in using the CI Integrations tool. Here is a list of them:
1. [Glossary](#glossary)
2. [Downloading the CI Integration tool](#downloading-the-ci-integration-tool)
3. [Creating a configuration file](#creating-a-configuration-file)
4. [Making things work](#make-things-work)

### Glossary

First, let's consider a couple of terms the CI Integration tool uses and what the tool is itself. 

| Term | Description |
| --- | --- |
| CI Integration Tool | A command-line application that helps to import build data to the Metrics project making it available in the Metrics Web Application. Further in the text, **Tool** stands for the `CI Integrations tool` unless otherwise stated |
| source | Is where builds data come from. This is usually a CI you are using to perform your project builds but this also can be a persistent store with your builds data. In general, anything that holds builds data you want to make available in the Metrics Web Application is a **source** |
| destination | Is where builds data are to be stored. This is a persistent store that holds your builds data and that the Metrics Web Application uses to access this data. Currently, we are using the [Cloud Firestore](https://firebase.google.com/docs/firestore) database as a **destination** |

### Downloading The CI Integrations Tool

To download the CI integrations, follow the listed steps:
1. Checkout the [CI integrations releases](https://github.com/platform-platform/monorepo/releases/tag/ci_integrations-snapshot).
2. Download CI integration snapshot depending on your operation system (`macOS` or `Linux`).

#### CI Integrations CLI

Once all configurations are done, you can use CI Integrations in terminal by running `ci_integrations <command> [arguments]`, where `command` is one of the available commands.
To get help information about commands usage, run `ci_integrations help <command>` or specify the `-h` (`--help`) flag.

#### Advanced Configurations

To run CI integration tool you should mark it as executable. To do that - run command `chmod +x file_path` in the terminal.

Also, to simplify the tool usage, you can update your `PATH` variable, which gives you an ability to run it in any terminal session just by the file name.
For updating `PATH` variable, follow the listed steps:

///// ToDO - Rewrite steps ///////
1. Determine the directory where you placed the CI Integration tool.
2. Open the `.bash_profile` or `.bashrc` file in your home directory in a text editor.
3. Add `export PATH="[PATH_TO_CI_INTEGRATIONS]:$PATH"` to the last line of the file, where [PATH_TO_CI_INTEGRATIONS] is the path where you placed CI Integrations tool.
4. Save the file.
5. Run source `$HOME/.<rc file>` to refresh the current terminal window, or open a new terminal window to automatically source the file.
6. Verify that the `PATH_TO_CI_INTEGRATIONS` is now in your PATH by running `echo $PATH`.
/////////////////////////////////

### Creating Configuration File

#### Configuration Templates

#### Example

### Making Things Work

#### Automate CI Integrations







### Configuration templates

Each CI integration requires `config.yaml`, that contains info about the `source` and `destination` clients.

Here is a list of the available templates: 
- `source` clients:
    * [Github Actions Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/source/github_actions/config/configuration_template.yaml)
    * [Jenkins Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/source/jenkins/config/configuration_template.yaml)
    * [Buildkite Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/source/buildkite/config/configuration_template.yaml)

- `destination` clients:
    * [Firestore Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/destination/firestore/config/configuration_template.yaml)

### Adding new configuration

Adding new configuration requires following these steps:
1. Select one of the templates from the [Configuration templates section](#configuration-templates) that matches your desired source or destination.
2. Create a new configuration file with `.yaml` extension and copy-and-paste the template content in it.
3. Each template has some parameters that you have to fill. A typical template parameter appears like this: `param_name: ...`. Replace each `...` with the required value.
4. Fill in the destination config.
5. Save the newly created template and give it a self-speaking name.

### CI Integrations setup

To install the CI integrations, follow the listed steps:
1. Checkout the [CI integrations releases](https://github.com/platform-platform/monorepo/releases/tag/ci_integrations-snapshot).
2. Download CI integration snapshot depending on your operation system (`macOS` or `Linux`).
3. Run command `chmod +x file_path` to make it executable.

Then within the terminal, you can access CI integrations as executable by the `ci_integration_file_path`.

Also, to simplify the tool usage, you can update your `PATH` variable, which gives you an ability to run it in any terminal session just by the file name.
For updating `PATH` variable, follow the listed steps:
1. Determine the directory where you placed the CI Integration tool.
2. Open the `.bash_profile` or `.bashrc` file in your home directory in a text editor.
3. Add `export PATH="[PATH_TO_CI_INTEGRATIONS]:$PATH"` to the last line of the file, where [PATH_TO_CI_INTEGRATIONS] is the path where you placed CI Integrations tool.
4. Save the file.
5. Run source `$HOME/.<rc file>` to refresh the current terminal window, or open a new terminal window to automatically source the file.
6. Verify that the `PATH_TO_CI_INTEGRATIONS` is now in your PATH by running `echo $PATH`.

### CLI commands

Once all configurations are done, you can use CI Integrations in terminal by running `ci_integrations <command> [arguments]`, where `command` is one of the available commands. 
For now, there is one available command - `sync` that synchronizes builds using the given configuration file path by setting the `--config-file=` flag. To get help information about commands usage, run `ci_integrations help <command>` or specify the `-h` (`--help`) flag.

## Results
> What was the outcome of the project?

A guide for users that clarifies the CI Integrations tool using.