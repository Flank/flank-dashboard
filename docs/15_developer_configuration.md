# Metrics developer configuration

> Summary of the proposed change

Specify the relevant Flutter version for Metrics application and describe the ways of running the application with all features available.

# References

> Link to supporting documentation, GitHub tickets, etc.

- [Web support for Flutter](https://flutter.dev/web)

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

# API

> What will the proposed API look like?

## Supported browsers

Latest Google Chrome browser.

## Flutter version

The Metrics Application is developing and testing on the Flutter `beta` channel and `1.25.0-8.2.pre` version.

Notice that if you are running the Flutter web application for the first time, you should execute the following command to enable the web support: 

`flutter config --enable-web`

## Running the Metrics Application

To run the Metrics Application with an ability to use the Google Sign-in we should run the application on the `8080` or `5000` port. To do so, run the application with the following arguments: 

`--web-port=8080` or `--web-port=5000`

After the application started, you should copy the application URL from the Google Chrome debug window and place it to the regular Google Chrome window to be able to use the Google Sign-in.

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

As a result, we've got documented the currently used Flutter version and the ways of running the Metrics application.
