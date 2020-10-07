# Metrics developer configuration

> Summary of the proposed change

# References

> Link to supporting documentation, GitHub tickets, etc.

# Motivation

> What problem is this project solving?

The document with instructions on how to run the project locally and make all the features working.

# Goals

> Identify success metrics and measurable goals.

- Provide an information about the Flutter version, needed to run the Metrics application.
- Describe the ways to run the Metrics Application with working Google Sign-in.

# Non-Goals

> Identify what's not in scope.

IDE configuration is out of scope.

# Design

> Explain and diagram the technical design
>
> Identify risks and edge cases

# API

> What will the proposed API look like?

## Supported browsers

Currently, the Metrics Application supports only the Google Chrome browser. It means that the application is well-tested and debugged using the Google Chrome browser, and it can be not so stable on the other browsers.

## Flutter version

The Metrics Application is developing and testing on the Flutter `beta` channel and `1.22.0-12.1.pre` version.

## Running the Metrics Application

To run the Metrics Application with an ability to use the Google Sign-in we should run the application on the `8080` or `5000` port. To do so, run the application with the the following arguments: 

`--web-hostname=localhost --web-port=8080`

To run the application using the SKIA renderer we should use the following arguments: 

`--dart-define=FLUTTER_WEB_USE_SKIA=true --profile` or `--dart-define=FLUTTER_WEB_USE_SKIA=true --release`

# Dependencies

> What is the project blocked on?

No blockers.

> What will be impacted by the project?

Nothing will be impacted.

# Testing

> How will the project be tested?

The project will be tested manually by the Metrics team members.

# Alternatives Considered

> Summarize alternative designs (pros & cons)

No alternatives considered.

# Timeline

> Document milestones and deadlines.

DONE:

  - Provided information about the Flutter version, needed to run the Metrics application.
  - Described the ways to run the Metrics Application with working Google Sign-in.    

# Results

> What was the outcome of the project?

As a result, we've got documented the currently used Flutter version and thee ways of running the Metrics application.