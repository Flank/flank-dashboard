# CI Integrations User Guide
## TL;DR

Importing user's CI data requires using ci_integration tool and adding a new source and a new destination configuration that stores the necessary source and destination-related data, such as access tokens keys, project names, workflow identifiers, etc. The purpose of this document is to describe how to use ci_integrations tool, so user can set up it for his/her CI data.

## References
> Link to supporting documentation, GitHub tickets, etc.

* [CI Integrations Module Architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

## CI integration tool usage

### Configuration templates

* [Github Actions source Configuration Template](https://github.com/platform-platform/monorepo/tree/fix_configuration_templates/metrics/ci_integrations/docs/source/github_actions/config/github_actions_source.yaml)
* [Jenkins Source Configuration Template](https://github.com/platform-platform/monorepo/tree/fix_configuration_templates/metrics/ci_integrations/docs/source/jenkins/config/jenkins_source.yaml)
* [Buildkite Source Configuration Template](https://github.com/platform-platform/monorepo/tree/fix_configuration_templates/metrics/ci_integrations/docs/source/buildkite/config/buildkite_source.yaml)
* [Firestore Destination Configuration Template](https://github.com/platform-platform/monorepo/tree/fix_configuration_templates/metrics/ci_integrations/docs/destination/firestore/config/firestore_destination.yaml)

### Adding new configuration

Adding new configuration requires following these steps:
1. Select one of the templates from the [Configuration templates section](#configuration-templates) that matches your desired source or destination.
2. Create a new configuration file with `.yaml` extension and copy-and-paste the template content in it.
3. Each template has some parameters that you have to fill. A typical template parameter appears like this: `param_name: ...`. Replace each `...` with the required value.
4. Fill in the destination config.
5. Save the newly created template and give it a self-speaking name.

### CLI setup
### CLI commands
## Configuration templates
## Adding new configuration

## Usage

You can use the newly created configuration using the sync command. 
To use the newly created config, use the `--config-file=` flag and specify the path to the configuration file.
