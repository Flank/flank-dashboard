# Overview

`Buildkite` - an Integrated continuous integration and continuous deployment for software projects.

To get started you only need to understand its `Core Concepts`:

 - [Agent](#agent-description)
 - [Pipeline](#pipeline-description)
 - [Steps](#steps-description)

## Agent

`Buildkite agents` are small, reliable and cross-platform build runners that run automated builds. It runs on your own machine, whether it's a VPS, server, desktop computer, etc.

To learn more about `agents` consider the following link: https://buildkite.com/docs/agent/v3

## Pipeline

A `pipeline` is a template of the steps you want to run. Connecting `pipelines` to your source control(e.g. Github) allows you to run builds when your code changes.

When you run a pipeline, a build is created.

To learn more about `pipelines` consider the following link: https://buildkite.com/docs/pipelines

## Steps

`Steps` are the lists of commands need to run for the specific `pipeline`.

Pipeline `steps` are defined in YAML and are either stored in Buildkite or in your repository using a `pipeline.yml`(gives you access to more configuration options and environment variables) file.

The following example YAML defines a pipeline with two command steps:

```yaml
steps:
  - label: "Example Test"
    command: echo "Hello!"
  - label: "Tests"
    command:
      - "npm install"
      - "tests.sh"
```

To learn more about `steps` consider the following link: https://buildkite.com/docs/pipelines/defining-steps

The following sequence diagram shows how the Buildkite works:

![Buildkite sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/docs/diagrams/buildkite_sequence_diagram.puml)

# Metrics integration

To be able to track the state of the applications under development, we should configure the Buildkite integration that will export the build data to the Metrics Web application.

## Integration config YAML

An `integration config` is a YAML file, that the `CI integration tool` uses to export build data from the source to the destination.

### Source for the Buildkite integration

A source is part a YAML config with a list of fields, that `CI integration tool` uses to fetch information about builds from the Buildkite.

Here is an example of source part of the config:

```yaml
source:
  buildkite:
    access_token: ...
    pipeline_slug: ...
    organization_slug: ...
```

The following fields are mandatory to define in the source section:
  - `access_token` - a Buildkite access token;
  - `pipeline_slug` - a unique slug (identifier) of the pipeline on Buildkite the integration should work with;
  - `organization_slug` - a unique slug (identifier) of the organization on Buildkite in the scope of which the integration should work and perform requests.

### Destination for the Buildkite integration

A destination is a part of YAML config with a list of fields, that `CI integration tool` uses to import data to the Firestore.

Here is an example of destination part of the config:

```yaml
destination:
  firestore:
    firebase_project_id: ...
    firebase_user_email: ...
    firebase_user_pass: ...
    firebase_public_api_key: ...
    metrics_project_id: ...
```

The following fields are mandatory to define in the destination section:
  - `firebase_project_id` - a Firebase project identifier;
  - `firebase_user_email` - a Firebase user email;
  - `firebase_user_pass` - a Firebase user password;
  - `firebase_public_api_key` - a Firebase public API key;
  - `metrics_project_id` - a Firestore metrics project identifier.

### Full example of the ci integration YAML config

```yaml
source:
  buildkite:
    access_token: ...
    pipeline_slug: ...
    organization_slug: ...
destination:
  firestore:
    firebase_project_id: ...
    firebase_user_email: ...
    firebase_user_pass: ...
    firebase_public_api_key: ...
    metrics_project_id: ...
```

## Pipeline configuration

To be able to export the build data automatically, we need to configure the `Sync Pipeline`, that exports the build data to the destination. 
We need to trigger this pipeline at the end of each pipeline we want to export the build data from.
## Other configuration

First of all we need to configure an `Agent`. Consider the following link: https://buildkite.com/docs/agent/v3/installation.
It has a list of possible `agents`, that we can install to run our `builds`.

