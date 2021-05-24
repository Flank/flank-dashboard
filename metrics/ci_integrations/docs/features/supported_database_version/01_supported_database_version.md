# CI Integration Supported Database Version
> Summary of the proposed change

Have the supported database version in the CI Integrations tool to block the project metrics data synchronization during the database updates or when the CI Integrations tool does not support the current database version.

# References
> Link to supporting documentation, GitHub tickets, etc.
- [Storing database metadata](https://github.com/platform-platform/monorepo/blob/master/metrics/docs/01_storing_database_metadata.md)
- [Metrics Web Supported Database Version](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/supported_database_version/01_supported_database_version.md)

# Motivation
> What problem is this project solving?

Preventing the CI Integrations tool from modifying the database with a version the tool does not support, or during database updates.

# Goals
> Identify success metrics and measurable goals.

This document has the following goals:
- Describe the process of getting the supported database version of the CI Integrations tool.
- Describe the way of loading the current database metadata from the Firestore database.
- Explain the process of blocking the project metrics data synchronization during database updates or when the CI Integrations tool does not support the current database version.

# Non-Goals
> Identify what's not in scope.

This document does not describe the way of storing the database and supported database versions. See [Storing Database Metadata](https://github.com/platform-platform/monorepo/blob/master/metrics/docs/01_storing_database_metadata.md) document to get more info about these details.

# Design
> Explain and diagram the technical design
>
> Identify risks and edge cases

To be able to detect whether the CI Integrations tool is compatible with the current database, we should modify the [`synchronization algorithm`](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md#synchronization-algorithm) to perform all necessary compatibility checks before running the `InProgressBuildsSyncStage` and the `NewBuildsSyncStage`. See this [section](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/features/in_progress_builds/in_progress_builds_introduction.md#sync-algorithm-stages) to learn more about `SyncStage`s and their responsibilities.

According to the above, we should introduce a new `DatabaseVersionSyncStage` that is responsible for performing the required database compatibility checks, and run it at the beginning of the project metrics synchronization. If the CI Integrations tool does not support the current database version, or the database is updating, the synchronization must fail with the informative error message describing the required steps the user needs to perform to overcome the occurred issue. 

To sum up, the synchronization algorithm now must include the `SyncStage`s in the following order:
`DatabaseVersionSyncStage` -> `InProgressBuildsSyncStage` -> `NewBuildsSyncStage`

## DatabaseVersionSyncStage
The `DatabaseVersionSyncStage` needs the following values to be able to detect whether the CI Integrations tool is compatible with the current database:
- [Supported database version](#Supported-Database-Version) of this CI Integrations tool;
- [Database metadata](#Getting-Database-Metadata).

Let's review the way of getting each of them separately:

### Supported Database Version
> Explain the process of getting the supported database version.

Since the CI Integrations tool is built with the `SUPPORTED_DATABASE_VERSION` environment variable (based on the [Storing Database Metadata](https://github.com/platform-platform/monorepo/blob/master/metrics/docs/01_storing_database_metadata.md#supported-database-version) document), we can get this value in the application from the environment, using the `ApplicationMetadata` class from the [core](https://github.com/platform-platform/monorepo/tree/master/metrics/core) library (as described in this [section](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/supported_database_version/01_supported_database_version.md#supported-database-version)).

When we have the `SUPPORTED_DATABASE_VERSION` value, we need to provide it to the `DatabaseVersionSyncStage`.  To do that, we can add a `supportedDatabaseVersion` field to the `SyncConfig` class to store it and call the `DatabaseVersionSyncStage`s with the `SyncConfig` instance so the `SUPPORTED_DATABASE_VERSION` value is accessible.

Let's proceed to the next [section](#Getting-Database-Metadata) and consider the ways of getting the Firestore database metadata in the CI Integrations tool.

### Getting Database Metadata
> Explain the way of loading the database metadata.

The database metadata is represented by the `DatabaseMetadata` entity from the [`core` library](https://github.com/platform-platform/dashboard/tree/master/metrics/core). To be able to get the `DatabaseMetadata` we should introduce a new `fetchDatabaseMetadata` method to the `DestinationClient` and implement it in all `DestinationClient`'s subclasses. Since the `destinationClient` is available within all `SyncStage`'s subclasses, we can use it to fetch the database metadata within the `DatabaseVersionSyncStage` and perform any necessary compatibility checks.

# Making things work
> Describe the way of blocking the application from accessing the database.

Consider the class diagram below that demonstrates the main classes, and their relationships needed to introduce the `DatabaseVersionSyncStage` to the CI Integrations tool.

![Class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/dashboard/raw/ci_integrations_supported_database_version_doc/metrics/ci_integrations/docs/features/supported_database_version/diagrams/ci_integrations_supported_db_version.puml)

// TODO sequence

The code snippet below demonstrates the required compatibility checks within the `DatabaseVersionSyncStage` `call` method:

```dart
@override
Future<InteractionResult> call(SyncConfig config) async {
  final supportedDatabaseVersion = config.supportedDatabaseVersion;
  
  final databaseMetadataInteraction = await destinationClient.fetchDatabaseMetadata();
  if(databaseMetadataInteraction.isError) {
    // fail sync stage due to the database metadata fetching failed
  }
  
  final databaseMetadata = databaseMetadataInteraction.result;

  final databaseVersion = databaseMetadata.version;
  if(supportedDatabaseVersion != databaseVersion) {
    // fail sync stage due to the database version incompatibility
  }
  
  if(databaseMetadata.isUpdating) {
    // fail sync stage due to the database is updating
  }
}
```

# Dependencies

> What is the project blocked on?
>
> What will be impacted by the project?

# Testing

> How will the project be tested?

# Results

> What was the outcome of the project?
