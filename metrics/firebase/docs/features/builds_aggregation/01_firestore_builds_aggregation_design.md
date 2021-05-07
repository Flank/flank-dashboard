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

We should produce a composite document identifier that consists of a project's id and a day (represented as milliseconds since the epoch in a UTC) this aggregation document belongs to. We can use this identifier to easily update a value of the `build_days` document.

So, the identifier of the document can looks like the following: `projectId_1618790400`.

The collection's document has the following structure:

```json
{
  "projectId": String,
  "successful": number,
  "failed": number,
  "unknown": number,
  "inProgress": number,
  "successfulBuildsDuration": number,
  "day": timestamp,
}
```

Let's take a closer look at the document's fields:

| Field | Description |
| --- | --- |
| `projectId`   | An identifier of the project, this aggregation relates to. |
| `successful` | A count of builds with a `successful` status. |
| `failed` | A count of builds with a `failed` status. |
| `unknown` | A count of builds with an `unknown` status. |
| `inProgress` | A count of builds with an `inProgress` status. |
| `successfulBuildsDuration` | A total duration of successful builds. |
| `day`   | A timestamp that represents the day start this aggregation belongs to. |

#### Security Rules

> Explain the Firestore Security Rules for this collection.

Every authenticated user can read the documents from the `build_days` collection, but no one can write to this collection. Let's consider the security rules for this collection in more details:

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **can** read;
  - authenticated users **cannot** create, update, delete this document.

### `tasks`

> Explain the main purpose of the collection.

The collection stands for a list of delayed jobs and lets you separate out pieces of work that can be performed independently, outside of your main application flow. The collection's fields contain all required information for each job to perform required actions.

#### Document Structure

> Explain the structure of the documents under this collection.

The collection's document has the following structure:

```json
{
  "code": String,
  "data": Map,
  "context": String,
  "createdAt": timestamp,
}
```

Let's take a closer look at the document's fields:

| Field | Description |
| --- | --- |
| `code`   | A string that identifies the task to perform. |
| `data`   | A map, containing the data needed to run the task with the specified `code`. |
| `context`   | A string, containing the additional context for this task. |
| `createdAt`   | A timestamp, determine when this task is created. |

For our purposes, the following code strings we can create, related to the function trigger type, that is failed:
 - `build_day_created`
 - `build_day_updated`

Later, using the described above information we can fix counters inside the `build_days` collection.

#### Security Rules

> Explain the Firestore Security Rules for this collection.

No one can read from or write to this collection. Let's consider the security rules for this collection in more details:

- Access-related rules:
  - not authenticated users **cannot** read, create, update, delete this document;
  - authenticated users **cannot** read, create, update, delete this document.

### Firestore Cloud Functions

When we've created collections and applied rules for them, we should create the Firestore Cloud Functions. See [Cloud Functions using Dart](https://github.com/platform-platform/monorepo/blob/master/metrics/firebase/docs/analysis/01_using_dart_in_the_firebase_cloud_functions.md) for more info on how to create Cloud Functions using the Dart programming language.

Let's review each Cloud Function we need for this feature separately: 

#### onBuildAdded

> Explain the main purpose of the trigger.

If we want to provide builds aggregations, we need to process calculations in reaction to added build. For this purpose, we should create the `onCreate` function trigger on the `build` collection.

```dart
functions['onBuildAdded'] = functions.firestore
    .document('build/{buildId}')
    .onCreate(onBuildAddedHandler);


Future<void> onBuildAddedHandler(DocumentSnapshot snapshot, EventContext context) {...}
```

The trigger's `onBuildAddedHandler` handler should process incrementing logic for the `build_days` collection document, based on the created build's status and started date.

_**Note**: A `successfulBuildsDuration` value should be incremented only if status of created build is `successful`._

The following sequence diagram shows the overall process of how the `onBuildAdded` triggers works:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/metrics/firebase/docs/features/builds_aggregation/diagrams/firestore_create_builds_aggregation_sequence_diagram.puml)

#### onBuildUpdated

> Explain the main purpose of the trigger.

The second trigger - `onUpdate`, should handle the logic to increment or decrement the builds count, related to changes in the build status. Also, it should increment the `successfulBuildsDuration` value if a new build status is `successful`. For example, if the build with an `inProgress` status changes to `successful`, we should increment `successful` count of the document, decrement the `inProgress` count and increment the `successfulBuildsDuration`. 

```dart
functions['onBuildUpdated'] = functions.firestore
    .document('build/{buildId}')
    .onUpdate(onBuildUpdatedHandler);

Future<void> onBuildUpdatedHandler(Change<DocumentSnapshot> change, EventContext context) {...}
```

In case, the `onCreate` or `onUpdate` trigger's handler processing failed, we should create a new document inside the `tasks` collection. Later, we can use this collection to fix the `build_days` counters.

The following sequence diagram shows the overall process of how the `onBuildUpdated` triggers works:

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/metrics/firebase/docs/features/builds_aggregation/diagrams/firestore_update_builds_aggregation_sequence_diagram.puml)

#### Testing

> How will the functions be tested?

The described above functions we will test using the [test](https://pub.dev/packages/test) package, and perform unit-testing the functions' event handlers.

The `onCreate` handler takes two arguments - `DocumentSnapshot` and `EventContext`. As we don't want to reference the real instance of Firestore, we need to mock the `DocumentSnapshot` using the [mockito](https://pub.dev/packages/mockito) package. This gives us a possibility to emulate a Firestore and return specific results depending on the test. Also, we should mock the `EventContext` and pass that instance as the second parameter to the handler.

The `onUpdate` event handler, has a similar second argument, but the first one is a `Change`. As it has two states: after the update event and prior to the event, we should create an instance of `Change` class using the mocked `DocumentSnapshot`s and pass it as the first argument to the handler.

As our functions process some actions (creating documents or updating existing ones) using the Firestore instance from the `DocumentSnapshot` through `documentSnapshot.firestore`, we can use our mocked instance to override this call and replace it with our created mock. This gives us the ability to verify that the functions actually write or updates documents.
