# Metrics :bar_chart:

Metrics is a set of software components to collect and review software project metrics like performance, build stability, and codebase quality.

### CI integrations

A CLI application that integrates with popular CI tools to collect software project metrics.

### Core

Provides a common classes to use within Metrics applications.

### Firebase

Stores configurations for Firestore, Firebase Cloud Functions and deployment on Firebase Hosting.

### Web

A Web application that displays project metrics on easy to navigate Dashboard.

### CLI

A `CLI` is a command line tool used to simplifies the deployment process of the Metrics Web application. 

### Dart Cloud Functions 

A `Dart Cloud Functions` is a set of server-side lambda functions used to aggregate data.

The following diagram demonstrates the relationships between the above constitutes of Metrics:

![Concept map](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/concept_map.puml)

# Getting started with Metrics :beginner:

We've tried to document all important decisions & approaches used for the development of this project. Reading each document is not an easy task and requires some time and patience. To help you get started, we collected the most useful documents that should help you to make fist steps:

1. [Metrics developer configuration :gear:](docs/15_developer_configuration.md)
2. [Why create a metrics platform? :thinking:](docs/01_design_doc.md)
3. [GitHub Agile process :chart_with_upwards_trend:](docs/02_process.md)
4. [Dart code style :nail_care:](docs/10_dart_code_style.md)
5. [Collaboration :raised_hands:](docs/11_collaboration.md)

Furthermore, every Metrics component requires component-specific documentation. Thus, to get started with the `CI integrations` it is recommended to get familiar with the following documents: 
1. [CI integrations module architecture :building_construction:](metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)

Similarly, here is a list for the `Firebase` component:
1. [Metrics firebase deployment :boat:](docs/09_firebase_deployment.md)

In contrast with the above components, `Web` requires more steps to follow: 
1. [Project metrics definitions :book:](docs/05_project_metrics.md)
2. [Metrics dashboard :nerd_face:](docs/06_metrics_dashboard.md)
3. [Metrics Web Application architecture :walking:](metrics/web/docs/01_metrics_web_application_architecture.md)
4. [Metrics Web presentation layer architecture :running:](metrics/web/docs/02_presentation_layer_architecture.md)
5. [Widget structure organization :bicyclist:](metrics/web/docs/03_widget_structure_organization.md)

# Guardian :shield:

Detect flaky tests by analyzing JUnit XML files and orchestrate tools like Slack, Jira to notify the team.

# Design :art:

Follow the next links to get acquainted with the Metrics project design: 
- [design/](design/)

# Documentation :books:

You can find complete Metrics documentation using the following links:
- [general documentation](docs/)
- [CI integrations documentation](metrics/ci_integrations/docs/)
- [web documentation](metrics/web/docs/)
