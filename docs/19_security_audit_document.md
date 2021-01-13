# Security Audit Document
> Summary of the proposed change

Describe the security aspects of Metrics Web, CI Integrations, and Coverage Converter parts.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations user guide](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/02_ci_integration_user_guide.md)
- [Coverage converter](https://github.com/platform-platform/monorepo/blob/master/metrics/coverage_converter/docs/01_coverage_converter_design.md)
- [Privacy and Security in Firebase](https://firebase.google.com/support/privacy)

# Motivation
> What problem is this project solving?

This document describes the security aspects of the Metrics project parts.

# Goals
> Identify success metrics and measurable goals.

This document aims the following goals: 

- Explain the security aspects of the Metrics Web App application.
- Explain the security aspects of the CI Integrations.
- Explain the security aspects of the Coverage Converter.

# Non-Goals
> Identify what's not in scope.

This document does not describe the implementation of the Metrics project parts.

# Table of Contents

1. [Metrics Web Application security aspects](#metrics-web-application)
2. [CI Integrations security aspects](#ci-integrations)
3. [Coverage converter security aspects](#coverage-converter)

# Metrics Web Application
> Describe the security aspects of the Metrics Web Application.

Metrics Web Application uses Firebase services. Consider the following documentation that describes the [`Privacy and Security of Firebase services`](https://firebase.google.com/support/privacy).

## Authentication

Metrics Web Application uses the `Email and Password` and the `Google` sign-in options.

The `Email and Password` sign in option uses the [`firebase_auth`](https://pub.dev/packages/firebase_auth) package that is a part of [`FlutterFire`](https://firebase.flutter.dev/). `FlutterFire` is a set of official Firebase plugins for Flutter.

The `Google` sign in option uses the [google_sign_in](https://pub.dev/packages/google_sign_in) package made by the Flutter Team.

The `Google` sign in option provides the user's email, OAuth2 access token, and OpenID Connect ID token, which then are passed to the [Firebase `Social Authentication` (3-rd party authentication method)](https://firebase.flutter.dev/docs/auth/social).

Firebase saves the information about users including the email, sign-in provider, creation date, last sign in and the user's UID, and is available in the [`Firebase Console`](https://console.firebase.google.com/).

`Firebase Authentication` persists the user's authentication state by default using the `localstorage`. The same strategy is used in Metrics Web Application. Consider the following links to learn more about the authentication state persistence: [`FlutterFire` documentation](https://firebase.flutter.dev/docs/auth/usage#persisting-authentication-state) and [`Firebase` documentation](https://firebase.google.com/docs/auth/web/auth-state-persistence).

## Database

Metrics Web Application uses the `Firebase Cloud Firestore` as a database.

Consider the following [document that describes the  data model used in `Firebase Cloud Firestore`](https://firebase.google.com/docs/firestore/data-model).

### The `allowed_email_domains` collection

The `allowed_email_domains` collection contains the allowed email domains for the `Google` sign in option.

#### Documents

Each document represents a single valid email domain.

#### Document structure

Each document stores a valid email domain as a name and does not contain any fields.

### The `build` collection

The `build` collection contains build data for all projects within the Metrics Web Application.

#### Documents

Each document represents a single build for a specific project.

#### Document structure

Consider the following table that describes the fields of a document within the `build` collection:

| Field        | Description                                                 |
|--------------|-------------------------------------------------------------|
|`buildNumber` | A number of this build.                                     |
|`buildStatus` | A resulting status of this build.                           |
|`coverage`    | A test coverage percent of this build.                      |
|`duration`    | A duration of this build excluding the queue time.          |
|`projectId`   | An id of the project this build belongs to.                 |
|`startedAt`   | A date-time of this build's start.                          |
|`url`         | A URL of the source control revision used to run the build. |
|`workflowName`| A name of the workflow executed this build.                 |

### The `feature_config` collection

The `feature_config` collection contains the configuration values to enable or disable the application features.

#### Documents

This collection contains a single `feature_config` document.

#### Document structure

Consider the following table that describes the fields of the `feature_config` document:

| Field                           | Description                                                           |
|---------------------------------|-----------------------------------------------------------------------|
| `isDebugMenuEnabled`            | Indicates whether the `Debug Menu` feature is enabled.                |
| `isPasswordSignInOptionEnabled` | Indicates whether the `Email and Password` sing in option is enabled. |

### The `project_groups` collection

The `project_groups` collection contains project group data including the name of the project group and project IDs that belong to this project group.

#### Documents

Each document contains data of a specific project group.

#### Document structure

| Field        | Description                                               |
|--------------|-----------------------------------------------------------|
| `name`       | A name of this project group.                             |
| `projectIds` | A list of project IDs that belong to this project group.  |

### The `projects` collection

The `projects` collection contains project data.

#### Documents

Each document contains data on a specific project.

#### Document structure

| Field  | Description             |
|--------|-------------------------|
| `name` | A name of this project. |

### The `user_profiles` collection

The `user_profiles` collection contains user profiles` data including the selected theme.

#### Documents

Each document contains data associated with a specific user profile.

#### Document structure

| Field           | Description                                  |
|-----------------|----------------------------------------------|
| `selectedTheme` | A theme selected by the specific user.       |

### Security rules and tests

The application uses the `Firebase Cloud Firestore Security Rules` to protect the database. The `Security Rules` describe certain conditions needed to access or modify the database. The `Firebase Security Rules` provide the main protection for the data used in the project.

Consider the following subsections that describe the security rules for the `Firebase Cloud Firestore` collections:

#### [`project_groups`](#the-project_groups-collection) collection security rules:

| Operation         | Security Rules                         |
|-------------------|----------------------------------------|
| `read`, `delete`  | `Authorization`                        | 
| `create`, `update`| `Authorization`, `isProjectGroupValid` | 


#### [`projects`](#the-projects-collection) collection security rules:

| Operation          | Security Rules                    |
|--------------------|-----------------------------------|
| `read`             | `Authorization`                   |
| `create`, `update` | `Authorization`, `isProjectValid` |
| `delete`           | `Prohibited`                      |

#### [`build`](#the-build-collection) collection security rules:

| Operation          | Security Rules                  |
|--------------------|---------------------------------|
| `read`             | `Authorization`                 |
| `create`, `update` | `Authorization`, `isBuildValid` |
| `delete`           | `Prohibited`                    |

#### [`user_profiles`](#the-user_profiles-collection) collection security rules:

| Operation | Security Rules                                           |
|-----------|----------------------------------------------------------|
| `get`     | `Authorization`, `isDocumentOwner`                       |
| `write`   | `Authorization`, `isDocumentOwner`, `isUserProfileValid` |
| `list`    | `Prohibited`                                             |
| `delete`  | `Prohibited`                                             |

#### [`feature_config`](#the-feature_config-collection) collection security rules:

| Operation | Security Rules |
|-----------|----------------|
| `read`    | `Allowed`      |
| `write`   | `Prohibited`   |

#### [`allowed_email_domains`](#the-allowed_email_domains-collection) collection security rules:

| Operation       | Security Rules |
|-----------------|----------------|
| `read`, `write` | `Prohibited`   |

These rules are covered with tests which are located in the [`metrics/firebase/test/firestore/security_rules`](https://github.com/platform-platform/monorepo/tree/master/metrics/firebase/test/firestore/rules) folder.

Each rule is tested imitating any possible type of user. Consider the following types of users used under tests:

- `Unauthenticated user`.
- `Authenticated with a password and allowed email domain user with a verified email`.
- `Authenticated with a password and not allowed email domain user with a verified email`.
- `Authenticated with a password and allowed email domain user with not verified email`.
- `Authenticated with a password and not allowed email domain user with not verified email`.
- `Authenticated with Google and allowed email domain user with a verified email`.
- `Authenticated with Google and not allowed email domain user with a verified email`.
- `Authenticated with Google and allowed email domain user with not verified email`.
- `Authenticated with Google and not allowed email domain user with not verified email`.

The tests also cover invalid data input cases if the rule requires additional data validation.

### Key protection

Metrics Web Application uses [`Firebase Key Restrictions`](https://github.com/platform-platform/monorepo/blob/master/docs/09_firebase_deployment.md#api-key-restrictions) to restrict the services available using the Metrics Firebase project key (also known as `Browser Key`) and restricts the origins this key can be used from.

Currently, the 3 APIs are enabled for the `browser key`:
- `Identity Toolkit API`.
- `Token Service API`.
- `Firebase Installations API`.

### Email domains validation

The application provides additional data protection by allowing to control which email domains are allowed to sign in with Google.
Application validates the user's email while signing in using the `Google` sign in option. If the provided email does not have the allowed domain, the application denies the sign in attempt.

# CI Integrations

A CI Integrations tool is a command-line application that helps to import build data to the Metrics project making it available in the Metrics Web Application.
Consider the [following document to learn more about the CI Integrations tool](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/02_ci_integration_user_guide.md).

## Authorization

To be able to import the build data, the CI Integrations tool needs to authorize itself in the `source` CI the build data comes from, and in the `destination` Firebase Cloud Firestore Database.

To authorize in the Firebase, the CI Integration tool uses the `email` and `password` credentials.

CI Integrations tool uses different types of authorization in CIs and uses HTTP headers to pass the authorization credentials. Consider the following table that describes the authorization methods in different CIs used by the CI Integrations tool:

| CI name        | HTTP header     | Value                                      | Authorization type   |
|----------------|-----------------|--------------------------------------------|----------------------|
|`Github Actions`| `Authorization` | `Bearer <your_token>`                      | Bearer authorization |
|`Buildkite`     | `Authorization` | `Bearer <your_token>`                      | Bearer authorization |
|`Jenkins`       | `Authorization` | `base64(<your_username>:<your_api_token>)` | Basic authorization  |

The CI Integration tool does not store any access credentials and takes them directly from the CI Integrations Config. 

## Configuration

As mentioned, the CI Integrations tool does not store any configuration files or any authorization credentials and parses all the relevant information from the given configuration file.

## Data stored

The CI Integrations tool processes and transfers build data to the Cloud Firestore Database and does not store any data.

# Coverage converter

The Coverage Converter allows converting coverage data from specific coverage tool output format into Metrics coverage format.

## Data stored

The Coverage Converter converts coverage reports of different formats into Metrics coverage format and does not store any data. 
