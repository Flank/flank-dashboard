# Metrics :bar_chart:
Metrics is a set of applications to collect and review software project metrics like performance, build stability, and codebase quality.

### CI integrations
A CLI application that integrates with popular CI tools to collect software project metrics.

### Core
Provides a common classes to use within Metrics applications.

### Firebase
Stores configurations for Firestore, Firebase Cloud Functions and deployment on Firebase Hosting.

### Web
A web application that displays project metrics on easy to navigate Dashboard.

The following diagram demonstrates the relationships between the above constitutes of Metrics:

![Concept map](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/software-platform/monorepo/readme_update/concept_map.puml)

# Getting started with Metrics :books:
The project is full of documents explaining different aspects and solutions used within Metrics. Reading all of this massive documentation is not an easy task and requires a lot of time and patience. To get yourself ready for joining Metrics and to understand all of its basic approaches, we collected the very common documents that may help with a newcomer's first steps. 

The following list is a base and stands for an introduction to the project, solutions it involves, and the philosophy of its development: 
1. [Why create a metrics platform? :thinking:](docs/01_design_doc.md)
2. [GitHub Agile process :chart_with_upwards_trend:](docs/02_process.md)
3. [Dart code style :nail_care:](docs/10_dart_code_style.md)
4. [Collaboration :raised_hands:](docs/11_collaboration.md)

In addition, every Metrics component requires related documentation. Thus, to get started with the `CI integrations` it is recommended to get familiar with the following documents: 
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

# Design & Documentation

- [design/](design/)
- [docs/](docs/)

# Setup

```
flutter version 1.15.3
flutter upgrade
flutter config --enable-web
```

- https://flutter.dev/docs/get-started/web

# Run

`flutter run -d chrome`
