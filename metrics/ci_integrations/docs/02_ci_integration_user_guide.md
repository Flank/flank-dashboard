# CI Integrations User Guide

## TL;DR

Importing user's CI data requires using CI integrations tool and adding a new source and a new destination configuration that stores the necessary source and destination-related data, such as access tokens keys, project names, workflow identifiers, etc. The purpose of this document is to describe how to use the CI integrations tool, so user can set up it for his/her CI data.

## References
> Link to supporting documentation, GitHub tickets, etc.

* [CI Integrations Module Architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)
* [Buildkite CI Integration](https://github.com/platform-platform/monorepo/blob/master/docs/17_buildkite_ci_integration.md)

## CI Integrations tool usage

The following subsections describe how to add new configurations, where to get the CI integrations tool and how to run it.

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
For now, there is one available command - `sync` that synchronizes builds using the given configuration file path by setting the `--config-file=` flag.
To get help information about commands usage, run `ci_integrations help <command>` or specify the `-h` (`--help`) flag.

## Results
> What was the outcome of the project?

The document describing the CI Integrations tool usage.