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

To be able to detect whether the CI Integrations tool is compatible with the current database, we should modify the [`synchronization algorithm`](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md#synchronization-algorithm) to perform all necessary compatibility checks before running the `InProgressBuildsSyncStage` and the `NewBuildsSyncStage` (consider this [section](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/features/in_progress_builds/in_progress_builds_introduction.md#sync-algorithm-stages) that describes mentioned `SyncStages` more widely).

According to the above, we should introduce a new `DatabaseVersionSyncStage` that is responsible for performing the required database compatibility checks, and run it at the beginning of the project metrics synchronization. If the CI Integrations tool does not support the current database version, or the database is updating, the synchronization must fail with the informative error message describing the required steps the user needs to perform to overcome the occurred issue. #TODO: error messages section link/anchor

To sum up, the synchronization algorithm now must include the `SyncStage`s in the following order:
`DatabaseVersionSyncStage` -> `InProgressBuildsSyncStage` -> `NewBuildsSyncStage`

## DatabaseVersionSyncStage
The `DatabaseVersionSyncStage` needs the following values to be able to detect whether the CI Integrations tool is compatible with the current database:
- [Supported database version](#Supported-Database-Version) of this application;
- [Database metadata](#Database-Metadata).

Let's review the way of getting each of them separately:

### Supported Database Version
> Explain the process of getting the supported database version.

Since the CI Integrations tool is built with the `SUPPORTED_DATABASE_VERSION` environment variable (based on the [Storing Database Metadata](https://github.com/platform-platform/monorepo/blob/master/metrics/docs/01_storing_database_metadata.md#supported-database-version) document), we can get this value in the application from the environment, using the `ApplicationMetadata` class from the [core](https://github.com/platform-platform/monorepo/tree/master/metrics/core) library (as described in the following [section](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/supported_database_version/01_supported_database_version.md#supported-database-version)).

To provide the supported database version value to the `DatabaseVersionSyncStage`, we should modify the `SyncConfig` to include the `supportedDatabaseVersion` field.

### Database Metadata
> Explain the way of loading the database metadata.

# Making things work
> Describe the way of blocking the application from accessing the database.

# Dependencies

> What is the project blocked on?
>
> What will be impacted by the project?

# Testing

> How will the project be tested?

# Results

> What was the outcome of the project?
