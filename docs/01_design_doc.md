# Why create a metrics platform?

## Problem

Software teams lack insight into build performance, build stability, and codebase quality. There's not a language agnostic build and test analytics platform to visualize data in an actionable way.

# What is the scope of the project?

## Solution

Create a dashboard to track build performance, build count, build stability, and code coverage. Eventually expand to include detailed performance, failure, and test visualizations.

This is similar to Gradle Enterprise except the goal is to support any build system and any languge. Gradle Enterprise also lacks a dashboard feature.

# How will the project be developed?

## Tech Stack

- [GitHub](https://github.com/software-platform/metrics) is used to store the source code
- [ZenHub](https://www.zenhub.com/) is the project management software (install the [free extension](https://www.zenhub.com/extension))
- [Flutter Web](https://flutter.dev/web) is the framework
- [Adobe XD](https://www.adobe.com/products/xd.html) is the design tool because of [upcoming Flutter support](https://theblog.adobe.com/xd-flutter-plugin-generate-dart-code-design-elements/)

## Workflow

Code is submitted via pull requests. Each pull request must have 1 approval. History should be linear (no merge commits).

> git config --global pull.rebase true
