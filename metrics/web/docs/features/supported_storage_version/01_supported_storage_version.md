# Metrics Web Supported Storage Version
> Summary of the proposed change

Have the supported storage version in the Metrics Web Application to block the application during the storage updates or when the Metrics Web application does not support the current storage version.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Storing storage metadata](https://github.com/platform-platform/monorepo/blob/ci_integrations_supported_database_version_doc/metrics/docs/01_storing_storage_metadata.md)

# Motivation
> What problem is this project solving?

Notify the users about the application update is in progress, or the application version is not compatible with the storage version.

# Goals

> Identify success metrics and measurable goals.

This document has the following goals: 

- Describe the process of getting the supported storage version.
- Describe the way of loading the current storage metadata.
- Explain the process of blocking the application during storage updates or when it does not support the current storage version.

# Non-Goals

> Identify what's not in scope.

This document does not describe the way of storing the storage and supported storage versions. See [Storing Storage Metadata](https://github.com/platform-platform/monorepo/blob/ci_integrations_supported_database_version_doc/metrics/docs/01_storing_storage_metadata.md) document to get more info about these details.

# Design

> Explain and diagram the technical design
>
> Identify risks and edge cases

To be able to detect whether the application is compatible with the current storage version, we should get the following values: 

- [Supported storage version](#Supported-Storage-Version) of this application
- [Storage metadata](#Storage-Metadata)

Let's review the way of getting each of them separately: 

## Supported Storage Version
> Explain the process of getting the supported storage version.


Since the Metrics Web Application built with the `SUPPORTED_STORAGE_VERSION` environment variable (based on the [Storing Storage Metadata](https://github.com/platform-platform/monorepo/blob/ci_integrations_supported_database_version_doc/metrics/docs/01_storing_storage_metadata.md#supported-storage-version) document), we can get this value in the application from the environment with the following code: 

`String.fromEnvironment('SUPPORTED_STORAGE_VERSION')`

The way of fetching this value is common for all Metrics applications, so we should place the class responsible for retrieving this value to the `core` library to reuse it across the Metrics applications. So let's name it `ApplicationMetadata` and place this class under the `util` package in the [core](https://github.com/platform-platform/monorepo/tree/master/metrics/core) library.

## Storage Metadata
> Explain the way of loading the storage metadata.

Also, to detect whether the current application is compatible with the storage, we should load the storage metadata from the Firestore database. To do so, we should implement the following application layers: 

### Domain Layer
> Explain the structure of the metadata domain layer.

To load the storage version, we should use a `StorageMetadata` entity from the [core](https://github.com/platform-platform/monorepo/tree/master/metrics/core) library. Also, we should have a `StorageMetadataRepository` interface to load the data from the remote. To be able to interact with the domain layer from the presentation layer, we should create a `ReceiveStorageMetadataUpdates` use case. 

Let's review domain layer classes and their relationships on the class diagram below: 

![Storage Metadata Domain Layer](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/ci_integrations_supported_database_version_doc/metrics/web/docs/features/supported_storage_version/diagrams/metadata_domain_class_diagram.puml)

### Data Layer
> Explain the structure of the metadata data layer.

To load the data from the Firestore database, we should implement a `StorageMetadataRepository` and create a `StorageMetadataData` data model class used to map the JSON-encodable objects to the `StorageMetadata` entity and back.

Let's consider the class diagram of the data layer: 

![Storage Metadata Data Layer](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/ci_integrations_supported_database_version_doc/metrics/web/docs/features/supported_storage_version/diagrams/metadata_data_class_diagram.puml)

### Presentation Layer
> Explain the structure of the metadata presentation layer.

Once we have domain and data layers, we should implement the `MetadataNotifier` to block the application once the storage version is not supported or the storage is updating. Also, we should implement the `ApplicationUpdatingPage` and `ApplicationIsOutdatedPage` pages to notify users about the storage currently cannot handle any requests. Since `ApplicationUpdatingPage` and `ApplicationIsOutdatedPage` pages are pretty similar for now, we should create a common widget that will contain the common part (literally everything except displayed text) for these pages.

Let's examine the following class diagram that displays the main classes of the presentation layer: 

![Storage Metadata Presentation Layer](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/ci_integrations_supported_database_version_doc/metrics/web/docs/features/supported_storage_version/diagrams/metadata_presentation_class_diagram.puml)

# Making things work
> Describe the way of blocking the application from accessing the storage. 

Once we have a `domain`, `data`, and `presentation` layers ready, we can make these things work with other components of the Metrics Web Application. 

To block the application when it is not compatible with the storage version, we should connect the `MetadataNotifier` with the `NavigationNotifier` to navigate to the specific pages when the application is not available, and the `AuthNotifier` to log out a user once the application becomes unavailable. 

To do so, we should add a listener to the `MetadataNotifier` in the `InjectionContainer` widget so that should log out a user from the app and notify the `NavigationNotifier` about the application become unavailable.

Let's consider the following sequence diagram explaining this process: 

![Storage Metadata Sequence](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/ci_integrations_supported_database_version_doc/metrics/web/docs/features/supported_storage_version/diagrams/metadata_sequence_diagram.puml)

Also, we should modify the application initialization process to wait until the storage version got loaded before making the application available for users. So, we should subscribe to the MetadataNotifier changes on the LoadingPage to detect whether the application finished initializing.

Another thing we should do is refresh the application page once the storage finishes updating. To do so, we should add a `refresh` method to the `NavigationState` interface that will force the browser to refresh the application page. Let's consider the following sequence diagram explaining this process: 

![Storage Finished Updating Sequence](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/ci_integrations_supported_database_version_doc/metrics/web/docs/features/supported_storage_version/diagrams/storage_finished_updating_sequence_diagram.puml)

# Dependencies

> What is the project blocked on?

> What will be impacted by the project?

This project will impact the process of initializing the Metrics Web Application.

# Testing

> How will the project be tested?

This project will be tested using the unit, widget, and integration tests.

# Results

> What was the outcome of the project?

This document described the process of getting the storage and supported storage versions. Also, it explains the way of blocking the Metrics Web Application to avoid changing the storage during its updates.
