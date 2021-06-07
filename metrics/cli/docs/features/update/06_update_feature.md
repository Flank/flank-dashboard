# Update feature
> Feature description / User story.

As a user, I want to have the opportunity to redeploy the updated Metrics Web application into an existing GCloud project, so I can get new available application features without creating the new project.
Also, I want this feature to work without user interaction as I want to use it for continuous integration automatization.

## Contents

- [**Analysis**](#analysis)
  - [Feasibility study](#feasibility-study)
  - [Requirements](#requirements)
  - [Landscape](#landscape)
  - [Prototyping](#prototyping)
  - [System modeling](#system-modeling)

# Analysis
> Describe a general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for updating existing projects with the Metrics CLI.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

The Update feature implies updating the version of the deployed Metrics components instead of deploying a new version to the separate project.
This means that the Metrics components may be deployed only once and then updated using the Metrics CLI commands.
This significantly simplifies working with the Metrics components and allows users to keep their Metrics version up-to-date in a convenient way.
Thus, the update feature makes sense for the Metrics CLI as improves the overall user experience for the Metrics project.

Moving on to the feasibility of implementation, the feature is required to perform the following actions:
- parse the YAML configuration file;
- redeploy/update the existing Metrics components using the same Firebase/GCP project.

Parsing the YAML file with configurations is possible as the Dart language widely uses configuration files in YAML format (e.g., [`pubspec.yaml`](https://dart.dev/tools/pub/pubspec), [`analysis_options.yaml`](https://dart.dev/guides/language/analysis-options#the-analysis-options-file), [`build.yaml`](https://pub.dev/packages/build_config), etc.).
Moreover, the CI Integrations tool (as a Metrics component) uses YAML configuration files to perform builds synchronization.

To state that updating itself is possible, we should notice that both Firebase CLI and GCloud CLI have commands for updating the deployed projects with new values.
And since the Metrics CLI already has the ability to interact with Firebase and GCloud CLIs for the deployment feature, the deployed components updating is possible as well.

As it is possible to perform the required actions, we admit that it is possible to implement the Update feature.

### Requirements
> Define requirements and make sure that they are complete.

The Feasibility study section defines the main actions the feature should perform.
In this section, we should list the requirements and possible edge-cases that would cover the main actions of the Update feature.

The `Update feature` has the following requirements:

- for the parsing configuration action:
  - should consume the configuration file path via the command line arguments;
  - should read the configuration from the YAML configuration file.
- for the redeploying action:
  - should populate the Web Metrics Config variables;
  - should stop the redeploy process of the Metrics CLI if something went wrong during the process;
  - should redeploy/update the existing Metrics Web application to the same Firebase project;
  - should skip the Sentry configuration steps if the Sentry attributes is missing in the YAML configuration.

### Landscape
> Look for existing solutions in the area.

Before landscaping the feature, we should notice that the update feature is preliminary custom as implies changes to the Metrics CLI and is specific for Metrics project purposes.

In general, to implement the update feature, we should implement the command, which should consistently perform the following actions:
- parse the YAML configuration and extract data required for the update feature;
- checkout new version of the Metrics Web application;
- build the Flutter Web application;
- configure Sentry for the application using the Sentry data obtained during parsing the YAML configuration;
- redeploy the Metrics Web application to the existing Firebase project using the Firebase data obtained during parsing the YAML configuration.
  
To perform the first step, we're going to use the [yaml_map](https://github.com/Flank/flank-dashboard/tree/master/yaml_map) package.
The package was chosen due to the following advantages over similar ones:
- was used in the CI integrations tool, here is an [example](https://github.com/Flank/flank-dashboard/blob/0fadf00685df2b335def8c5697d6a5aa973ff92c/metrics/ci_integrations/lib/cli/config/parser/raw_integration_config_parser.dart#L19-L21);
- parses the YAML file in the default dart [Map](https://api.dart.dev/stable/2.13.2/dart-core/Map-class.html).
  
And the last four steps, we're going to perform using the corresponding CLIs:
- the Git CLI for checkout new version;
- the Flutter CLI for building the Metrics Web application;
- the Sentry CLI for configuring Sentry;
- the Firebase CLI for redeploying the Metrics Web application.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

To confirm that we are able to implement the update feature, let's highlight the complex implementation points necessary for the update feature.

The first one is consuming the configuration file path via the command line arguments. We can use the [`addOption`](https://pub.dev/documentation/args/latest/args/ArgParser/addOption.html) method within the [args](https://pub.dev/packages/args) package to consume arguments via the command line.

The next one is populating the Metrics Web config variables. 
We can reuse that [implementation](https://github.com/Flank/flank-dashboard/blob/722a626c49594022fccda7af48c77be40cce1cef/metrics/cli/lib/cli/deployer/deployer.dart#L233-L239) from the Deployer.

The last one is redeploying the existing Metrics Web application to the same Firebase project. We can reuse and modify the [implementation](https://github.com/Flank/flank-dashboard/blob/722a626c49594022fccda7af48c77be40cce1cef/metrics/cli/lib/cli/deployer/deployer.dart#L214-L231) for that from the Deployer.

### System modeling
> Create an abstract model of the system/feature.

The Update feature is a part of the Metrics CLI component and is to be integrated into the CLI. The following diagram demonstrates the Update feature integration:
![Update feature integration diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/update_command_analysis/metrics/cli/docs/features/diagrams/update_feature_integration_component_diagram.puml)
