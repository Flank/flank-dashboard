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
