# Storing Storage Metadata
> Summary of the proposed change

Store the Metrics storage metadata to simplify the Metrics applications update process.

# Motivation
> What problem is this project solving?

Simplifies the process of updating the Metrics applications, and the storage structure.

# Goals
> Identify success metrics and measurable goals.

This document follows the next goals:

- Describe the place of storing the storage metadata.
- Explain the way of storing the current Metrics applications supported storage version.
- Describe the mechanism of blocking the Metrics applications during the storage update process.

# Non-Goals
> Identify what's not in scope.

This document does not include any information on how to update the Metrics application/storage. Also, the loading of the current storage version in the Metrics applications is out of scope.

# Design

> Explain and diagram the technical design
>
> Identify risks and edge cases

To detect the storage structure updates in the Metrics applications, we should add the `metadata` collection to the Firestore storage and have the supported storage version available in the Metrics applications.

Let's review the way of storing the storage metadata:

## Storage Metadata
> Explain the way of storing the storage metadata.

### Firestore
> Explain the database structure and rules needed to store the metadata in the Firestore.

To store the storage metadata and make it easily accessible, we need to add the `metadata` collection with the `metadata` document. This document will contain the `storageVersion` field of `String` and `isUpdating` `boolean` field.

So, the database structure will look like the following:

> - projects
> - ...
> - metadata
>   - metadata
>       - storageVersion: String
>       - isUpdating : bool


The `metadata` collection should have the following security rules:

- No one can write (update, delete, create) documents in this collection.
- Anybody can read documents from this collection.

To update the storage metadata we should use the Firebase Admin SDK.

## Supported Storage Version
> Explain the way of storing the application version and providing it to the Metrics applications.

To detect whether the application is compatible with the storage, we should have the supported storage version in the Metrics applications. The supported storage version is a version of the storage this application can interact with. Actually, it is a version of the storage at the time of building the Metrics application. Since this value is common for the storage and Metrics applications, we should make it easily accessible in any application like `CI Integrations`, `Metrics CLI`, or `Metrics Web`.

To do so, we can store the storage version in the `STORAGE_VERSION` file under the [metrics](https://github.com/Flank/flank-dashboard/tree/master/metrics) package of our repository. It allows us to get the contents of this file and pass it as a `SUPPORTED_STORAGE_VERSION` environment variable to any Metrics application during the building process. Also, with the `STORAGE_VERSION` file, it will be much easier to get the current storage version during the deployment/update process.

### Set supported storage version for the Metrics Web Application
> Explain the way of passing the supported storage version to the Metrics Web Application.

Let's consider an example of a Unix shell script for getting the storage version from the file and passing it to the `Metrics Web Application` as a `SUPPORTED_STORAGE_VERSION` environment variable.

Assume we run the following script under the `metrics/web` package:

```bash
SUPPORTED_VERSION=$(cat ../STORAGE_VERSION)

flutter build web --release --dart-define=SUPPORTED_STORAGE_VERSION=$SUPPORTED_VERSION
```

So, we are getting the storage version from the `STORAGE_VERSION` file and storing it to the `SUPPORTED_VERSION` variable using the `SUPPORTED_VERSION=$(cat ../STORAGE_VERSION)` command. After that, we are using this variable in the `--dart-define=SUPPORTED_STORAGE_VERSION=$SUPPORTED_VERSION` flag to set the Flutter application environment variable.

### Set supported storage version for the command line applications
> Explain the way of passing the supported storage version to the command line applications.

For command-line applications, we should use a bit different script to pass the supported version into the application.

Imagine we are trying to build the `CI Integrations` tool, so we should run the following script from the project root directory:

```bash
SUPPORTED_VERSION=$(cat ../STORAGE_VERSION)

dart2native bin/main.dart --define=SUPPORTED_STORAGE_VERSION=$SUPPORTED_VERSION
```

### Get the supported storage version
> Explain the way of retrieving the supported storage version in the Metrics applications.

To get the application version in the Metrics applications, we can use the following line of code:

```dart
const supportedStorageVersion = String.fromEnvironment('SUPPORTED_STORAGE_VERSION');
```

## Making Things Work
> Explain the usage of the supported storage version in the Metrics applications.

Once we have a storage version in the Firestore database and a supported storage version in the Metrics applications, we should block the Metrics applications from updating the storage records when the storage is updating or its version is not supported by the application.

### Metrics Web Application
> Explain the usage of the supported storage version in the Metrics Web Application.

Since this document examines the supported storage version feature on a very top level, let's review the simplest application blocking process that includes logging out a user from the application. It allows us to block storage interactions in the application without any significant changes in its logic. But since we have an `isUpdating` flag in the storage, it allows us to change the behavior later and avoid logging out users during the application updates.

If the application does not support the current storage version, we should follow the next steps:

1. Log out a user from the application.
2. Redirect the user to the `Update application` page. This page will notify a user about the current application is not compatible with the storage version and propose to contact the administrator to resolve this conflict.

If the storage update is in progress, we should follow the next steps:

1. Log out a user from the application.
2. Redirect the user to the `Updating the application` page to notify the user about the Metrics application update in progress.

See [Metrics Web Supported Storage Version](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/supported_storage_version/01_supported_storage_version.md) document to get more implementation details.

### CI Integrations Tool
> Explain the usage of the supported storage version in the CI Integrations tool.

If the `CI Integrations` tool is not compatible with the current storage version or the storage is updating, we should fail the synchronization process and show the error message explaining what is going on. The error message should explain the reason for stopping the synchronization clearly, including information on how to resolve the problem. For example, if we've interrupted the synchronization due to the application does not support the current storage version, we can show the following error message:

```
The current application version is out of date. Please, use the following link to download a latest version of the application and try again: 
https://github.com/Flank/flank-dashboard/releases/download/ci_integrations-snapshot/ci_integrations_macos
```

### Metrics CLI Tool
> Explain the usage of the supported storage version in the Metrics CLI tool.

The Metrics CLI tool should use the `STORAGE_VERSION` file during deployment to set the current storage version and pass the supported application version to the Metrics applications.

To save the storage version to the Firestore database `metadata` collection, this tool should use Firebase Admin SDK to create/update a `metadata` collection with the storage version. To set the supported storage version, the Metrics CLI should get the current storage version from the `STORAGE_VERSION` file and pass it to the building command, as described in the [Supported Storage Version](#Supported-Storage-Version) section.

# Dependencies
> What will be impacted by the project?

This project will impact the process of building and updating the Metrics applications.

# Results

> What was the outcome of the project?

This document described the place of storing the storage metadata and application supported storage version. Also, it explained the mechanism of blocking the Metrics applications when the application does not support the current storage version.
