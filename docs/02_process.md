# GitHub Agile process

> Summary of the proposed change

Adopt an agile process on GitHub using ZenHub that matches established engineering best practices.

# References

- [ZenHub](https://www.zenhub.com/) is the project management software (install the [free extension](https://www.zenhub.com/extension))
- Review and follow [Google's eng practices](https://google.github.io/eng-practices/)
- [The anatomy of a perfect pull request](https://medium.com/@hugooodias/the-anatomy-of-a-perfect-pull-request-567382bb6067)

# Motivation

> What problem is this project solving?

Project management helps ensure the project is successful by planning work, tracking progress, and reflecting on weekly sprints for continuous improvement.

# Goals

> Identify success metrics and measurable goals.

Meet industry standards for Agile development using 1 week sprints.

# Non-Goals

> Identify what's not in scope.

The process should work for the team, the team shouldn't work for the process. Adjustments to the project management approach are expected.

## Design first

Software engineers should always follow the complete process while working on every task:

- Analysis
- Specification
- Design
- Development
- Testing
- Maintenance

Make sure to commit effort and don't skip steps.

After completing Design and before moving to Development - make sure to approve the Design document with your Team Leader (if you are a Team Leader - with your peer) or discuss it with the team.

### Design documentation

To capture design documentation, we use the following techniques and tools:

- Documentation using [design doc](01_design_doc.md) template or custom structure where it makes sense
- Diagrams using [PlantUml](https://plantuml.com/) - as it allows to include diagrams directly into design documents from diagram source
- Use grammar checkers like [Grammarly](https://grammarly.com)

Examples:

- Application architecture: [Metrics Web Application architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md)
- Feature design: [User Profile Theme](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/user_profile_theme/01_user_profile_theme_design.md)

## Workflow

Code is submitted via pull requests to master from a named brach. Forks aren't used. Each pull request must have 1 approval. History should be linear (no merge commits).
> git config --global pull.rebase true
  
Code should be sufficiently documented. Use [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation) for guidance.

## Pull Requests

Use the [Fixes #0](https://help.github.com/en/github/managing-your-work-on-github/closing-issues-using-keywords) keyword so that the relevant issue is closed when the pull request is merged.

Each pull request should be [connected to an issue](https://help.zenhub.com/support/solutions/articles/43000010350-connecting-pull-requests-to-github-issues) using ZenHub.

### Limits

The size labels applied by Git App [Pull Request Size](https://github.com/apps/pull-request-size) to each Pull Request based on the total lines of code changed.

| Name      | Description                               |
|-----------|-------------------------------------------|
| size/XS   | Denotes a PR that changes 0-9 lines.      |
| size/S    | Denotes a PR that changes 10-29 lines.    |
| size/M    | Denotes a PR that changes 30-99 lines.    |
| size/L    | Denotes a PR that changes 100-499 lines.  |
| size/XL   | Denotes a PR that changes 500-999 lines.  |
| size/XXL  | Denotes a PR that changes 1000+ lines.    |

PRs designed to be small and PRs of XXL size should be split into multiple logical PRs according to ["The anatomy of a perfect pull request"](https://medium.com/@hugooodias/the-anatomy-of-a-perfect-pull-request-567382bb6067). 

### Draft Pull Requests

Create a [Draft Pull Request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) for PRs that are still a work in progress. Draft PRs signal to reviewers that the pull request is a work in progress.


### PR title using [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)

#### Introduction
The Conventional Commits specification is a lightweight convention on top of commit messages. 
There are various tools that use it, but at the moment, we plan on generating `Release Notes` only.

#### Rules
Every PR which is not in draft mode should follow conventional commit convention for PR title. 

#### PR title
Pull request title should be: `<type>([optional scope]): <description>`

where   
`<type>` - [one of the following types](#type)

`[optional scope]` - scope of the change (we don't use that at the moment)

`<description>` - description of the PR

#### Type

- `build` - Changes that affect the build system or external dependencies
- `ci` - Changes to our CI configuration files and scripts (basically directory `.github/workflows`)
- `docs` - Documentation only changes
- `feat` - A new feature
- `fix` - A bug fix
- `chore` - Changes which does not touch the code (ex. manual update of release notes). It will not generate release notes
changes
- `refactor` - A code change that contains refactor
- `style` - Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc.)
- `test` - Adding missing tests or correcting existing tests
- `perf` - A code change that improves performance

### Code Reviews

Pull requests are code reviewed and approved by someone other than the author before merging.

- [Google code review guidelines](https://google.github.io/eng-practices/review/reviewer/)
- [Code review best practices](https://medium.com/@schrockn/on-code-reviews-b1c7c94d868c)

### Merging Pull Requests

* `Rebase and merge`
  * Pull requests should have passing CI builds and be code reviewed before merging to master. If a pull request consists entirely of logical changes, use the `Rebase and merge` button. 

* `Squash and merge`
  * If the pull request contains a bunch of work in progress intermediate commits, use the`Squash and merge` button so the PR is collapsed into one logical change.

### Automatic PR merge

We use [Mergify](https://mergify.io) to automatically merge Pull Requests when all GitHub Actions pass. See configuration script [.mergify.yaml](../.mergify.yaml) to know more.

## Rewrite commits into logical changes

Git commits are organized into logical changes before merging to master.

> You go hackety hack, hackety hack, hackety hack. When you're ready, you commit. And then you do a rebase. So what we like to do is, while you're developing locally on a branch of your own, you can have as many branches as you want. You can have your commits all organized any way you want. But when we push it into master, we want a logical change to go into our codebase. We don't want the individual steps you did. Now, there's a number of reasons for doing that. The first one, a logical change is a lot easier for other people to comprehend. If you want people to understand what you're doing, what you need to do is explain why you're doing it. That helps increase the quality of the code when someone comes and has a look at things. And second of all, if we need to yank your changes, it's a lot easier for us to do that if we can see the one logical change that went in rather than the intermediate steps, particularly if you're like me and you work on, like, two or three things at the same time. So we always just squash our commits before we run this command, arc diff.  
> http://www.youtube.com/watch?v=HUE_yrd8tl0

## ZenHub / GitHub Issues

Each issue should have:

* Assignee
* Milestone
* Estimate
* Epic

Create new issues / epics as necessary.

## Estimating with story points

* 3 - Small
* 5 - Medium
* 8 - Large
* 13 - Extra Large

If a task is larger than 13, then create multiple smaller tickets. If a task is smaller than 3, complete the task without a ticket.

## Daily standup

A daily asynchronous check in. Answer [the following questions](https://support.standuply.com/article/97-how-to-customize-the-questions), with reference to the GitHub tickets. The goal is to reflect on yesterday and create a plan for today.

* What did you do yesterday?
* What do you plan on doing today?
* Okay, any obstacles? 

For teams with large time zone differences, it may make sense to have standups at the end of the day. The questions are slightly different. The goal is to sum up the day and then think about tomorrow.

* What did you do today?
* What do you plan on doing tomorrow?
* Okay, any obstacles? 

An example standup report:

* John
  * Yesterday I worked on #13 upgrading the lint package
  * Today I will work on #15 setting up the CI job on bitrise
  * No blockers

## Slack chat

Team members should be in a shared Slack channel to asynchronously share information.

## Dart

- Follow effective dart naming guidelines
  - https://dart.dev/guides/language/effective-dart/style
- Follow standard directory structure for Dart
  - https://dart.dev/guides/libraries/create-library-packages
- Use tool folder instead of bin for private scripts
  - https://dart.dev/tools/pub/package-layout#public-tools

## Writing bash scripts

Make sure your shell script is safe by adding the following lines: 
```bash
#!/usr/bin/env bash
set -euxo pipefail
```

Read more [here](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/)

# Alternatives Considered

> Summarize alternative designs (pros & cons)

- Multirepo. Introduces complexity in managing the project if each project has a different repo.

# Timeline

> Document milestones and deadlines.

DONE:

  - Migrated all code to a mono repo
  - Added new process document

NEXT:

  - Try the new software development process
  
# Results

> What was the outcome of the project?
