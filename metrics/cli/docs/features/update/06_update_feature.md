# Update feature
> Feature description / User story.

As a user, I want to have the opportunity to update an existing project, so I don't have to create a new one every time.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
    - [Prototyping](#prototyping)
    - [System modeling](#system-modeling)

# Analysis
> Describe a general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for updating existing projects with
the Metrics CLI.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

The `Update feature` expands the end-user capabilities and improves the UX of the Metrics CLI, so this feature
makes sense for the project.

Moving on to the feasibility of implementation, the `Update feature` requires the following actions:

- parsing the YAML configuration file;
- redeploying/updating the existing Metrics Web application to the same Firebase project.

The following proofs cover the above requirements, so we can implement the `Update feature`:
- to parse the YAML configuration file, we can use a [package](https://github.com/Flank/flank-dashboard/tree/master/yaml_map) that applies in the ci_integrations module for the same purposes;
- the Metrics CLI has everything we need to perform the redeploy action to the same Firebase project since the CLI can perform a deploy action.

### Requirements
> Define requirements and make sure that they are complete.

Let's start with visiting and analyzing resources to collect the necessary data during the analysis stage.
Thanks to these data, we can create precise and determined requirements and edge cases for the `Update feature`.

The `Update feature` has the following requirements:
- should read the configuration from the YAML configuration file;
- should consume the configuration file path via the command line arguments;
- should validate the YAML configuration file;
- should stop the redeploy process of the Metrics CLI if something went wrong during the process;
- should redeploy/update the existing Metrics Web application to the same Firebase project;
- configuring the Sentry should be optional.

### Landscape
> Look for existing solutions in the area.

There are no ready packages or solutions that satisfy our requirements since the `Update feature` is a custom feature 
necessary exclusively for Metrics specific purposes in the Metrics CLI tool. Considering all the previous, custom implementation is the best choice.


Let's take a closer look at the custom implementation.

This approach means we should implement the command, which redeploys the Metrics Web app to the existing Firebase
project. The command should extract the required data for the redeploy from the YAML configuration file.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

As we've described in the requirements section, we must be able to perform the following actions to implement the Update
feature:

- should read the configuration from the YAML configuration file;
- should consume the configuration file path via the command line arguments;
- should validate the YAML configuration file;
- should stop the redeploy process of the Metrics CLI if something went wrong during the process;
- should redeploy/update the existing Metrics Web application to the same Firebase project;
- configuring the Sentry should be optional.

The next code snippets demonstrate how we can perform the listed required actions:

- read the configuration from the YAML configuration file:
```dart
final parser = YamlMapParser();

final config = parser.parse(configYaml);
```

- consume the configuration file path via the command line arguments:
```dart
final configFileOptionName = 'config-file';
final argParser = ArgParser();

argParser.addOption(
  configFileOptionName,
  help: 'A path to the YAML configuration file.',
  valueHelp: 'config.yaml',
);

final configFilePath = getArgumentValue(configFileOptionName) as String;
```

- validate the YAML configuration file:
```dart
final configValidator = ConfigValidator();
final validationResult = configValidator.validate(configFile);
```

- stop the redeploy process of the Metrics CLI if something went wrong during the process:
```dart
// the command flow
try {
  action1();
  action2(); // throws and moves to the catch section
  ..........
  actionN(); // the action doesn't perform
} catch (e) {
  
}
```

- redeploy/update the Metrics Web application to the same Firebase project (how the feature selects the project id):
```dart
final parser = YamlMapParser();
final config = parser.parse(configYaml);
final projectId = config['project_id'];
```

- configuring the Sentry should be optional:
```dart
final parser = YamlMapParser();
final config = parser.parse(configYaml);

if(config['sentry'] != null) {
  // setup sentry
}
```

### System modeling
> Create an abstract model of the system/feature.

Consider the following component diagram that demonstrates the `Update feature` integration:

![Update feature integration diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_command_analysis/metrics/cli/docs/features/diagrams/update_feature_integration_component_diagram.puml)
