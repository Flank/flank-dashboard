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
- was used in the `CI integrations` tool, here is an [example](https://github.com/Flank/flank-dashboard/blob/0fadf00685df2b335def8c5697d6a5aa973ff92c/metrics/ci_integrations/lib/cli/config/parser/raw_integration_config_parser.dart#L19-L21)
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

The next one is populating the Metrics Web config variables. We can reuse that [implementation](https://github.com/Flank/flank-dashboard/blob/722a626c49594022fccda7af48c77be40cce1cef/metrics/cli/lib/cli/deployer/deployer.dart#L233-L239) from the Deployer.

The last one is redeploying the existing Metrics Web application to the same Firebase project. We can reuse and modify the [implementation](https://github.com/Flank/flank-dashboard/blob/722a626c49594022fccda7af48c77be40cce1cef/metrics/cli/lib/cli/deployer/deployer.dart#L214-L231) for that from the Deployer.

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

![Update feature integration diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/cli/docs/features/diagrams/update_feature_integration_component_diagram.puml)
