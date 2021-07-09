# Doctor Output Improvements

The Metrics CLI `doctor` command checks all third-party CLI tools that participate in a deployment process. As the command is to be generally used by end-users, we should improve the output of the `doctor` command to make it more comfortable.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
    - [Prototyping](#prototyping)
    - [System modeling](#system-modeling)
- [**Design**](#design)
    - [Architecture](#architecture)
      - [ValidationTarget](#validationtarget)
      - [ValidationConclusion](#validationconclusion)
      - [TargetValidationResult](#targetvalidationresult)
      - [ValidationResult](#validationresult)
      - [ValidationResultBuilder](#validationresultbuilder)
      - [ValidationResultPrinter](#validationresultprinter)
    - [User Interface](#user-interface)
    - [Program](#program)
      - [Refactor the `CI Integrations Validate` command](#refactor-the-ci-integrations-validate-command)
        - [ConfigFieldValidationConclusion](#configfieldvalidationconclusion)
        - [CoolIntegrationSourceValidationTarget](#coolintegrationsourcevalidationtarget)
        - [CoolIntegrationSourceValidationDelegate](#coolintegrationsourcevalidationdelegate)
        - [CoolIntegrationSourceValidator](#coolintegrationsourcevalidator)
        - [Making things work](#ci-integrations-making-things-work)
      - [Update the `Metrics CLI Doctor` command](#update-the-metrics-cli-doctor-command)
        - [Dependency](#dependency)
        - [Dependencies](#dependencies)
        - [DependenciesFactory](#dependenciesfactory)
        - [DoctorCommand](#doctorcommand)
        - [Doctor](#doctor)
        - [DoctorFactory](#doctorfactory)
        - [CoolService and CoolServiceCli](#coolservice-and-coolservicecli)
        - [ServiceName](#servicename)
        - [Making things work](#doctor-making-things-work)

## Analysis

The following analysis discovers the Metrics CLI `doctor` command output improvements feature. This feature purposes to improve the output of the `doctor` command in a way it would be clearer for users.

The analysis defines the requirements for the feature, studies its feasibility, and states the implementation approach.

### Feasibility Study
> A preliminary study of the feasibility of implementing this feature.

The `doctor` command should provide clear and readable results, so the user can study them and perform additional configurations on their machine if necessary. Hence, the `doctor` command output is critical for a successful deployment of the Metrics applications. We should ensure that users won't be confused, by providing a convenient, fancy, and clear way to check the machine readiness for Metrics deployment. 

According to the above, we can conclude that the feature makes sense and the Metrics CLI `doctor` command output is to be improved. If a user decided to use Metrics CLI for deployment, it is critical to provide this user with a validation command having a human-friendly output.

To admit that this is possible to implement the feature, we can state that there are existing solutions that we've already implemented for the CI Integrations `validate` command. This command consumes the configuration file and validates its fields providing clear and readable results. Moreover, the Flutter `doctor` command validates the environment, as the Metrics CLI `doctor`, and provides a great output.

Therefore, the feature implementation is possible since the real-case examples exist.

### Requirements
> Define requirements and make sure that they are complete.

The `doctor` command performs the set of checks that validates whether the machine has the required third-party tools installed. Each check stands for a single validation item for the environment the Metrics CLI runs in. The `doctor` command output consists of a set of results for each validation item performed during the command run. Therefore, we can state that the command itself is a validation for the environment. This makes the `doctor` command similar to the CI Integrations `validate` command for [Config Validator](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/04_ci_integrations_config_validator.md). Let's define the requirements for the output improvements feature:

- A single check shouldn't output log messages to the user's console to avoid confusion.
- A single check shouldn't output errors to the user's console to avoid confusion.
- Single check output should start with a leading box with an indicator that clearly defines the result of the validation.
     - The successful validation should start with the mark sign in brackets: `[✓]`.
     - The failed validation should start with the cross sign in brackets: `[✗]`.
     - The validation that finishes successfully but has warnings should start with the exclamation sign in brackets: `[!]`.
     - The validation with an unknown result should start with the question mark in brackets: `[?]`.
- Single check output should contain the validation item name or its description to define the target of validation.
- Single check output may contain the validation result description if any.
- A single check should contain the additional output of the appropriate process. This output is optional by default for the successful checks and is required for fail, warning, and unknown results.
- A single check additional output should be human-readable and decoupled from the main result according to the following rules:
     - The output has a four-space indent. 
     - The output low-level details have the greater indent (plus four spaces for each indentation level).

The following table summarizes the above requirements into the validation result components:

||Indicator|Target|Description|Output|
|---|---|---|---|---|
|**Success**|`[✓]`|Name or description|The result description (e.g., version of the tool). Could be empty|Optional. May contain the human-readable check result|
|**Fail**|`[✗]`|Name or description|Conclusion of validation (e.g., _Not installed_)|Required. Should contain the error message and its cause (e.g., command run)|
|**Warning**|`[!]`|Name or description|The result description and a short explanation of warning (e.g., when optional tool is not installed)|Required. Should contain the human-readable description of the warning (e.g., explanation of versions mismatch)|
|**Unknown**|`[?]`|Name or description|The short message (e.g., _Could not validate_)|Required. Should contain the explanation of why the check could not be performed|

Let's take a look at the example of how the improved `doctor` command output should look like:

![Metrics Doctor](images/metrics_cli_doctor_example.png)

### Landscape
> Look for existing solutions in the area.

As mentioned in the [Feasibility study](#feasibility-study) section, the Flutter CLI and CI Integrations tool provide similar to the desired output. Let's take a look at these examples:

- The Flutter `doctor` command validates the environment to be ready for development using Flutter SDK. The command output is clear and useful and provides the conclusion of the command run summarizing results.
     
     ![Flutter Doctor](images/flutter_doctor_example.png)

- The CI Integrations `validate` command consumes the configuration file and validates its fields resulting in a clear output with conclusions for each field.

     ![CI Integrations Validate](images/ci_integrations_validate_example.png)

However, the Flutter `doctor` command implementation looks a bit tricky and doesn't provide appropriate interfaces we might use. On the other hand, the CI Integrations tool `validate` command provides validation classes and interfaces we would like to use.

As we've already implemented a similar output for the CI Integrations tool `validate` command, we'd like to use the existing code. Thus, the feature is preliminary custom and implies using the existing custom solution with general improvements.

Consider the [Config Validator](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/04_ci_integrations_config_validator.md) document to be more familiar with the `validate` command implementation and its output.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

The feature implies writing results of validation checks to the console. The [`dart:io`](https://api.dart.dev/stable/dart-io/dart-io-library.html) library provides a convenient way of writing messages to the standard [output](https://api.dart.dev/stable/dart-io/stdout.html) and [error](https://api.dart.dev/stable/dart-io/stderr.html) using [`stdout`](https://api.dart.dev/stable/dart-io/stdout.html) and [`stderr`](https://api.dart.dev/stable/dart-io/stderr.html) respectively.

The Metrics CLI uses the [`process_run`](https://pub.dev/packages/process_run) package to run the executables from the environment. The [`runExecutableArguments`](https://pub.dev/documentation/process_run/latest/process_run.cmd_run/runExecutableArguments.html) method runs the executable and logs the process output if the given `verbose` is `true`. The `commandVerbose` flag stands for whether to log the command to execute - this flag is mandatory `true` if the `verbose` one is `true`. Both `commandVerbose` and `verbose` uses the standard output/error to log messages. To suppress the output, both `verbose` and `commandVerbose` should be `false`. So the following code won't log to the standard output:

```dart
final result = await runExecutableArguments(
     'flutter',
     ['--version'],
     verbose: false,
     commandVerbose: false,
);
```

To access the output/error logs from the process, we should use the resulting [ProcessResult](https://api.dart.dev/stable/dart-io/ProcessResult-class.html) instance. Its `stdout` and `stderr` contain the output of the process. We can handle the one as follows:

```dart
String extractOutput(ProcessResult result) {
     final output = result.stdout;
     if (output is String) {
          return output;
     }

     return systemEncoding.decode(output);
}
```

Other requirements match the usual string formatting in Dart.

### System modeling
> Create an abstract model of the system/feature.

The validation output classes and models are a part of the Metrics project and shared for all Metrics components. As both Metrics CLI and CI Integrations are to use the same output for their validation features, we should separate the related component making it a standalone component. This implies modifying the related implementations for the CI Integrations `validate` command.

The following component diagram describes the desired approach:

![doctor output feature diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/cli/docs/features/doctor_output_improvements/diagrams/doctor_output_feature_component_diagram.puml)

# Design

The following subsections explain the implementation strategy in more detail.

### Architecture
> Fundamental structures of the feature and context (diagram).
 
Since the validation output logic is similar for the [`CI Integrations Config Validator`](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/04_ci_integrations_config_validator.md) and the `Metrics CLI Doctor`, we want to have a reusable API for the validation output for the components listed above. For that, let's create a `validation` package in the [`Metrics Core`](https://github.com/Flank/flank-dashboard/tree/master/metrics/core) package to store the common abstractions of the validation functionality.

Consider the next sections describing the main classes of the `validation` package.

#### ValidationTarget
A `ValidationTarget` is an entity that represents the value under the validation (e.g., it's a version of a CLI package).

To represent a `ValidationTarget` in output to the user, we should know its name and a description.

#### ValidationConclusion
A `ValidationConclusion` represents a possible conclusion of the validation process (e.g., 'valid', 'invalid', 'unknown', 'not installed', etc.).

To represent a `ValidationConclusion` to a user, we should know its name, and a visual indicator (e.g., `[+]`, `[-]`, `[?]`, etc.).

#### TargetValidationResult
A `TargetValidationResult` represents a result of the validation of some `ValidationTarget`.

The `TargetValidationResult` should include the following fields:
- A `ValidationTarget` used in the validation process;
- A `ValidationConclusion` of the validation; 
- A description of this conclusion;
- An additional details of this conclusion;
- A context of this conclusion (e.g., process output, additional recommendations, etc.).

#### ValidationResult
A `ValidationResult` is a class that holds the `TargetValidationResult` for each `ValidationTarget`. In simple words, the `ValidationResult` is an overall result of the validation process that contains the validation result for all validated targets.

#### ValidationResultBuilder 
A `ValidationResultBuilder` is a class that simplifies the creation of the `ValidationResult`. The `ValidationResultBuilder` has the main build method that returns a `ValidationResult`.

This class implements a `Builder` pattern, and its responsibility is to assemble the `ValidationResult` step by step.

#### ValidationResultPrinter
A `ValidationResultPrinter` is a class that is responsible for showing the validation result to the user.

Consider the following class diagram that describes the `validation` package structure:

![Validation diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/validation_class_diagram.puml)

### User Interface
> How users will interact with the feature (API, CLI, Graphical interface, etc.).

The usage of the `doctor` command doesn't change for a user. To run the `doctor` command, one should use the following command in the directory containing the Metrics CLI tool:

```bash 
./metrics doctor
```

The improved output of the feature is to contain the detailed machine validation result as described in the [Requirements](#requirements) section above.

#### Application

The [Program](#program) section below describes the application of the `validation` package for the existing features: `Metrics CLI Doctor` command and `CI Integrations Validate` command. Before diving deep into details, let's also define the high-level steps that one should perform to utilize the `validation` packages in the context of other future features. Assume there is a `cool_package` for which we want to use the `validation` package from `Metrics Core`. Consider the following implementation flow:
1. Define the entities that the `ValidationTarget` abstraction represents (e.g., some 3-rd party service, config field, etc.).
2. Define the entity(ies) that are responsible for the `TargetValidationResult`s creation.
3. Define the entity(ies) that are responsible for the `ValidationResult` creation. To create the `ValidationResult`, they should receive the corresponding `TargetValidationResult`s and use the `ValidationResultBuilder` to build the result.
4. Define the entity(ies) that are responsible for operating with the obtained `ValidationResult` and printing it to some [`StringSink`](https://api.flutter.dev/flutter/dart-core/StringSink-class.html)(e.g., IOSink or StringBuffer) using the `ValidationResultPrinter`.

After we clarified the general architecture and usage, let's proceed to the detailed implementation approach.

### Program
> Detailed solution description to class/method level.

The improvement of the doctor command output involves the following:
1. [Refactor the `CI Integrations Validate` command](#refactor-the-ci-integrations-validate-command).
2. [Update the `Metrics CLI Doctor` command](#update-the-metrics-cli-doctor-command).

Consider the following subsections that describe each step in more detail.

#### Refactor the `CI Integrations Validate` command

As stated above, the `Metrics CLI` and [`CI Integrations`](https://github.com/Flank/flank-dashboard/tree/master/metrics/ci_integrations) have a similar output representation for the validation process results. That's why we want to reuse the code across those tools to make it DRYer.

This section describes the changes to the `CI Integrations` tool we should perform to make the tool's validate command use the `validation` package and its abstractions. Let the `CoolIntegration` be the source party that we want to modify with the config validation. The following subsections describe the validation-related classes and their structure in a new manner that applies using the `validation` package.

##### ConfigFieldValidationConclusion

The `ConfigFieldValidationConclusion` (previous `FieldValidationConclusion`) is a class that represents a validation conclusion for a specific config field.

In the scope of this feature, the `ConfigFieldValidationConclusion` aggregates the concrete values of `ValidationConclusion`s that make sense in the config validation process. More precisely, this class holds the possible values of `ValidationConclusion`.

![Config field validation conclusion class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/config_validation_conclusion_class_diagram.puml)

##### CoolIntegrationSourceValidationTarget

The `CoolIntegrationSourceValidationTarget` (previous `CoolIntegrationSourceConfigField`) is a model that represents the config fields for the specific `CoolIntegration`.

We need to update this class to aggregate the `ValidationTarget`s (previous `ConfigField`s) of the given `CoolIntegration`.

![Cool source validation target class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/cool_integration_source_validation_target_class_diagram.puml)

##### CoolIntegrationSourceValidationDelegate

The `CoolIntegrationSourceValidationDelegate` is a class that validates concrete fields with network calls. Currently, the methods of the `CoolIntegrationSourceValidationDelegate` return the `FieldValidationResult`s, which are used then to compose the `ValidationResult`. As the `ValidationResult` is now composed with `TargetValidationResult` instances, we should update the delegate to return such instances instead of `FieldValidationResult`s.

##### CoolIntegrationSourceValidator

The `CoolIntegrationSourceValidator` is a class responsible for the validation of the corresponding config file.

The `.validate()` method of the `CoolIntegrationSourceValidator` should return the `ValidationResult` containing `TargetValidationResult` for each field of the `CoolIntegrationSourceValidationTarget`.

##### Making things work <a href="#ci-integrations-making-things-work" id="ci-integrations-making-things-work"></a>

To update the `CI Integrations Validate` command we should follow the next steps:
1. Create the main abstractions in the `Metrics Core` package: `ValidationTarget`, `ValidationConclusion`, `TargetValidationResult`, `ValidationResult`, `ValidationResultBuilder`, `ValidationResultPrinter`.
2. Replace the existing `FieldValidationConclusion` enum with the `ConfigFieldValidationConclusion` class that aggregates the `ValidationConclusion`s. 
3. Rename the existing integrations' config field classes to the integrations' validation target (e.g., the `BuildkiteSourceConfigField` class should be renamed to the `BuildkiteSourceValidationTarget`, etc.), and update them use the `ValidationTarget`s respectively.
4. Update the validation methods of each integration's validation delegate (e.g., `BuildkiteSourceValidationDelegate`, `FirestoreDestinationValidationDelegate`, etc.) to return the `TargetValidationResult`.
5. Update the `.validate()` methods of each validator (e.g., `BuildkiteSourceValidator`, `FirestoreDestinationValidator`, etc.) to return the updated `ValidationResult` containing the `ValidationTarget`s and `TargetValidationResult`s.
6. Delete the outdated abstractions covered by the `validation` package of the `Metrics Core`: `ConfigField`, `FieldValidationConclusion`, `FieldValidationResult`, `ValidationResult`, `ValidationResultBuilder`, `ValidationResultPrinter`.

Consider the following diagrams that demonstrate the updated config validation for the `CoolIntegration`:

- Class diagram:
  ![CI integrations validator class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/ci_integrations_validator_class_diagram.puml)

- Sequence diagram:
  ![CI integrations validator sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/ci_integrations_validator_sequence_diagram.puml)

#### Update the `Metrics CLI Doctor` command

This subsection describes the enhancements for the `Metrics CLI` doctor command implementation that is required to improve the command's output.

##### Dependency 

The `Dependency` is a class that represents the information on some 3-rd party dependency of `Metrics CLI` tool (e.g., Firebase CLI, Google CLI, etc.).

It contains the following fields that are important for the `doctor` command:
- `recommendedVersion` - a version of the corresponding 3-rd party service that is recommended to use along with the `Metrics CLI`;
- `installUrl` - a URL that refers to the installation instruction of the corresponding 3-rd party service.

Having this information, the `doctor` command can compare the version of some CLI installed on the user's machine with the recommended version listed in the [dependencies](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/dependencies.yaml) source file. In case that CLI is not installed, the `doctor` command shows the installation link to the user.

##### Dependencies

The `Dependencies` is a class that aggregates the `Dependency`s for all 3-rd party services. The `Dependencies` instance is injected into the `Doctor` class to retrieve the `Dependency` information on some 3-rd party service via the `.getFor(service: String)` method, where `service` is the name of that service.

##### DependenciesFactory

The `DependenciesFactory` is a factory class responsible for creating the `Dependencies` instances.

The `.create(fromFile: String)` method of the `DependenciesFactory` takes the path to the [dependencies](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/dependencies.yaml) source file as a parameter and then parses the document into a `Map`.

##### DoctorCommand

The `DoctorCommand` is the Metrics CLI command that is responsible for verification of all the required 3-rd party tools' versions against the recommended versions from the [dependencies](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/dependencies.yaml) document.

In the scope of this feature, we need to update the `DoctorCommand` class to be responsible for printing the [`ValidationResult`](#validationresult) using the [`ValidationResultPrinter`](#validationresultprinter).

##### Doctor

The `Doctor` is a class used to check whether all the required 3-rd party CLIs are installed and get their versions. This class encapsulates the logic of the `DoctorCommand` and interacts with the 3-rd party services.

We should update the `.checkVersions()` method of the `Doctor` class to return the [`ValidationResult`](#validationresult) that will be printed by the `DoctorCommand`.

The `ValidationResult` contains the [`TargetValidationResult`s](#targetvalidationresult) for each 3-rd party service. To create the `TargetValidationResult`s, the `Doctor` should know the recommended versions and installation URLs of the services. To provide this information, we are to inject the [`Dependencies`](#dependencies) instance containing the corresponding [`Dependency`](#dependency) models for each service.

##### DoctorFactory

The `DoctorFactory` is a factory class responsible for the `Doctor` instance creation. We need to inject the [`DependenciesFactory`](#dependenciesfactory) to the `DoctorFactory` so that the `DoctorFactory` can obtain the instance of `Dependencies` to be used during the `Doctor` instance creation.

To create the instance of the `Dependencies` via the `DependenciesFactory`, the `DoctorFactory` should know the path to the [dependencies](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/dependencies.yaml) source file. The `DoctorFactory` takes this value from the new `DoctorConstants` class.

##### CoolService and CoolServiceCli

Let the `CoolService` be a 3-rd party service we want to improve the `doctor` command output for.

Currently, the `CoolService` has the `.version()` method that is implemented in the `CoolCliServiceAdapter`. The `.version()` method runs the `version` command of some service CLI and prints the output directly to the `stdout` (e.g., user's terminal).    

To improve the `doctor` command output, we want to suppress the `version` command output to the terminal and receive this output in the method result. Then, we can use this output to make a conclusion about the validation and prettify the output for the `doctor`. Therefore, we should update the `.version()` methods of the following classes to return the `Future<ProcessResult>`:
1. `InfoService`;
2. `CoolService`; 
3. `CoolServiceCli`;
4. `CoolCliServiceAdapter`.

As described in the [Prototyping](#prototyping) section, to retrieve the resulting [ProcessResult](https://api.dart.dev/stable/dart-io/ProcessResult-class.html) instance, the one should pass the `verbose: false` and `commandVerbose: false` flags to the `.run()` method of `Cli` class. Consider the following code snippet that demonstrates the `ProcessResult` obtaining for the `flutter --version` command: 

```dart
final result = await runExecutableArguments(
     'flutter',
     ['--version'],
     verbose: false,
     commandVerbose: false,
);
```

##### ServiceName

The `ServiceName` is a new enum that stores the names of the 3-rd party services. The `CoolService` class contains the corresponding `ServiceName` value to be used during the validation process by the `Doctor`. 

As the `Doctor` class needs to know the `String` name of the service it validates to get the corresponding [`Dependency`](#dependency) instance for the specific `CoolService`, the `Doctor` class uses the new `ServiceNameMapper` class to unmap the `serviceName` value of the `CoolService`. 

It is worth mentioning that currently the `CoolService` is an interface and should be updated to be an abstract class so that there is no need to redefine the `serviceName` for each ancestor.

Consider the following class diagram that describes the structure of the updated `Metrics CLI` package:
![Metrics CLI class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/metrics_cli_class_diagram.puml)


##### Making things work <a href="#doctor-making-things-work" id="doctor-making-things-work"></a>

Consider the following steps needed to be able to improve the doctor command output:
1. Create the `dependencies` package containing the following classes: `Dependency`, `Dependencies`, `DependenciesFactory`.
2. Create the `DoctorConstants` class.
3. Create the `ServiceName` enum and the `ServiceNameMapper`. 
4. Update each service (e.g., `FlutterService`, `GitService`, etc.) to be an abstract class that stores the corresponding `ServiceName`.
5. Update the `.version()` method to return the `ProcessResult` for each service CLI (e.g., `FlutterCli`, `GitCli`, etc.)
6. Update the `DoctorFactory` class to contain the instance of `DependenciesFactory`.
7. Update the `.version()` methods to return the `ProcessResult` for each CLI service adapter (e.g., `FlutterCliServiceAdapter`, `GitCliServiceAdapter`, etc.)
8. Update the `.checkVersions()` method of the `Doctor` class to return the `ValidationResult`.
9. Update the `DoctorCommand` to print the `ValidationResult` via the `ValidationResultPrinter`.

 Consider the following diagrams that demonstrate the implementation of the `doctor` command output improvement with a `CoolService` used as an example of 3-rd party service:

- Class diagram:
  ![Doctor output improvements class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/doctor_output_improvements_class_diagram.puml)

- Sequence diagram:
  ![Doctor output improvements sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/doctor_output_design/metrics/cli/docs/features/doctor_output_improvements/diagrams/doctor_output_improvements_sequence_diagram.puml)
  