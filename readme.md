# Metrics :bar_chart:

Metrics is a set of software components to collect and review software project metrics like performance, build stability, and codebase quality.

The following diagram demonstrates the main Metrics components and the relationships between them:

![Concept map](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/concept_map.puml)

<details>
  <summary>Metrics Components</summary>

### CI integrations

A CLI application that integrates with popular CI tools to collect software project metrics.

### Core

A Dart package that provides a common classes to use within Metrics applications.

### Firebase

A `Firebase` instance that provides the Firestore, Firebase Cloud Functions services and ability to deploy the application on Firebase Hosting. Also, provides an Analytics service used to gather and store the analytics data (this service is optional and may not be configured during deployment).

Firebase Analytics is optional and may not be configured during deployment.

### Flutter Web

A `Flutter Web` application that displays project metrics on easy to navigate Dashboard.

### Deploy CLI

A `Deploy CLI` is a command-line tool that simplifies the deployment of Metrics components (Flutter Web application, Cloud Functions, etc.) 

### Dart Cloud Functions 

A `Dart Cloud Functions` is a serverless backend code deployed on Firebase that simplifies data managing for other Metrics components.

### Sentry

A `Sentry` service helps to store any logs and monitor runtime errors.

Sentry is optional and may not be configured during deployment.

</details>

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

In contrast with the above components, `Flutter Web` requires more steps to follow: 
1. [Project metrics definitions :book:](docs/05_project_metrics.md)
2. [Metrics Web Application architecture :walking:](metrics/web/docs/01_metrics_web_application_architecture.md)
3. [Metrics Web presentation layer architecture :running:](metrics/web/docs/02_presentation_layer_architecture.md)
4. [Widget structure organization :bicyclist:](metrics/web/docs/03_widget_structure_organization.md)

# Guardian :shield:

Detect flaky tests by analyzing JUnit XML files and orchestrate tools like Slack, Jira to notify the team.

# Design :art:

Follow the next links to get acquainted with the Metrics project design: 
- [design/](design/)

# Documentation :books:

You can find complete Metrics documentation using the following links:
- [general documentation](docs/)
- [CI integrations documentation](metrics/ci_integrations/docs/)
- [Web documentation](metrics/web/docs/)
