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

To download the CI integrations, follow the listed steps:
1. Checkout the [CI integrations releases](https://github.com/platform-platform/monorepo/releases/tag/ci_integrations-snapshot).
2. Download CI integration snapshot depending on your operation system (`macOS` or `Linux`).

#### CI Integrations CLI

Once you've downloaded a tool, you need to mark it as executable by running the following command `chmod a+x file_path`, so you can use it in the terminal by running `ci_integrations <command> [arguments]`, where `command` is one of the available commands.
To get help information about commands usage, run `ci_integrations help <command>` or specify the `-h` (`--help`) flag.

#### Advanced Configurations

After marking the tool file as executable, now you can add the tool `file_path` to your `PATH` variable, which allows you to run the tool in any terminal session just by the filename.
For updating the `PATH` variable, follow the listed steps:

1. Determine the `[PATH_TO_CI_INTEGRATIONS]`, you can check this by running `echo $PWD/ci_integrations`, while in the directory with the tool.
2. Open (or create) the `rc file` for your shell. Typing `echo $SHELL` in your terminal tells you which shell you’re using. If you’re using Bash, edit `$HOME/.bash_profile` or `$HOME/.bashrc`. If you’re using Z shell, edit `$HOME/.zshrc`. If you’re using a different shell, the file path and filename will be different on your machine.
3. Add `export PATH="[PATH_TO_CI_INTEGRATIONS]:$PATH"` to the last line of the `rc file`, where `[PATH_TO_CI_INTEGRATIONS]` is the path where you placed CI Integrations tool.
4. Run source `$HOME/.<rc file>` to refresh the current terminal window, or open a new terminal window to automatically source the file.
5. Verify that the `PATH_TO_CI_INTEGRATIONS` is now in your PATH by running `echo $PATH` or `which ci_integrations`.

### Creating Configuration File

Each CI integration requires configuration file, which represents a `YAML` file the tool uses to define a `source` and `destination` to perform synchronization and builds data importing.
The general structure of the file contains the `source` and `destination` keys,  whose value is key-value pairs with the necessary source and destination-related data, such as access tokens keys, project names, workflow identifiers, etc.

#### Configuration Templates

For all available integrations we have configuration templates that explain all the fields they require and how to fill them with correct values.
Here is a list of the templates: 
- `source` clients:
    * [Github Actions Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/source/github_actions/config/configuration_template.yaml)
    * [Jenkins Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/source/jenkins/config/configuration_template.yaml)
    * [Buildkite Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/source/buildkite/config/configuration_template.yaml)

- `destination` clients:
    * [Firestore Configuration Template](https://github.com/platform-platform/monorepo/raw/ci_user_guide_design/metrics/ci_integrations/docs/destination/firestore/config/configuration_template.yaml)

#### Example

Creating new configuration file requires following these steps:
1. Select one of the templates from the [Configuration templates section](#configuration-templates) that matches your desired source or destination.
2. Create a new configuration file with `.yaml` extension and copy-and-paste the template content in it.
3. Each template has some parameters that you have to fill. A typical template parameter appears like this: `param_name: ...`. Replace each `...` with the required value.
4. Fill in the destination config.
5. Save the newly created template and give it a self-speaking name.

### Making Things Work

Finally, after [CLI configuration](#ci-integrations-cli) and [creating a new configuration file](#creating-configuration-file), we can proceed to perform synchronization using a main `sync` command.
All we need to do additionally is to specify the path to the previously created `configuration file` using the `--config-file=` flag.
Here is a usage example:

```bash
ci_integrations sync --config-file=`your_config_file`
```

#### Automate CI Integrations

The synchronization process described above can be automated within your CI tool, so the `sync` command will be run every time the builds are finished.
[Here](https://github.com/platform-platform/monorepo/blob/master/docs/17_buildkite_ci_integration.md) is an example how to do it for `Buildkite`.

## Results
> What was the outcome of the project?

A guide for users that clarifies the CI Integrations tool using.
