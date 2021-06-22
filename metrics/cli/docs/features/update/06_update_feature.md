# Update feature
> Feature description / User story.

As a user, I want to have the opportunity to redeploy the updated Metrics Web application into an existing GCloud project, so I can get new available application features without creating a new GCloud project. Also, I want this feature to work without user interaction as I want to use it for continuous integration automatization.

## Contents

- [**Analysis**](#analysis)
  - [Feasibility study](#feasibility-study)
  - [Requirements](#requirements)
  - [Landscape](#landscape)
    - [Third-party CLIs](#third-party-clis)
    - [YAML map parser](#yaml-map-parser)
      - [yaml_map package](#yaml_map-package)
      - [yaml package](#yaml-package)
  - [Prototyping](#prototyping)
  - [System modeling](#system-modeling)
- [**Design**](#design)
  - [Architecture](#architecture)
  - [User Interface](#user-interface)
  - [Program](#program)
    - [Parsing YAML configuration file](#parsing-yaml-configuration-file)
      - [UpdateConfig](#updateconfig)
      - [UpdateConfigParser](#updateconfigparser)
      - [UpdateConfigFactory](#updateconfigfactory)
    - [Redeploy Metrics components](#redeploy-metrics-components)
      - [UpdateCommand](#updatecommand)
      - [Updater](#updater)

# Analysis
> Describe a general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for updating existing projects with the Metrics CLI.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

The `Update feature` implies updating the version of the deployed Metrics components instead of deploying a new version to a separate project. It means that the Metrics components may be deployed only once and then updated using the Metrics CLI commands. The `Update feature` significantly simplifies working with the Metrics components and allows users to keep their Metrics version up-to-date in a convenient way. Thus, the `Update feature` makes sense for the Metrics CLI as improves the overall user experience for the Metrics project.

Moving on to the feasibility of implementation, the feature is required to perform the following actions:
- parse the `YAML` configuration file;
- redeploy/update the existing Metrics components using the same Firebase/GCloud project.

Parsing the `YAML` file with configurations is possible as the Dart language widely uses configuration files in `YAML` format (e.g., [`pubspec.yaml`](https://dart.dev/tools/pub/pubspec), [`analysis_options.yaml`](https://dart.dev/guides/language/analysis-options#the-analysis-options-file), [`build.yaml`](https://pub.dev/packages/build_config), etc.). Moreover, the `CI Integrations` tool (as a Metrics component) uses `YAML` configuration files to perform builds synchronization.

To state that updating itself is possible, we should notice that both Firebase CLI and GCloud CLI have commands for updating the deployed projects with new values. And since the Metrics CLI already has the ability to interact with Firebase and GCloud CLIs for the deployment feature, the deployed components updating is possible as well.

As it is possible to perform the required actions, we admit that it is possible to implement the `Update feature`.

### Requirements
> Define requirements and make sure that they are complete.

The Feasibility study section defines the main actions the feature should perform. In this section, we should list the requirements and possible edge-cases that would cover the main actions of the `Update feature`.
The `Update feature` has the following requirements:

- for the parsing configuration action:
  - should consume the configuration file path via the command line arguments;
  - should read the configuration from the `YAML` configuration file.
  - should stop the redeploy process of the Metrics CLI if the provided YAML file does not contain required attributes 
  - should stop the redeploy process of the Metrics CLI if the provided file is not valid YAML or does not exist.
- for the redeploying action:
  - should populate the Web Metrics Config variables;
  - should stop the redeploy process of the Metrics CLI if something went wrong during the process;
  - should redeploy/update the existing Metrics Web application to the Firebase project specified in the configuration file;
  - should skip the optional configuration steps if attributes for these steps are missing in the `YAML` configuration.

### Landscape
> Look for existing solutions in the area.

Before landscaping the feature, we should notice that the `Update feature` is preliminary custom as implies changes to the Metrics CLI and is specific for Metrics project purposes. 

Let's firstly take a look at the components necessary for the `Update feature` to meet the [requirements](#requirements):
- [the third-party CLIs](#third-party-clis);
- [the yaml_map parser](#yaml-map-parser).

#### Third-party CLIs

There are several `CLIs`, which the `Update feature` requires. These CLIs are already used in the [deployer](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md#deployer) - the component of the `Metrics CLI`. Since the `Update feature` intersects with the [deployer](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md#deployer) functionality, therefore we're gonna to reuse these CLIs. Also, consider the following [documentation](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md#metrics-cli-interfaces) to learn more about `CLIs` we are going to use.

#### YAML map parser

It is also worth noting a `YAML parser` component for extracting the data from the `YAML` file, which the `Update feature` requires.

There are two main packages for parsing the `YAML` files:
- [the yaml_map package](#yaml_map-package);
- [the yaml package](#yaml-package).

Let's compare the listed packages in a bit more detail.

##### yaml_map package

The following package simple parses the given `YAML` file into the dart [Map](https://api.dart.dev/stable/2.13.2/dart-core/Map-class.html) class. 

Consider the following pros and cons of the [`yaml_map`](https://github.com/Flank/flank-dashboard/tree/master/yaml_map) package:

Pros:
- was used in the `CI integrations` tool, here is an [example](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/lib/cli/config/parser/raw_integration_config_parser.dart#L19-L21)
- parses the `YAML` file in the dart [Map](https://api.dart.dev/stable/2.13.2/dart-core/Map-class.html)

Cons:
- no cons found

##### yaml package

This package parses the given `YAML` file into the custom [YamlMap](https://pub.dev/documentation/yaml/latest/yaml/YamlMap-class.html) class.

Consider the following pros and cons of the [`yaml`](https://pub.dev/packages/yaml) package:

Pros:
- can parse the `YAML` file

Cons:
- does not parse the `YAML` file straight into the dart [Map](https://api.dart.dev/stable/2.13.2/dart-core/Map-class.html) to simplify the flow

According to the comparison above, we choose the [yaml_map](#yaml_map-package) package, as it fits the `Update feature` [requirements](#requirements), satisfies the customization and testability requirements, and we've already experienced working with it.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

To confirm that we are able to implement the `Update feature`, let's highlight the complex implementation points necessary for the update feature.

The first one is consuming the configuration file path via the command line arguments. We can use the [`addOption`](https://pub.dev/documentation/args/latest/args/ArgParser/addOption.html) method within the [args](https://pub.dev/packages/args) package to consume arguments via the command line.

Consider the following code snippet showing the process of adding an ability for a command to accept an argument

```dart
class ExampleCommand extends Command {
  /// A name of the option that holds a path to the YAML configuration file.
  static const _configFileOptionName = 'config-file';

  ExampleCommand() {
    argParser.addOption(
      _configFileOptionName,
      help: 'A path to the YAML configuration file to validate.',
      valueHelp: 'config.yaml',
    );
  }

  @override
  Future<void> run() async {
    // Retrieves the provided file path
    final configFilePath = getArgumentValue(_configFileOptionName) as String; 
  }
}
```

The next one is populating the Metrics Web config variables. We can reuse that [implementation](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/lib/cli/deployer/deployer.dart#L233-L239) from the Deployer.

The last one is redeploying the existing Metrics Web application to the same Firebase project. We can reuse and modify the [implementation](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/lib/cli/deployer/deployer.dart#L214-L231) for that from the Deployer.

Also let's highlight how we're going to resolve the edge cases of the `Update feature`.

The first edge case about stopping the redeploy process when the configuration file argument is not specified.

Consider the following code snippet that shows how to resolve the edge case described above:

```dart
Future<void> run() async {
  final configFilePath = getArgumentValue(_configFileOptionName) as String;
  
  if (configFilePath == null) {
    throw SomeException();     // stops the redeploy process and notifies the user of the error's cause
  }
  
  // continues the redeploy process
}
```

The next one claims that we should stop the redeploy process if something went wrong during it. In other words, if at least one part of the redeploy process throws an exception, the whole process should fail and notify the user about the reason.

Having considered all the complex points and edge cases, we conclude that the `Update feature` implementation is possible in compliance with the [requirements](#requirements).

### System modeling
> Create an abstract model of the system/feature.

The `Update feature` is a part of the Metrics CLI component and is to be integrated into the CLI. The following diagram demonstrates the `Update feature` integration:

![Update feature integration diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_feature_design/metrics/cli/docs/features/update/diagrams/update_feature_integration_component_diagram.puml)


# Design

This section provides a high-level structure of the feature, describes the UI for end-users, and shows class-level implementation details.

## Architecture
>Fundamental structures of the feature and context (diagram).

The general approach of the `Update feature` integration to the `Metrics CLI` tool is to use the structure that we've already used in the `Metrics CLI` for similar cases like a [doctor](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md#doctor) or a [deployer](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md#deployer). To learn more about the `Metrics CLI` tool structure, take a look at the following [document](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md).

It's time to briefly review which classes the `Update feature` requires according to the structure mentioned in the previous paragraph.

First of all, we should implement the class that represents the top-level `update command` of the `Metrics CLI` tool, the purpose of which is the redeploying a new version of the Metrics Web Application and its components.

Moving next, we should implement a class that encapsulates the logic between the `update command` and [`Services`](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md#service).

Also, do not forget that our feature should be able to parse the `YAML` configuration. Therefore, we should implement a class for this purpose.

Finally, we should register the `update command` in the `Metrics CLI` so the user can execute the command using the tool.

Let's review the component diagram that shows how the main component interacts with each other:

![Update command component diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_feature_design/metrics/cli/docs/features/update/diagrams/update_command_components_diagram.puml)

## User Interface
>How users will interact with the feature (API, CLI, Graphical interface, etc.).

The `Update feature` implies adding a new command to the `Metrics CLI` application. Users can interact with the update feature as with any other command of the Metrics CLI. This interaction is based on the following rule: `metrics <command> [arguments]`, where `metrics` is the Metrics CLI executable name, `<command>` is a command to execute name, and `[arguments]` are arguments to pass to the command.

The following snippet demonstrates the Metrics command-line user interface for the `--help` option of the `Metrics CLI` tool after the `Update feature` integration into this CLI.

```diff
Metrics CLI.

Usage: metrics <command> [arguments]

Global options:
  -h, --help    Print this usage information.
  
Available commands:
  deploy   Creates GCloud and Firebase projects for Metrics components and deploys the Metrics Web Application.
  doctor   Shows the version information of the third-party dependencies.
+ update   Updates the Metrics components and redeploys the Metrics Web Application to the Firebase project.

Run "metrics help <command>" for more information about a command.
```

In the example above, we can notice that a new `update` command has been added with its description accordingly. 
For more information on how the `update` command works, the user can call it with the `--help` option. The following snippet demonstrates the command-line user interface for this:

```bash
Usage: metrics update [arguments]
-h, --help                         Print this usage information.
    --config-file=<config.yaml>    A path to the YAML configuration file.

Run "metrics help" to see global options.
```

As we can notice, the interface for the update feature is pretty similar to other features of the Metrics CLI. Thus, since we clarified the usage, let's proceed to a deeper review of the feature structure and implementation details.

## Program
> Detailed solution description to class/method level.

The update feature implies two main actions we'd like to review in the below subsections:
- [Parsing YAML configuration file](#parsing-yaml-configuration-file)
- [Redeploy Metrics components](#redeploy-metrics-components)

### Parsing YAML configuration file

The YAML configuration file for the update feature has the following structure:

![Update config diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_feature_design/metrics/cli/docs/features/update/diagrams/update_config_yaml_diagram.puml)

_**Note**: The `sentry` configurations are optional. A user can leave a `sentry` field empty (or omit it at all) if there is no need to create a new Sentry release for the updated version._

See the [configuration template](https://github.com/Flank/flank-dashboard/tree/update_feature_design/metrics/cli/docs/features/update/config/configuration_template.yaml) for the details of the fields.

Let's take a closer look at the structure of the configuration file parsing. The below subsections examine the related classes and their relationships we should implement.

#### UpdateConfig

The `UpdateConfig` is a model that represents the `YAML` update config. The `UpdateConfig` class should aggregate the following classes:

- the `FirebaseConfig` class - represents the `firebase` attribute of the update `YAML` config;
- the `SentryConfig` class - represents the `sentry` attribute of the update `YAML` config.

_**Note**: The `SentryConfig` field should be `null` if the `sentry` parameter of the update `YAML` config is empty._

Let's review the detailed structure of the `UpdateConfig` by looking at the following class diagram:

![Update config class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_feature_design/metrics/cli/docs/features/update/diagrams/update_config_class_diagram.puml)

#### UpdateConfigParser

The `UpdateConfigParser` is a class uses to parse the `YAML` configuration file data to the [`UpdateConfig`](#updateconfig) model. The `UpdateConfigParser` should use the [`yaml_map`](https://github.com/Flank/flank-dashboard/tree/master/yaml_map) package for parsing purposes, as was analyzed in the [YAML map parser section](#yaml-map-parser).

#### UpdateConfigFactory

The `UpdateConfigFactory` is a class uses to create the [`UpdateConfig`](#updateconfig) using the [`UpdateConfigParser`](#updateconfigparser). This class should contain only one method `create()` that takes the path to the configuration file as an input parameter.

The following class diagram demonstrates the structure of the classes required for the `YAML` config parsing process:

![Config YAML parser class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_feature_design/metrics/cli/docs/features/update/diagrams/config_yaml_parser_class_diagram.puml)

### Redeploy Metrics components

The following section describes the classes required for the redeploy process.

#### UpdateCommand

The `UpdateCommand` is the `Metrics CLI` command that is responsible for the redeploying the last version of the Metrics Web Application to the Firebase using the data from the [`UpdateConfig`](#updateconfig).

The `UpdateCommand` algorithm performs the following steps:

1. Parse the YAML config.
2. Checkout the Metrics Web Application source code.
3. Build the Metrics Web Application.
4. Configure Sentry using data from the config.
5. Redeploy the Firebase components like Firestore rules and Firebase Functions using data from the config.
6. Redeploy the Metrics Web Application to the Firebase Hosting using data from the config.
7. Cleanup the created directories, etc.

#### Updater

The `Updater` class encapsulates the redeployment logic. The `UpdateCommand` uses the `Updater` with the parsed configurations. The `Updater` has the `update` method that interacts with the external [`Services`](https://github.com/Flank/flank-dashboard/blob/master/metrics/cli/docs/01_metrics_cli_design.md#service) and redeploys the latest version of the Metrics Web Application to the Firebase using the `UpdateConfig`. Also, the `Updater` uses the `FileHelper` utility class to interact with the `File System`, aka `FS`. The FileHelper, in turn, works with the `FS` using the [`dart.io`](https://api.dart.dev/stable/2.13.3/dart-io/dart-io-library.html) package.

To create an `Updater`, the `UpdateCommand` uses the `UpdaterFactory`. This factory provides the `Updater` instance with all the required services and returns the ready-to-use instance to the `Updater`.
The following class diagram demonstrates how the classes described above interact:

![Updater class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_feature_design/metrics/cli/docs/features/update/diagrams/updater_class_diagram.puml)

Consider the following sequence diagram that illustrates the whole process of the `UpdateCommand` and the interaction with the classes described above:

![Update sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_feature_design/metrics/cli/docs/features/update/diagrams/update_command_sequence_diagram.puml)
