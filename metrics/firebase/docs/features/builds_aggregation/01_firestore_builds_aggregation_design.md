# Firestore Builds Aggregation design

## Introduction

For now, to make builds aggregations we should load all builds and process calculations on the client, because Cloud Firestore does not support the aggregation queries.

This solution is okay if a project has not many builds, but over time, the number of builds growth and it will pull along increase the number of reads from the database and leads to heavy load/price implications.

To resolve the described problem, we've investigated a possibility to provide some aggregation calculations using the back-end, provided by the Firebase using the Cloud Functions. See [Firebase Metrics Aggregation](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/02_firebase_metrics_aggregation.md) document for more details.

## References

> Link to supporting documentation, GitHub tickets, etc.

- [Github epic: Reduce Firebase usage / document reads](https://github.com/platform-platform/monorepo/issues/1042)
- [Firebase aggregation](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/02_firebase_metrics_aggregation.md)
- [Firestore Cloud Function using Dart](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/01_using_dart_in_the_firebase_cloud_functions.md)

## Design

> Explain and diagram the technical design.

The Firestore builds aggregation implementation requires changes in the Firestore Database and Firestore Cloud Functions. The design describes new collections we should create and a list of security rules we should apply. There is also information about Firestore Cloud Function triggers.

### Firestore

The section contains information about the main purposes of new collections, their document structures with field descriptions, and a set of security rules.

### `build_days`

> Explain the main purpose of the collection.

The first collection we should create is the `build_days`. It holds builds grouped by the `status` and `day`. Each status contains the count of builds, created per day. 

#### Document Structure

> Explain the structure of the documents under this collection.

The collection's document has the following structure:

```json
{
  "projectId": String,
  "BuildStatus.successful": number,
  "BuildStatus.failed": number,
  "BuildStatus.unknown": number,
  "BuildStatus.inProgress": number,
  "totalDuration": number,
  "day": timestamp,
}
```

Let's take a closer look at the document's fields:

| Field | Description |
| --- | --- |
| `projectId`   | An identifier of the project, this aggregation relates to. |
| `BuildStatus.successful` | A count of builds with a `successful` status. |
| `BuildStatus.failed` | A count of builds with a `failed` status. |
| `BuildStatus.unknown` | A count of builds with an `unknown` status. |
| `BuildStatus.inProgress` | A count of builds with an `inProgress` status. |
| `totalDuration` | A total builds duration. |
| `day`   | A timestamp that represents the day start this aggregation belongs to. |

#### Security Rules

> Explain the Firestore Security Rules for this collection.

Every authenticated user can read the documents from the `build_days` collection, but no one can write to this collection. Let's consider the security rules for this collection in more details:

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **can** read and **cannot** create, update, delete this document.

### `tasks`

> Explain the main purpose of the collection.

There may be situations where creating or updating the `build_days` collection fails. If it happens, we should store the required for builds aggregation fields to the context of the specific collection - `tasks` to process this data later.

#### Document Structure

> Explain the structure of the documents under this collection.

The collection's document has the following structure:

```json
{
  "action": String,
  "context": Map,
  "createdAt": timestamp,
}
```

Let's take a closer look at the document's fields:

| Field | Description |
| --- | --- |
| `action`   | A string representation of the specific processing failure. |
| `context`   | A map, containing the required fields to complete the task. |
| `createdAt`   | A timestamp, determine when the task is created. |

The `action` should be a specific string, which contains an information about event failure. It can be a collection name and a function name, on which the processing is interrupted.

For our purposes, the following action strings we can create, related to the function trigger type, that is failed:
 - `build_days.onCreate`
 - `build_days.onUpdate`

Later, using the described above information we can fix counters inside the `build_days` collection.

#### Security Rules

> Explain the Firestore Security Rules for this collection.

No one can read from or write to this collection. Let's consider the security rules for this collection in more details:

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **cannot** read, create, update, delete this document.

### Firestore Cloud Functions

When we've created collections and applied rules for them, we should create the Firestore Cloud Functions. In addition, we can [write these functions using the Dart programming language](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/01_using_dart_in_the_firebase_cloud_functions.md).

#### onCreate trigger

> Explain the main purpose of the trigger.

If we want to provide builds aggregations, we need to process calculations in reaction to added build. For this purpose, we should create the `onCreate` function trigger on the `build` collection.

```dart
functions['onBuildAdded'] = functions.firestore
    .document('build/{buildId}')
    .onCreate(onBuildAddedHandler)


Future<void> onBuildAddedHandler(DocumentSnapshot snapshot, EventContext context) {...}
```

The trigger's `onBuildAddedHandler` handler should process incrementing logic for the `build_days` collection document, based on the created build's status and started date.

The following sequence diagram shows the overall process of how the `onCreate` triggers works:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/builds_aggregation_design/metrics/firebase/docs/features/builds_aggregation/diagrams/firestore_create_builds_aggregation_sequence_diagram.puml)

#### onUpdate trigger

> Explain the main purpose of the trigger.

The second trigger - `onUpdate`, should handle the logic to increment or decrement the builds count, related to changes in the build status. For example, if the build with an `inProgress` status changes to `successful`, we should increment `BuildStatus.successful` count of the document, and decrement the `BuildStatus.inProgress` count.

```dart
functions['onBuildUpdated'] = functions.firestore
    .document('build/{buildId}')
    .onUpdate(onBuildUpdatedHandler)

Future<void> onBuildUpdatedHandler(Change<DocumentSnapshot> change, EventContext context) {...}
```

In case, the `onCreate` or `onUpdate` trigger's handler processing failed, we should create a new document inside the `tasks` collection. Later, we can use this collection to fix the `build_days` counters.

The following sequence diagram shows the overall process of how the `onUpdate` triggers works:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/builds_aggregation_design/metrics/firebase/docs/features/builds_aggregation/diagrams/firestore_update_builds_aggregation_sequence_diagram.puml)

#### Testing

> How will the functions be tested?

The described above functions will be unit-tested using the [test](https://pub.dev/packages/test) package. To mock document snapshots we can use the [mockito](https://pub.dev/packages/mockito) package.
