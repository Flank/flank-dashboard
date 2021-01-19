# CI Integrations Config Validator

## TL;DR

Introducing a `CI Integrations Config Validator` provides an ability to validate the CI Integrations configuration file before the `sync` command to provide additional context about the possible errors in the configuration file.  
For example, if the configuration file contains non-valid email/password used to log in into CI, the used sees the corresponding error before the `sync` process starts.


## References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations Tool Architecture](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

## Goals
> Identify success metrics and measurable goals.

This document aims the following goals: 
- Create a clear design of the CI Integrations Config Validator.
- Provide an overview of steps the new CI Integrations Config Validator requires.

## Design
> Explain and diagram the technical design.

Consider the following steps needed to be able to validate the given configuration file:

1. Create an abstract callable `ConfigValidator` class.
2. Extend the `IntegrationParty` class to provide the `ConfigValidator`.
3. For each source or destination party implement its specific `ConfigValidator`.

Here is a class diagram that demonstrates this:
![Widget class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/validate_config/metrics/ci_integrations/docs/diagrams/ci_integrations_config_validator_class_diagram.puml)

### Making things work

### Capturing Errors


