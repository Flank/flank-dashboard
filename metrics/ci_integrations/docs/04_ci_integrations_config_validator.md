# CI Integrations Config Validator

## TL;DR

Introducing a `CI Integrations Config Validator` provides an ability to validate the CI Integrations configuration fields before the `sync` command to provide additional context about the possible errors in the configuration file.   
For example, if the configuration file contains a non-valid email/password used to log in into CI, the user sees the corresponding error before the `sync` process starts.

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

Let's start with the necessary abstractions. Consider the following classes:
- A `ConfigValidator` is a class that provides the validation functionality and throws a `ConfigValidationError` if the given config is not valid.
- A `ValidationDelegate` is a class that the `ConfigValidator` uses for the validation of specific fields with network calls.
- A `ConfigValidatorFactory` is a class that creates a `ConfigValidator` with its `ValidationDelegate`.

Consider the following steps needed to be able to validate the given configuration file:

1. Create the following abstract classes: `ConfigValidator`, `ValidationDelegate`, `SourceValidationDelegate`, `DestinationValidationDelegate` and `ConfigValidatorFactory`.
2. For each source or destination party, implement its specific `ConfigValidator`, `ValidationDelegate`, and `ConfigValidatorFactory`. Implement the validation-required methods in the integration-specific clients.
3. Add the `configValidatorFactory` to the `IntegrationParty` abstract class and provide its implementers with their party-specific config validator factories.
4. Create the source and the destination config validators and call them within the `sync` command.

Consider the following class diagram that demonstrates the required changes using the destination `CoolIntegration` as an example:

![Widget class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/ci_integrations/docs/diagrams/ci_integrations_config_validator_class_diagram.puml)

#### Package Structure

Consider the package structure using the `CoolIntegration` as an example:

> * integration/
>   * interface/
>     * base/
>       * config/
>         * validator/
>           * config_validator.dart   
>         * validator_factory/
>           * config_validator_factory.dart  
>         * validation_delegate/
>           * validation_delegate.dart
>     * source/
>       * config/
>         * validation_delegate/
>           * source_validation_delegate.dart
>     * destination/
>       * config/
>         * validation_delegate/
>           * destination_validation_delegate.dart
>   * error/
>     * config_validation_error.dart 
> * destination/
>   * cool_integration/
>     * config/   
>       * validator/
>         * cool_integration_destination_config_validator.dart
>       * validator_factory/
>         * cool_integration_config_validator_factory.dart
>       * validation_delegate/
>         * cool_integration_destination_validation_delegate.dart
> * source/
>   * cool_integration/
>     * config/   
>       * validator/
>         * cool_integration_source_config_validator.dart
>       * validator_factory/
>         * cool_integration_config_validator_factory.dart
>       * validation_delegate/
>         * cool_integration_source_validation_delegate.dart
> * client/  
>   * cool_integration/
>     * cool_integration_client.dart

## Making things work
Consider the following sequence diagram that illustrates the process of the configuration files validation:

![Sequence class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/ci_integrations/docs/diagrams/ci_integrations_config_validator_sequence_diagram.puml)

## Testing
> How will the project be tested?

The project will be unit-tested using the Dart's core [test](https://pub.dev/packages/test) and [mockito](https://pub.dev/packages/mockito) packages. Also, the approaches discussed in [3rd-party API testing](https://github.com/platform-platform/monorepo/blob/master/docs/03_third_party_api_testing.md) and [here](https://github.com/platform-platform/monorepo/blob/master/docs/04_mock_server.md) should be used testing a validation client that performs direct HTTP calls. 
