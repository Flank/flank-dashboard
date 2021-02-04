# Metrics CLI Design

## TL;DR

Introducing the auto-deployment to Firebase  for the Metrics app allows users to set up a new environment as quickly as possible. For this purpose, we need to create a CLI tool that automates a deployment process.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [Metrics firebase deployment](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md)
- [Metrics firebase deployment with CLI](https://github.com/platform-platform/monorepo/blob/master/docs/14_firebase_deployment_cli.md)

## Goals
> Identify success metrics and measurable goals.

This document has the following goals:

- develop a clear design of the Metrics CLI tool;
- describe the overall process of the Doctor command;
- describe the overall process of the Deploy command.

## Non-Goals
> Identify what's not in scope.

Deployment to other cloud providers than Google Cloud.

## Design
> Explain and diagram the technical design

The following sections provide an implementation of the Metrics CLI tool.

To simplify the deployment process, the Metrics CLI should have the following commands:

- [Doctor command](#DoctorCommand) - a command used to check all third-party CLIs required for the deployment process available;
- [Deploy command](#DeployCommand)- a command used to automatic GCloud and Firebase projects creating and deploying the Metrics applications.

Let's take a look at the classes the Metrics CLI tool requires.

### CLI Wrappers

Since the Metrics CLI uses the third-party CLIs to deploy the Metrics applications, we should implement classes used to interact with these CLIs. 
These classes should encapsulate the CLI commands invocation in its methods. 
To deploy the Metrics Web Application, we should have the following classes:

- `FirebaseCliWrapper` used to work with firebase CLI;
- `FlutterCliWrapper` used to work with flutter CLI;
- `GCloudCliWrapper` used to work with gcloud CLI;
- `GitCliWrapper` used to work with git CLI;
- `NpmCliWrapper` used to work with npm CLI.

### DoctorCommand

To simplify the Metrics CLI setup, we should implement the `Doctor` command to provide an ability to simply check whether all required tools installed and get their versions.

The following class diagram demonstrates the structure of the `DoctorCommand`:

![Doctor Command Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/metrics_cli_design/metrics/cli/docs/diagrams/doctor_command_class_diagram.puml)


The following sequence diagram demonstrates how the `DoctorCommand` works:

![Doctor Command Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/metrics_cli_design/metrics/cli/docs/diagrams/doctor_command_sequence_diagram.puml)

### DeployCommand

The `DeployCommand` is a class that extends a `Command` and responsible for the Metrics deployment to Firebase. 

The `DeployCommand` uses [CLI wrappers](#cli-wrappers) for `Firebase`, `GCloud`, etc. to perform steps form the [Metrics firebase deployment doc](https://github.com/platform-platform/monorepo/blob/master/docs/14_firebase_deployment_cli.md).

The following class diagram demonstrates the structure of the `DeployCommand`:

![Deploy Command Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/metrics_cli_design/metrics/cli/docs/diagrams/deploy_command_class_diagram.puml)

The following sequence diagram demonstrates how the `DeployCommand` works:

![Deploy Command Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/metrics_cli_design/metrics/cli/docs/diagrams/deploy_command_sequence_diagram.puml)

## Usage

### Before you begin

Before you start, you should download the latest version of the Metrics CLI tool and have the following installed:

1. [flutter](https://flutter.dev/docs/get-started/install) v1.25.0-8.2.pre;
2. [npm](https://www.npmjs.com/get-npm);
3. [git](https://cli.github.com/);
4. [firebase](https://firebase.google.com/docs/cli);
5. [gcloud](https://cloud.google.com/sdk/gcloud).

### Doctor

The `doctor` command provides an ability allows checking the environment for all required dependencies like firebase, npm, etc.
The output of this command includes the versions of all required third-party CLIs. 
If the `doctor` command output contains any errors - the user should fix them before running the `deploy` command.

To run the `doctor` command use the following code in your console:

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

### MetricsCommandRunner

The `MetricsCommandRunner` is a class that extends a `CommandRunner` and used for registering and running [`deploy`](#deploycommand) and [`doctor`](#doctorcommand) commands.

The following class diagram demonstrates the structure of the `MetricsCommandRunner`:

![Metrics Command Runner Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/metrics_cli_design/metrics/cli/docs/diagrams/metrics_command_runner_class_diagram.puml)

## Testing

All parts of the Metrics CLI application will be unit-tested using Dart's core [test](https://pub.dev/packages/test) and [mockito](https://pub.dev/packages/mockito) packages.
_**Note**: Since the  [CLI wrapper](#cli-wrappers) classes use the top-level [Process.start](https://api.dart.dev/stable/2.10.5/dart-io/Process/start.html) function, they could not be covered with tests and should be tested manually._
## Alternatives Considered

> Summarize alternative designs (pros & cons)

We looked to use Terraform to automate creation of GCloud infrastructure but its more suited to managing infrastructure not deploying application.

## Results

> What was the outcome of the project?

The document describes the process of the automatic setup and deploying project.
