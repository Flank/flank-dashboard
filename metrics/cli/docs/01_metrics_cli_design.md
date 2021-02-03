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

- a clear design of the Metrics CLI tool;
- describe the overall process of the Doctor command;
- describe the overall process of the Deploy command.

## Non-Goals
> Identify what's not in scope.

Deployment to other cloud providers than Google Cloud.

## Design
> Explain and diagram the technical design

The following sections provide an implementation of the Metrics CLI tool.

Here is a list of functionality points we should provide to the Metrics CLI tool:
- checking all the third-party CLIs necessary for the correct operation;
- automatic creating and configuring of projects in gcloud, firebase and deploying it.

Let's take a look at the classes the Metrics CLI tool requires.

### CLI Wrappers

CLI wrapper classes are wrappers over the third-party CLIs functions. These classes encapsulate the CLI commands invocation.

The Metrics CLI tool has the following wrappers that used for the firebase deployment:

- `FirebaseCliWrapper` used to work with firebase CLI;
- `FlutterCliWrapper` used to work with flutter CLI;
- `GCloudCliWrapper` used to work with gcloud CLI;
- `GitCliWrapper` used to work with git CLI;
- `NpmCliWrapper` used to work with npm CLI.

### MetricsCommandRunner

The `MetricsCommandRunner` is a class that extends a `CommandRunner` and used for registering and running [`deploy`](#deploycommand) and [`doctor`](#doctorcommand) commands.

The following class diagram demonstrates the structure of the `MetricsCommandRunner`:

![Metrics Command Runner Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/metrics_cli_design/metrics/cli/docs/diagrams/metrics_command_runner_class_diagram.puml)

### DoctorCommand

The `DoctorCommand` is a class that extends a `Command` and is used to check the current versions of the CLIs required for the [deploy command](#deploycommand).

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

The `doctor` is the supporting command of the Metrics CLI tool, which checks the environment for all required dependencies (firebase, npm, etc.) and print the information to the user. See flutter doctor for inspiration.

To run the `doctor` command use the following code in your console:

```bash
path/metrics doctor
```

### Deploy

The `deploy` is the main command of the Metrics CLI tool, which creates gcloud and firebase projects, enables firestore and necessary services and deploys web projects to the hosting.

In some cases, the deploy command requires user interaction(such as login to firebase or gcloud CLI).

To run the `deploy` command use the following code in your console:

```bash
path/metrics deploy
```

## Testing

All parts of the application should be unit-tested using Dart's core [test](https://pub.dev/packages/test) and [mockito](https://pub.dev/packages/mockito) packages.

_**Note**: We can't test [CLI wrappers](#cli-wrappers) as they use a top-level function [Process.start](https://api.dart.dev/stable/2.10.5/dart-io/Process/start.html) to work._

## Alternatives Considered

> Summarize alternative designs (pros & cons)

We looked to use Terraform to automate creation of GCloud infrastructure but its more suited to managing infrastructure not deploying application.

## Results

> What was the outcome of the project?

The document describes the process of the automatic setup and deploying project.
