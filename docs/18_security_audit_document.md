# Security Audit Document
> Summary of the proposed change

Describe the security aspects of the Metrics Web Application, CI Integrations tool, and Coverage Converter tool. Examine the data these applications use and store in the Metrics Database. Explore authorization processes of the applications and their usage, if any.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations user guide](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/02_ci_integration_user_guide.md)
- [Coverage converter](https://github.com/platform-platform/monorepo/blob/master/metrics/coverage_converter/docs/01_coverage_converter_design.md)
- [Privacy and Security in Firebase](https://firebase.google.com/support/privacy)

# Motivation
> What problem is this project solving?

This document describes the security aspects of the Metrics project applications.

# Goals
> Identify success metrics and measurable goals.
 
This document has the following goals:

- Examine the auth mechanisms used by the Metrics applications.
- Examine the security of data, and the data itself, stored and used by the Metrics applications.
- Examine other security aspects of the Metrics applications.

# Non-Goals
> Identify what's not in scope.

The implementation notes of any parts of the Metrics applications are out of the scope for this document. Consider the documentation for each of these applications to know more about their implementation and structure:
- [Web Application docs](https://github.com/platform-platform/monorepo/tree/master/metrics/web/docs)
- [CI Integration docs](https://github.com/platform-platform/monorepo/tree/master/metrics/ci_integrations/docs)
- [Coverage Converter docs](https://github.com/platform-platform/monorepo/tree/master/metrics/coverage_converter/docs)

# Table of Contents

1. [Metrics Web Application security aspects](#metrics-web-application)
2. [CI Integrations security aspects](#ci-integrations)
3. [Coverage converter security aspects](#coverage-converter)

# Metrics Web Application
> Describe the security aspects of the Metrics Web Application.

The Metrics Web Application widely uses Firebase services (such as Firestore Database, Authentication, Cloud Functions, Analytics, and Hosting). Consider the following [document](https://firebase.google.com/support/privacy) that describes the privacy and security of Firebase services.

## Authentication

The Metrics Web Application uses Firebase Authentication with `Email and Password` and `Google` sign-in methods. Both methods are implemented using the third-party packages from the `pub.dev` published officially by the Firebase and Flutter teams.

The main part of the Firebase Authentication integration is using the [`firebase_auth`](https://pub.dev/packages/firebase_auth) package. Consider the following statements about the authentication methods available: 
- The `Email and Password` method directly uses the [`firebase_auth`](https://pub.dev/packages/firebase_auth) package and signs in a user with the given email and password.
- The `Google Sign-In` method uses [google_sign_in](https://pub.dev/packages/google_sign_in) package to perform sign in and then pass the obtained credentials (the user's email, OAuth2 access token, and OpenID Connect ID token) to the [Firebase `Social Authentication`](https://firebase.flutter.dev/docs/auth/social) (3-rd party authentication method). At the moment, the `Google Sign-In` method is performed with the `email` scope.

Firebase saves the information about users such as the email, sign-in provider, creation date, last sign in, and the user's ID. This information is available in the [`Firebase Console`](https://console.firebase.google.com/) on the `Firebase Authentication` page under the `Users` tab.

To keep users signed-in, `Firebase Authentication` persists the user's authentication state using the `local storage` by default. The Metrics Web Application does not override the default behavior. Both [`FlutterFire` documentation](https://firebase.flutter.dev/docs/auth/usage#persisting-authentication-state) and [`Firebase` documentation](https://firebase.google.com/docs/auth/web/auth-state-persistence) provide more information about the authentication state persistence.

_Note: Metrics does not duplicate the user's authentication data to the third-party databases! All authentication-related data is managed by the Firebase Authentication and is passed to it using official packages._

## Database

Metrics Web Application uses the `Firebase Cloud Firestore` as a database.

Consider the following [document](https://firebase.google.com/docs/firestore/data-model) that describes the data model used in `Firebase Cloud Firestore`.

The application uses the `Firebase Cloud Firestore Security Rules` to protect the data stored in the `Cloud Firestore`. The `Security Rules` describe conditions that should be met to access or modify the data these rules are protecting. If the CRUD request does not satisfy the appropriate set of conditions, this request is refused as having insufficient permissions.

Let's follow with a description of the `Security Rule` applied to the `Firestore Database` collections:

### Security Rules Description

| Rule                 | Description |
|----------------------|-------------|
| <a id="isaccessauthorized"></a>`isAccessAuthorized`| The user is authenticated and the email domain is valid. |
| <a id="isprojectvalid"></a>`isProjectValid`| The request data contains only allowed fields, declared in the [projects collection](#the-projects-collection) section, with valid data types. |
| <a id="isprojectgroupvalid"></a>`isProjectGroupValid`| The request data contains only allowed fields, declared in the [project_groups collection](#the-project_groups-collection) section, with valid data types. |
| <a id="isbuildvalid"></a>`isBuildValid` | A project with the project ID from the request data exists in the database, and all the rest fields have a valid data type. The given build data contains only allowed fields declared in the [build collection](#the-build-collection) section. |
| <a id="isdocumentowner"></a>`isDocumentOwner` | The user is the owner of the given document. |
| <a id="isuserprofilevalid"></a>`isUserProfileValid` | The request data contains only allowed fields, declared in the [user_profiles collection](#the-user_profiles-collection) section, with valid data types. |
| <a id="prohibited"></a>`Prohibited`| Always prohibited. | 
| <a id="allowed"></a>`Allowed` | Always allowed. |

Let's review each `Firestore Database` collection and rules for these collections:

### The `projects` collection

The `projects` collection defines projects within the Metrics Web Application. The single document stands for one project and contains the project's name.

Consider the following table that describes the fields of the `projects` document:

| Field  | Description             |
|--------|-------------------------|
| `name` | A name of this project. |

Here is a table of security rules applied to the `projects` collection:

| Operation          | [Security Rules](#security-rules-description) |
|--------------------|----------------------------------------|
| `read`             | [`isAccessAuthorized`](#isaccessauthorized)                   |
| `create`, `update` | [`isAccessAuthorized`](#isaccessauthorized), [`isProjectValid`](#isprojectvalid) |
| `delete`           | [`Prohibited`](#prohibited) |

### The `build` collection

The `build` collection contains build data for all projects within the Metrics Web Application. The single document of this collection stands for a single build for a specific project.

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
|`workflowName`| A name of the workflow that executed this build.            |

Here is a table of security rules applied to the `build` collection:

| Operation          | [Security Rules](#security-rules-description) | 
|--------------------|--------------------------------------|
| `read`             | [`isAccessAuthorized`](#isaccessauthorized) |
| `create`, `update` | [`isAccessAuthorized`](#isaccessauthorized), [`isBuildValid`](#isbuildvalid) |
| `delete`           | [`Prohibited`](#prohibited) |

### The `build_days` collection

The `build_days` collection contains the aggregated project metrics of builds performed during a single day. The single document of this collection stands for a single project metrics aggregation for a specific project of builds performed during a single day.

Consider the following table that describes the fields of a document within the `build_days` collection:

| Field                      | Description                                                                            |
|----------------------------|----------------------------------------------------------------------------------------|
| `projectId`                | An id of the project this build day belongs to.                                        |
| `day`                      | A timestamp of this build day.                                                         |
| `successful`               | A total number of successful builds performed during this build day.                   |
| `failed`                   | A total number of failed builds performed during this build day.                       |
| `inProgress`               | A total number of in-progress builds started during this build day.                    |
| `successfulBuildsDuration` | A total duration in milliseconds of successful builds performed during this build day. |

Here is a table of security rules applied to the `build_days` collection:

| Operation | [Security Rules](#security-rules-description) |
|-----------|---------------------------------------------|
| `write`   | [`Prohibited`](#prohibited)                 |
| `read`    | [`isAccessAuthorized`](#isaccessauthorized) |

Any modification of this collection is prohibited. The `build_days` collection is managed by the `Cloud Functions` component. Consider this [section](#firebase-cloud-functions) describing the `Cloud Functions` related security aspects.

### The `project_groups` collection

The `project_groups` collection contains project group data. The single document of this collection contains data of a specific project group.

Consider the following table that describes the fields of the `project_groups` document:

| Field        | Description                                               |
|--------------|-----------------------------------------------------------|
| `name`       | A name of this project group.                             |
| `projectIds` | A list of project IDs that belong to this project group.  |

Here is a table of security rules applied to the `project_groups` collection:

| Operation         | [Security Rules](#security-rules-description) |
|-------------------|---------------------------------------------|
| `read`, `delete`  | [`isAccessAuthorized`](#isaccessauthorized) | 
| `create`, `update`| [`isAccessAuthorized`](#isaccessauthorized), [`isProjectGroupValid`](#isprojectgroupvalid) | 

### The `user_profiles` collection

The `user_profiles` collection contains user profiles' data including the selected theme. The single document of this collection holds the data of the specific user.

Consider the following table that describes the fields of the `user_profiles` document:

| Field           | Description                                  |
|-----------------|----------------------------------------------|
| `selectedTheme` | A theme selected by the specific user.       |

Here is a table of security rules applied to the `user_profiles` collection:

| Operation | [Security Rules](#security-rules-description) |
|-----------|---------------------------------------------------------------|
| `get`     | [`isAccessAuthorized`](#isaccessauthorized), [`isDocumentOwner`](#isdocumentowner) |
| `write`   | [`isAccessAuthorized`](#isaccessauthorized), [`isDocumentOwner`](#isdocumentowner), [`isUserProfileValid`](#isuserprofilevalid) |
| `list`    | [`Prohibited`](#prohibited) |
| `delete`  | [`Prohibited`](#prohibited) |

### The `allowed_email_domains` collection

The `allowed_email_domains` collection contains the allowed email domains for the `Google Sign-In` method. The single document of this collection stands for the email domain that is allowed and may be used to authorize a user.

The documents of this collection do not have any fields. Instead, the ID of the document represents a single email domain. This prevents duplicates of email domains and simplifies validating as documents aren't to be fetched.

Here is a table of security rules applied to the `allowed_email_domains` collection:

| Operation       | [Security Rules](#security-rules-description) |
|-----------------|----------------|
| `read`, `write` | [`Prohibited`](#prohibited) |

### The `feature_config` collection

The `feature_config` collection contains the configuration values to enable or disable the application features. This collection contains a single `feature_config` document containing all configurations for the whole application.

Consider the following table that describes the fields of the `feature_config` document:

| Field                           | Description                                                           |
|---------------------------------|-----------------------------------------------------------------------|
| `isDebugMenuEnabled`            | Indicates whether the `Debug Menu` feature is enabled.                |
| `isPasswordSignInOptionEnabled` | Indicates whether the `Email and Password` sign in option is enabled. |

Here is a table of security rules applied to the `feature_config` collection:

| Operation | [Security Rules](#security-rules-description) |
|-----------|----------------|
| `read`    | [`Allowed`](#allowed) |
| `write`   | [`Prohibited`](#prohibited) |

### The `tasks` collection

The `tasks` collection contains the list of failed [Firebase Cloud functions](#firebase-cloud-functions) to re-run them separately. The single document of this collection stands for a single failed task that needs to be re-run.

Consider the following table that describes the fields of a document in the `tasks` collection:

| Field       | Description |
|-------------|-------------|
| `code`   	  | A code that identifies the task to perform (e.g. `build_day_created`, `build_day_updated`). |
| `data`      |	A map containing the data needed to run the task with the specified code. |
| `context`   |	An additional context for this task. |
| `createdAt` |	A timestamp with this task creation date. |

Here is a table of security rules applied to the `tasks` collection:

| Operation       | [Security Rules](#security-rules-description) |
|-----------------|----------------|
| `read`, `write` | [`Prohibited`](#prohibited) |

### Security Rules Testing

To prove the Security Rules work in the expected way, they are covered with tests. Consider [`metrics/firebase/test/firestore/security_rules`](https://github.com/platform-platform/monorepo/tree/master/metrics/firebase/test/firestore/rules) to examine the tests.

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

### Firebase Cloud Functions

The [Firebase Cloud Functions](https://firebase.google.com/docs/firestore/extend-with-functions) component is responsible the [`build_days` collection](#the-build_days-collection) updates when the [`build` collection](#the-build-collection) changes. The `Firebase Cloud Functions` do not store any data, and just process the [`build` collection](#the-build-collection) updates.

The `Firebase Cloud Functions` includes the two main functions: `onBuildAdded` and `onBuildUpdated`. Let's review them in a bit more details:

#### The `onBuildAdded` function
This function is triggered when a new build is added to the [`build` collection](#the-build-collection). If this build is the first build of this project performed during a day, the function creates a new document in the [`build_days` collection](#the-build_days-collection) and adds the build data aggregation to it. Otherwise, the function updates an existing `build_day` document.

#### The `onBuildUpdated` function
This function is triggered when a specific build is updated in the [`build` collection](#the-build-collection), for example, when an in-progress build finishes and the [CI Integrations tool](#ci-integrations) updates its data in the database. The function searches for a build day aggregation the old build data belongs to and updates any necessary fields.

### Firebase Key Protection

Metrics Web Application uses [`Firebase Key Restrictions`](https://github.com/platform-platform/monorepo/blob/master/docs/08_firebase_deployment.md#api-key-restrictions) to restrict the services available using the Metrics Firebase project key (also known as `Browser Key`) and restricts the origins this key can be used from.

Currently, the following APIs are enabled for the `browser key`:
- `Identity Toolkit API`
- `Token Service API`
- `Firebase Installations API`
- `Firebase Management API`

### Email domains validation

The application provides additional data protection by allowing to control which email domains are allowed to sign in with Google.
Application validates the user's email while signing in using the `Google` sign in option. If the provided email does not have the allowed domain, the application denies the sign in attempt.

# CI Integrations

A CI Integrations tool is a command-line application that helps to import build data to the Metrics project making it available in the Metrics Web Application.
Consider the following [document](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/02_ci_integration_user_guide.md) to learn more about the CI Integrations tool.

## Authorization

To be able to import the build data, the CI Integrations tool needs to authorize itself in the `source` CI the build data comes from, and in the `destination` Firebase Cloud Firestore Database.

To authorize in the Firebase, the CI Integration tool uses the `email` and `password` credentials.

CI Integrations tool uses different types of authorization in CIs and uses HTTP headers to pass the authorization credentials. Consider the following table that describes the authorization methods in different CIs used by the CI Integrations tool:

| CI name        | HTTP header     | Value                                      | Authorization type   |
|----------------|-----------------|--------------------------------------------|----------------------|
|`Github Actions`| `Authorization` | `Bearer <your_token>`                      | Bearer authorization |
|`Buildkite`     | `Authorization` | `Bearer <your_token>`                      | Bearer authorization |
|`Jenkins`       | `Authorization` | `base64(<your_username>:<your_api_token>)` | Basic authorization  |

The CI Integration tool does not store any access credentials and takes them directly from the CI Integrations configuration file.

## Configuration

As mentioned, the CI Integrations tool does not store any configuration files or any authorization credentials and parses all the relevant information from the given configuration file.

## Data stored

The CI Integrations tool processes and transfers build data to the Cloud Firestore Database and does not store any data.

# Coverage converter

The Coverage Converter allows converting coverage data from specific coverage tool output format into Metrics Coverage format.

The Coverage Converter does not send anything to the third-parties or to the databases, it just converts the given data to the Metrics Coverage format.
