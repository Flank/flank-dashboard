# Metrics CLI Design

## TL;DR

Introducing the auto-deployment to Firebase  for the Metrics app allows users to set up a new environment as quickly as possible. For this purpose, we need to create a CLI tool that automates a deployment process.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [Metrics firebase deployment](https://github.com/platform-platform/monorepo/blob/master/docs/08_firebase_deployment.md)
- [Metrics firebase deployment with CLI](https://github.com/platform-platform/monorepo/blob/master/docs/13_firebase_deployment_cli.md)

## Goals
> Identify success metrics and measurable goals.

This document has the following goals:

- develop a clear design of the Metrics CLI tool;
- describe the overall process of the Doctor command;
- describe the overall process of the Deploy command.

## Non-Goals
> Identify what's not in scope.

Updating the Metrics Web Application is out of scope for this document.

## Design
> Explain and diagram the technical design

The following sections provide an implementation of the Metrics CLI tool.

To simplify the deployment process, the Metrics CLI should have the following commands:

- [Doctor command](#DoctorCommand) - a command used to check all third-party CLIs required for the deployment process available;
- [Deploy command](#DeployCommand)- a command used to automatic GCloud and Firebase projects creating and deploying the Metrics applications.

Let's take a look at the classes the Metrics CLI tool requires.

### DoctorCommand

The `DoctorCommand` is the `Metrics CLI` command that provides the ability to simply check whether all required tools are installed and get their versions.

### DeployCommand

The `DeployCommand` is the `Metrics CLI` command that is responsible for the Metrics Web Application deployment to the Firebase. The command creates GCloud and Firebase projects, enables all necessary Firebase services and deploys the Metrics Web Application to the Firebase Hosting.

Let's review a top-level flow of the `DeployCommand`:

1. Create a new GCloud project.
2. Add a Firebase project to the created GCloud project.
3. Deploy the Firebase components like Firestore rules and Firebase Functions.
4. Enable Firebase Analytics service.
5. Enable `Google` and `Email and Password` Firebase Auth providers.
6. Create Firestore `feature_config` and `metadata` collections.
7. Build the Metrics Web Application.
8. Configure Sentry.
9. Deploy the Metrics Web Application to the Firebase Hosting.
10. Cleanup the created directories, etc.

### Metrics CLI interfaces

Since the `Metrics CLI` commands use the third-party `CLI`s to perform the deployment, we should implement the following components: 

- [CLI](#CLI) - classes needed to interact with the third-party `CLI`s. 
- [Service](#Service) - interfaces that provide the clean and understandable API for each external service we are using.

Let's review each component in more details: 

#### CLI

Since the Metrics CLI uses the third-party CLIs to deploy the Metrics applications, we should implement classes used to interact with these CLIs. These classes should encapsulate the CLI command invocations in their methods. 

To deploy the Metrics Web Application, we should have the following CLI classes:

- `FirebaseCli` is used to create a Firebase project and deploy the application;
- `FlutterCli` is used to build the Flutter application;
- `GCloudCli` is used to create a GCloud project;
- `GitCli` is used to checkout the Metrics Web project from the remote repository;
- `NpmCli` is used to install the Npm dependencies;
- `SentryCli` is used to associate the Metrics Web application with a Sentry project.

#### Service

To make the `Metrics CLI` more clean and structured, we should define interfaces for each external service we are using. These interfaces should provide methods we need to deploy the Metrics Web Application. 

The following class diagram demonstrates the relationships between [CLIs](#CLI) and [Services](#Service):

![CLI interfaces Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/cli_interfaces_class_diagram.puml)

Let's review the main `service` interfaces we need to deploy the Metrics Web Application: 
    
- `InfoService` is a base interface used to define the common methods for our services such as `version`;
- `FirebaseService` is an interface used to define the following Firebase behavior required for our commands: 
    - Firebase login;
    - Create a Firebase project;
    - Deploying an application to the Firebase Hosting;
    - Deploy rules and functions;
    - Upgrade a project billing plan;
    - Initialize a Firestore data;
    - Enable a Firebase Analytics;
    - Configure Auth providers;
    - Accept terms of the Firebase service.
- `FlutterService` is an interface used to define the following Flutter behavior required for our commands:
    - Build web application.
- `GCloudService` is an interface used to define the following GCloud behavior required for our commands:
    - GCloud login;
    - Create a GCloud project;
    - Configure an OAuth origins;
    - Configure a user organization for the project;
    - Accept terms of the GCloud service.
- `GitService` is an interface used to define the following Git behavior required for our commands:
    - Checkout required repository.
- `NpmService` is an interface used to define the following Npm behavior required for our commands:
    - Install Npm dependencies.
- `SentryService` is an interface providing the following Sentry interaction abilities:
    - Login to the Sentry;
    - Create a new release;
    - Get a DSN of the project.

Since we have interfaces for each service and `CLI`s implemented, we should adapt our `CLI` classes to the corresponding `Service`s. 

Let's review the class diagram representing the `Metrics CLI` services and `CLI`s with relationships between them: 

![Services Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/services_class_diagram.puml)

### Prompt

To interact with a user during the deployment process, we should include prompts in our application. To do so, we are going to implement the following classes: 

- [Prompter](#Prompter) - a class used to interact with the user by means of prompts.
- [PromptWriter](#PromptWriter) - a class used in the `Prompter` to write the prompts and get the user responses.

The following class diagram demonstrates the structure of the prompts integration and the relationships of classes this integration requires:

![Prompter Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/prompter_class_diagram.puml)

Let's take a look at the classes the prompts integration requires in more details: 

#### Prompter

The `Prompter` is a main part of the CLI prompts. This class provides methods to interact with a user and uses a [PromptWriter](#PromptWriter) to write the prompts.

#### PromptWriter

The `PromptWriter` is an interface that provides methods for prompts. This class is needed to make the prompts testable. The default implementation of the `PromptWriter` is a `IOPromptWriter` that interacts with the user using the `stdin` and `stdout`.  

### Doctor

The `Doctor` is a class used to check whether all required third-party `CLI`s are installed and get their version. This class encapsulates the logic of the [`DoctorCommand`](#doctorcommand) in it and uses the [`Service`](#service)s to interact with the external `CLI`s. To create a `Doctor` inside the `DoctorCommand` we are using the `DoctorFactory`. It allows us to easily tests the `DoctorCommand` and keep it SRP.

The following class diagram demonstrates how the classes described above interact:

![Doctor class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/doctor_command_class_diagram.puml)

### Deployer

The `Deployer` class is needed to separate the deployment logic from the [`DeployCommand`](#DeployCommand). It has the `deploy` method that encapsulates the interaction with the external [`Service`](#service)s and deploys the Metrics Web Application. To create an `Deployer` inside the `DeployCommand` we are using the `DeployerFactory`. It allows us to easily tests the `DeployCommand` and keep it SRP.

The following class diagram demonstrates how the classes described above interact:

![Deploy class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/deploy_command_class_diagram.puml)

As we can see, the `Deployer` and `Doctor` classes requires the same services, so we should create a `Services` class that holds all required services. This will allow us to avoid code duplication and improve testability.

### Making Things Work

The `MetricsCliRunner` is a class that extends a `CommandRunner` and is used to expose the [`deploy`](#deploycommand) and [`doctor`](#doctorcommand) commands to the user.

The following class diagram demonstrates the structure of the `MetricsCliRunner`:

![Metrics Cli Runner Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/metrics_cli_runner_class_diagram.puml)

Consider the following sequence diagram that illustrates the process of the `DoctorCommand`:

![Doctor Command sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/doctor_command_sequence_diagram.puml)

Consider the following sequence diagram that illustrates the process of the `DeployCommand`:

![Deploy Command sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/cli/docs/diagrams/deploy_command_sequence_diagram.puml)

## Usage

### Before you begin

Before you start, you should download the latest version of the Metrics CLI tool and have the following installed:

1. [flutter](https://flutter.dev/docs/get-started/install);
2. [npm](https://www.npmjs.com/get-npm);
3. [git](https://cli.github.com);
4. [firebase](https://firebase.google.com/docs/cli);
5. [gcloud](https://cloud.google.com/sdk/gcloud);
6. [sentry-cli](https://docs.sentry.io/product/cli/installation).

To view the recommended versions of the dependencies, please check out the [dependencies file](https://github.com/platform-platform/monorepo/blob/master/metrics/cli/recommended_versions.yaml).

### Doctor

The `doctor` command provides an ability allows checking the environment for all required dependencies like firebase, npm, etc. The output of this command includes the versions of all required third-party CLIs. 

If the `doctor` command output contains any errors - the user should fix them before running the `deploy` command.

To run the `doctor` command use the following command in the directory containing the Metrics CLI tool:

```bash
./metrics doctor
```

### Deploy

The `deploy` command creates GCloud and Firebase projects, enables Firestore and other Firebase services necessary for correct Metrics Web Application working, and deploys the Metrics Web Application to the Firebase hosting.

This command may require user interaction during the deployment process. For example, it may ask to log in to the Firebase or GCloud CLI.

To start the `deploy` process, run the following command in the directory containing the Metrics CLI tool:

```bash
./metrics deploy
```

## Testing

All parts of the Metrics CLI application will be unit-tested using Dart's core [test](https://pub.dev/packages/test) and [mockito](https://pub.dev/packages/mockito) packages.
_**Note**: Since the  [CLIs](#CLI) classes use the top-level [Process.start](https://api.dart.dev/stable/2.10.5/dart-io/Process/start.html) function, they could not be covered with tests and should be tested manually._
## Alternatives Considered

> Summarize alternative designs (pros & cons)

We looked to use Terraform to automate creation of GCloud infrastructure but its more suited to managing infrastructure not deploying application.

## Results

> What was the outcome of the project?

The document describes the process of the automatic setup and deploying project.
