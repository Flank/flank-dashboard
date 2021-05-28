# CI Integrations Config Validator

## TL;DR

Introducing a `CI Integrations Config Validator` provides an ability to validate the CI Integrations configuration fields by running the `validate` command that provides information about the possible errors in the configuration file.     
For example, if the configuration file contains a non-valid email/password used to log in into CI, the user will get the corresponding error message once run the `validate` command.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations Tool Architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

## Goals
> Identify success metrics and measurable goals.

This document aims the following goals:
- Create a clear design of the CI Integrations Config Validator.
- Provide an overview of steps the new CI Integrations Config Validator requires.

## Design
> Explain and diagram the technical design.

### Main interfaces and classes

Let's start with the necessary abstractions. Consider the following classes:
- A `ValidationResult` is a class that holds the validation results for each config's field.
- A `ConfigField` is a class that represents a single config's field name.
- A `FieldValidationResult` is a class that represents a validation conclusion for a single config's field and provides some additional context if needed. The `FieldValidationResult` may be `success` - meaning that a field is valid, `failure` - meaning that a field is invalid, and `unknown` - if a field cannot be validated, e.g. the access token has no permissions to use a specific validation API endpoint.
- A `ConfigValidator` is a class responsible for validating the configuration. The `validate` method of this class returns a `ValidationResult` as an output.
- A `ValidationDelegate` is a class that the `ConfigValidator` uses for the validation of specific fields with network calls. The methods of `ValidationDelegate`s return `FieldValidationResult`s which are used by `ConfigValidator`s.
- A `ValidationResultBuilder` is a class that simplifies the creation of the `ValidationResult` and has the main `build` method that returns a `ValidationResult`. See [output generation](#output-generation) for more details.
- A `ConfigValidatorFactory` is a class that creates a `ConfigValidator` with its `ValidationDelegate`.

Consider the following class diagram that demonstrates the main abstract and base classes needed to implement the config validation feature:

![Class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/config_validator_base_class_diagram.puml)

Consider the following package structure for the abstract and base classes of the config validation feature: 

> * integration/
>   * interface/
>     * base/
>       * config/
>         * model/
>           * config_field.dart
>         * validator/
>           * config_validator.dart
>         * validator_factory/
>           * config_validator_factory.dart
>         * validation_delegate/
>           * validation_delegate.dart
>   * validation/
>     * model/
>       * builder
>         * validation_result_builder.dart   
>       * validation_result.dart
>       * field_validation_result.dart
>       * field_validation_conclusion.dart

#### Output Generation

It is very necessary to provide a clear and understandable output and at the same time keep the code clean and testable. To do that, let's use the `ValidationResultBuilder` class. This class implements a `Builder` pattern, and its responsibility is to assemble the `ValidationResult` step by step. Consider the following code that demonstrates the `ValidationResultBuilder` usage within the `validate` method of the `ConfigValidator`:

```dart

final resultBuilder = ValidationResultBuilder.forFields(CoolIntegrationConfigField.values);

// validating auth
final accessToken = config.accessToken;
final auth = AuthorizationBase(accessToken);

final authValidationResult = await validationDelegate.validateAuth(auth);
resultBuilder.setResult(CoolIntegrationConfigField.auth, authValidationResult);

// auth is not valid
if (authValidationResult.isFailure) {
  // terminating validation as the auth needed for validation is invalid
  final interruptReason = 'Cannot continue the validation, as the provided access token is invalid.';
  final emptyFieldsValidationResult = FieldValidationResult.unknown(interruptReason);
  resultBuilder.setEmptyResults(interuptReason);

  return resultBuilder.build();
}

// auth is valid, validation is continued
final anotherField = config.anotherField;

// other fields validation
final anotherFieldValidationResult = await validationDelegate.validateAnotherField(anotherField);
resultBuilder.setResult(CoolIntegrationConfigField.anotherField, anotherFieldValidationResult);

...

return resultBuilder.build();

```

## Making things work

Consider the following steps needed to be able to validate the given configuration file:

1. Create the main abstract classes: `ConfigValidator`, `ValidationDelegate`, `SourceValidationDelegate`, `DestinationValidationDelegate`, `ConfigValidatorFactory`, `ValidationResult`, `ValidationResultBuilder`, `ConfigField` and `FieldValidationResult`.
2. For each source or destination party, implement its specific `ConfigValidator`, `ValidationDelegate`, `ConfigField`, and `ConfigValidatorFactory`. Implement the validation-required methods in the integration-specific clients.
3. Add the `configValidatorFactory` to the `IntegrationParty` abstract class and provide its implementers with their party-specific config validator factories.
4. Create a `ValidateCommand` class.
5. Register the `ValidateCommand` in the `CiIntegrationsRunner`.
6. Create the source and the destination config validators and call them within the `validate` command.

Assume a `CoolIntegration` as a destination party for which we want to provide the config validation. Consider the following diagrams that demonstrate the implementation of the config validation for the `CoolIntegration`:

- Class diagram:

![Class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/config_validator_destination_class_diagram.puml)

- Sequence diagram:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/config_validator_sequence_diagram.puml)

Consider the following package structure for the `CoolIntegration` config validation feature:

> * destination/
>   * cool_integration/
>     * config/
>       * validator/
>         * cool_integration_destination_validator.dart
>       * validator_factory/
>         * cool_integration_validator_factory.dart
>       * validation_delegate/
>         * cool_integration_destination_validation_delegate.dart
>       * model/
>         * cool_integration_destination_config_field.dart
> * client/
>   * cool_integration/
>     * cool_integration_client.dart

## Testing
> How will the project be tested?

The project will be unit-tested using the Dart's core [test](https://pub.dev/packages/test) and [mockito](https://pub.dev/packages/mockito) packages. Also, the approaches discussed in [3rd-party API testing](https://github.com/Flank/flank-dashboard/blob/master/docs/03_third_party_api_testing.md) and [here](https://github.com/Flank/flank-dashboard/blob/master/docs/04_mock_server.md) should be used to test new methods of the clients that perform direct HTTP calls.

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- Implement the config validation functionality as a flag of the `sync` command (`sync --[no]-validate`).
    - Pros:
        - Can be enabled by default to detect invalid configuration fields before synchronization.
    - Cons:
        - No ability to validate a config file without performing synchronization.
        - The validation process may need extra permissions that are not essential for synchronization.
