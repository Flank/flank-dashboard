# Builds aggregation design

## Introduction

At this time, for the builds per week metric, we download all the builds of the project for the last 7 days using Firebase advanced query, count the number of builds, and display the information on the Metrics dashboard.

This solution is okay for now, with the current number of builds, but we might have cases when there are more than 1000 builds per week. This increases the number of reads from the database and leads to heavy load/price implications.

To resolve the described problem, we've investigated a [possibility to provide some aggregation calculations using the back-end, provided by the Firebase using the Cloud Functions](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/02_firebase_metrics_aggregation.md).

With that we should not need to calculate a builds count every time we load the dashboard. Instead, we should have that count in a separate collection and can just read that value without additional processing on the client.

This document lists steps and designs the `Builds Aggregations` feature to introduce in the Metrics Web Application.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [Project Metrics Definitions](https://github.com/platform-platform/monorepo/blob/master/docs/05_project_metrics.md)
- [Github epic: Reduce Firebase usage / document reads](https://github.com/platform-platform/monorepo/issues/1042)
- [Firebase aggregation](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/02_firebase_metrics_aggregation.md)
- [Firestore Cloud Function using Dart](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/01_using_dart_in_the_firebase_cloud_functions.md)

## Firestore

### Document structure

The first collection, we should create is the `builds_aggregations`. It holds builds with their counters, grouped by the status and started at. It has the following structure:

```json
{
  "projectId": String,
  "buildId": String,
  "buildStatus": String,
  "startedAt": timestamp,
  "count": int
}
```

The `projectId` field is the id of the project, the build is related.

The `buildStatus` is the status of the created build.

The `startedAt` field determines the day build is started and contains a timestamp in the UTC.

The `count` field holds a total count of builds, with the specific `buildStatus` in the specific `startedAt` day.

There are situations, where updating the `build_aggregations` fails. If it happens, we should store the build on which the counter was failed to the specific collection - `failed_build_aggregations`.

The collection has the following structure:

```json
{
  "buildId": String,
  "action": String
}
```

The `buildId` is a unique identifier of the build.

The `action` contains the process, that is failed(e.g.g. onCreate trigger for the builds collection).

### Firestore security rules

Once we have a new collections, we have to add security rules for them.

First, the `build_aggregations` collection, everyone can read the content but no one has access to create, update or delete collection documents.

Thus, the following rules keep:

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **can** read and **cannot** create, update, delete this document.

Second, for the `failed_build_aggregations` collection - no one has access to read, create, update or delete collection documents.

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **cannot** read, create, update, delete this document.

### Firestore Cloud Functions

When we've created collections and applied rules for them, we should create the Firestore Cloud Functions. In addition we can [write this functions using the Dart programming language](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/01_using_dart_in_the_firebase_cloud_functions.md).

To react for adding new builds we should create the `onCreate` function trigger.

```dart
functions['onAddedBuild'] = functions.firestore
    .document('build/{buildId}')
    .onCreate(onAddedBuildHandler)


FutureOr<void> onAddedBuildHandler(Change<DocumentSnapshot> change, EventContext context) {...}
```

The trigger's `onAddedBuildHandler` handler should process incrementing logic for the `build_aggregations` collection, based on the created build's status and started date.

The second trigger - `onUpdate`, should handle the logic to increment or decrement the build count, related to the changes in the build status. For example, if the build with an in-progress status changes to success, we should increment counter of the document, which holds the builds with the success status and decrement the in-progress build count.

```dart
functions['onUpdatedBuild'] = functions.firestore
    .document('build/{buildId}')
    .onUpdate(onUpdatedBuildHandler)


FutureOr<void> onAddedBuildHandler(Change<DocumentSnapshot> change, EventContext context) {...}
```

## Metrics application

The following sub-sections provide an implementation of Build aggregation integration for the Metrics Web Application by layers. Read more about layers and their responsibilities in the Metrics Web Application architecture document.

### Data layer

First, the data layer provides the `FirestoreBuildsAggregationRepository` implementation of `BuildsAggregationRepository` and `BuildsAggregationData` model that represents a `DataModel` implementation for the `BuildsAggregation`.

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/builds_aggregation_design/metrics/web/docs/features/builds_aggregation/diagrams/builds_aggregation_data_layer_class_diagram.puml)

Second, for the `failed_builds_aggregations` data layer provides the `FirestoreFailedBuildsAggregationRepository` implementation of `FailedBuildsAggregationRepository` and `FailedBuildsAggregationData` model that represents a `DataModel` implementation for the `FailedBuildsAggregation` entity.

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/builds_aggregation_design/metrics/web/docs/features/builds_aggregation/diagrams/failed_builds_aggregation_data_layer_class_diagram.puml)

### Domain layer

The domain layer should provide an interface for the `FirestoreBuildsAggregationRepository` we need to interact with the `Firestore database`. Also, the layer provides all the use cases required to interact with the repository, and entities required for the `Builds Aggregation` feature. Thus, the following list of classes should be implemented to fit the feature requirements:

- Implement the `BuildsAggregationRepository` interface with appropriate methods.
- Add the `BuildsAggregation` entity with fields that come from a remote API.
- Add the `FetchBuildsAggregationUseCase` to perform fetching the aggregations.

The following class diagram demonstrates the domain layer structure:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/web/docs/features/feature_config/diagrams/builds_aggregation_domain_layer_class_diagram.puml)

### Presentation layer
