# Firestore Builds Aggregation design

## Introduction

At this time, for the `builds per week` metric, we download all the builds of the project for the last 7 days using Firebase advanced query, count the number of builds, and display the information on the `Metrics` dashboard.

This solution is okay for now, with the current number of builds, but we might have cases when there are more than 1000 builds per week. This increases the number of reads from the database and leads to heavy load/price implications.

To resolve the described problem, we've investigated a [possibility to provide some aggregation calculations using the back-end, provided by the Firebase using the Cloud Functions](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/02_firebase_metrics_aggregation.md).

With that we do not need to calculate a builds count every time we load the dashboard, instead, we should have that count in a separate collection. 

The same logic we can apply to other metrics such as failed or success builds count.

## References

> Link to supporting documentation, GitHub tickets, etc.

- [Project Metrics Definitions](https://github.com/platform-platform/monorepo/blob/master/docs/05_project_metrics.md)
- [Github epic: Reduce Firebase usage / document reads](https://github.com/platform-platform/monorepo/issues/1042)
- [Firebase aggregation](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/02_firebase_metrics_aggregation.md)
- [Firestore Cloud Function using Dart](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/01_using_dart_in_the_firebase_cloud_functions.md)

## Document structure

The first collection we should create is the `builds_per_day`. It holds builds grouped by the `status` and `started at` day. Each status contains the count of builds, created per day. 

The collection's document has the following structure:

```json
{
  "projectId": String,
  "buildStatuses": {
    "BuildStatus.success": number,
    "BuildStatus.failed": number,
    "BuildStatus.unknown": number,
    "BuildStatus.in-progress": number,
  },
  "startedAt": timestamp,
}
```

| Field | Description |
| --- | --- |
| `projectId`   | An id of the project, the build is related. |
| `buildStatuses` | The map which contains BuildStatuses with the count of created builds. |
| `startedAt`   | Determines the day build is started and contains a timestamp in the UTC. |

There are situations, where creating or updating the `builds_per_day` collection fails. If it happens, we should store the build on which the counter was failed to the specific collection - `failed_builds_per_day`.

The collection's document has the following structure:

```json
{
  "projectId": String,
  "buildNumber": number,
  "action": String
}
```

| Field | Description |
| --- | --- |
| `projectId`   | An id of the project, the build is related. |
| `buildNumber` | A number of the build. |
| `action`   | The process, that is failed (e.g.g. onCreate trigger for the builds collection). |

_**Note:** The collection contains the `projectId` and `buildNumber` to uniquely identify a single build in the `build` collection._

Later, using the `projectId` and `buildNumber` we can fetch a build from the `build` collection with the latest status and update the `builds_per_day` collection.

## Firestore security rules

Once we have new collections, we have to add security rules for them.

First, the `builds_per_day` collection, everyone can read the content but no one has access to create, update or delete collection documents.

Thus, the following rules keep:

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **can** read and **cannot** create, update, delete this document.

Second, for the `failed_builds_per_day` collection - no one has access to read, create, update or delete collection documents.

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **cannot** read, create, update, delete this document.

## Firestore Cloud Functions

When we've created collections and applied rules for them, we should create the Firestore Cloud Functions. In addition, we can [write these functions using the Dart programming language](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/01_using_dart_in_the_firebase_cloud_functions.md).

If we want to provide builds aggregations, we need to process calculations in reaction to added build. For this purpose, we should create the `onCreate` function trigger on the `build` collection.

```dart
functions['onAddedBuild'] = functions.firestore
    .document('build/{buildId}')
    .onCreate(onAddedBuildHandler)


FutureOr<void> onAddedBuildHandler(DocumentSnapshot snapshot, EventContext context) {...}
```

The trigger's `onAddedBuildHandler` handler should process incrementing logic for the `builds_per_day` collection document, based on the created build's status and started date.

The second trigger - `onUpdate`, should handle the logic to increment or decrement the builds count, related to changes in the build status. For example, if the build with an `in-progress` status changes to `success`, we should increment `BuildStatus.success` count of the document, and decrement the `BuildStatus.in-progress` count.

```dart
functions['onUpdatedBuild'] = functions.firestore
    .document('build/{buildId}')
    .onUpdate(onUpdatedBuildHandler)

FutureOr<void> onUpdatedBuildHandler(Change<DocumentSnapshot> change, EventContext context) {...}
```

In case, the `onCreate` or `onUpdate` trigger's handler processing failed, we should create a new document inside the `failed_builds_per_day` collection. Later, we can use this collection to fix the `builds_per_day` counters.
