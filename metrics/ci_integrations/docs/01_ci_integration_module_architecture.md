# CI integrations module architecture.
> Summary of the proposed change

The top-level description of CI integration architecture and package structure. Tips in adding new integration.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Plant UML](http://plantuml.com/guide)

# Motivation
> What problem is this project solving?

As the CI integration module is required to be extendable in order to support new integrations, it should be provided with an appropriate artifact explaining its structure and how to add new integrations.

# Goals
> Identify success metrics and measurable goals.

- An architecture that allows adding new integrations easily.
- A readable and clear class diagram explaining this architecture.
- A testable and maintainable module structure.

# Non-Goals
> Identify what's not in scope.

- The document explains the top-level class structure and package structure for the module - deep dive in how it works is out of scope.

# Design
> Explain and diagram the technical design

All the integrations used by the CI integration module can be one of two types: 
- source (stands for the source of builds - where they are loaded from);
- destination (stands for the builds storage - where they are stored).

Both types are presented as a set of interfaces in `integration.interface.source` and `integration.interface.destination` respectively. Also, both of them are presented by their implementations in the `source` (for example, with `source.jenkins`, `source.bitrise`) and `destination` (for example, with `destination.firestore`) respectively.

The `SupportedSourceParties` is an integration point for all source integrations. And the `SupportedDestinationParties` is the same point for the destination integrations. Both of them intersect in the `SupportedIntegrationParties` used by the `SyncCommand` - the brain of the module.

![Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/plant_uml_diagram/metrics/ci_integrations/docs/diagrams/ci_integrations_class_diagram.puml)

# Adding new integration

Adding a new source integration and destination one is very similar. Let's look on adding new source integration steps: 
1. Implement a new (or use existing) integration client that makes direct HTTP calls to this integration's API.
2. Implement the `SourceConfig` interface and provide it with configurations required for this integration. 
3. Implement the `SourceConfigParser` interface providing method for parsing the configuration implemented on step 2.
4. Create an adapter that implements the `SourceClient` interface and uses the integration client created on step 1. This allows adapting the integration client to use in the `CiIntegration`.
5. Implement the `SourceClientFactory` interface providing method for creating the integration client and its adapter created in the previous step. The factory uses `SourceConfig` implementation from step 2.
6. Implement the `SourceParty` interface containing both configuration parser and client factory created in the previous steps. 
7. Register the implemented party in the `SupportedSourceParties.parties` list.

The process for adding new destination integration differs from the above only in interfaces' names. Thus, consider the following mapping:

source | destination
--- | ---
`SourceConfig` | `DestinationConfig`
`SourceConfigParser` | `DestinationConfigParser`
`SourceClient` | `DestinationClient`
`SourceClientFactory` | `DestinationClientFactory`
`SourceParty` | `DestinationParty`
`SupportedSourceParties` | `SupportedDestinationParties`

Suppose you are going to add a new `Cool` integration. Here is a diagram displaying the process: 

![Activity Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/plant_uml_diagram/metrics/ci_integrations/docs/diagrams/ci_integrations_activity_diagram.puml)

# API
> What will the proposed API look like?

`SyncCommand` → `SupportedIntegrationParties` → `CiIntegration` → `Builds source` → `Builds storage`

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

The CI integrations module implementation is impacted.

# Testing
> How will the project be tested?

Different parts of each CI source integration should be unit-tested using the Dart's core [test](https://pub.dev/packages/test) and [mockito](https://pub.dev/packages/mockito) packages. Also, the approaches discussed in [3rd-party API testing](https://github.com/software-platform/monorepo/blob/master/docs/03_third_party_api_testing.md) and [here](https://github.com/software-platform/monorepo/blob/master/docs/04_mock_server.md) should be used testing an integration client that performs direct HTTP calls. 

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- Not document the CI integrations module.
    - Cons:
        - The module appears to be tricky for newcomers without any document describing it on a top-level.
        - Adding and registering new integration might be not clear.

# Results
> What was the outcome of the project?

The class diagram explaining the CI integration module structure with steps in adding new integrations.
