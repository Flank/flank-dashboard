# CI integrations module functionality.
> Summary of the proposed change

The 

 # References
> Link to supporting documentation, GitHub tickets, etc.

- [Plant UML](http://plantuml.com/guide)

# Motivation
> What problem is this project solving?

As the CI integration module is required to be extendable in order to support new integrations, it should be well documented. Along with great documentation, the module is required to be provided with appropriate artifacts explaining its common functionalities and how to add new integrations.

# Goals
> Identify success metrics and measurable goals.

Simple to implement new architecture.

# Non-Goals
> Identify what's not in scope.

# Design

> Explain and diagram the technical design

![Class Diagram SVG](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/plant_uml_diagram/metrics/ci_integrations/docs/ci_integrations_class_diagram.puml)

> Identify risks and edge cases

# API
> What will the proposed API look like?

`SyncCommand` → `SupportedIntegrationParties` → `SupportedSourceParties` → `SourceConfigParser`

`SyncCommand` → `SupportedIntegrationParties` → `SupportedSourceParties` → `SourceClientFactory`

`SyncCommand` → `SupportedIntegrationParties` → `SupportedDestinationParties` → `DestinationConfigParser`

`SyncCommand` → `SupportedIntegrationParties` → `SupportedDestinationParties` → `DestinationClientFactory`

`SyncCommand` → `CiIntegration` → `SourceClient` → `DestinationClient`

# Adding new integration

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

The CI integrations module implementation is impacted.

# Testing
> How will the project be tested?

Different parts of the each CI source integration should be unit-tested using the following approaches: 

1. The integration client that performs direct HTTP requests to the API should be tested using [3rd-party API testing approach](./blob/master/docs/03_third_party_api_testing.md) and [Mock Server]().
2. The client adapter should be tested using [mockito]() package.
3. The other integrations component (such as `IntegrationParty`, `ConfigParser` and `ClientFactory`) should be tested using core implementations from the [test]() package.

# Alternatives Considered
> Summarize alternative designs (pros & cons)
  
# Results
> What was the outcome of the project?

