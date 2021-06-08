# Firestore Builds Aggregation
> Feature description / User story.

Data aggregation is the process of gathering data and presenting it in a summarized format. The data may be gathered from multiple data sources with the intent of combining these data sources into a summary for public reporting or statistical analysis. For example, raw data can be aggregated over a given period to provide statistics such as average, minimum, maximum, sum, and count. 

By aggregating data, it is easier to identify patterns and trends that would not be immediately visible. Quick access to information helps make better decisions and improve product services and communications.

As for the `Metrics` application - [builds per week](https://github.com/Flank/flank-dashboard/blob/master/docs/05_project_metrics.md#builds-metric) - is one of the examples of aggregated data. This metric illustrates a total count of performed builds by the last 7 days.

The same aggregation definition we can apply to Firebase aggregations.

## Contents

- [**References**](#references)
- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
      - [Loading all documents](#loading-all-documents)
      - [Aggregating data using the Cloud Functions](#aggregating-data-using-the-cloud-functions)
        - [Firebase transactions](#firebase-transactions)
        - [FieldValue.increment](#fieldvalueincrement)
        - [Distributed counter](#distributed-counter)
      - [Decision](#decision)   
- [**Design**](#design)
    - [Database](#database)
      - [build_days](#build_days)
        - [Document Structure](#document-structure)
        - [Security Rules](#security-rules)
      - [tasks](#tasks)
        - [Document Structure](#document-structure-1)
        - [Security Rules](#security-rules-1)
    - [Program](#program)
      - [onBuildAdded](#onBuildAdded)
      - [onBuildUpdated](#onBuildUpdated)
      - [Testing](#Testing)

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Github epic: Reduce Firebase usage / document reads](https://github.com/Flank/flank-dashboard/issues/1042)
- [Firestore Cloud Function using Dart](https://github.com/Flank/flank-dashboard/blob/concatenate_document_sections/metrics/firebase/docs/features/dart_cloud_functions/01_using_dart_in_the_firebase_cloud_functions.md)

# Analysis
> Describe a general analysis approach.

During the analysis stage, we should understand a [feasibility](#feasibility-study) to implement the `builds aggregation` to reduce Firebase usage. For this purpose, we should investigated a possibility to provide some aggregation calculations using the back-end, provided by the Firebase using the Cloud Functions.

Based on the analysis, we should make a decision about an optimal approach that satisfies the [requirements](#requirements) for the Firestore builds aggregation.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

If we want to quickly find documents in large collections, we should use Firebase advanced queries. If we want to gain insight into the properties of the collection as a whole (e.g., builds per week), we need an aggregation over a collection. Unfortunately, Cloud Firestore does not support native aggregation queries. So, we should implement this calculation because of the Firestore limitations.

For now, to make builds aggregations we should load all builds and process calculations on the client, because Cloud Firestore does not support the aggregation queries.

This solution is okay if a project has not many builds, but over time, the number of builds growth and it will pull along increase the number of reads from the database and leads to heavy load/price implications.

### Requirements
> Define requirements and make sure that they are complete.

The `Firestore builds aggregation` feature should meet the following requirements: 

- Reduces Firestore usage.
- Processes aggregation calculations.
- Works correctly in case of concurrent document edits.

### Landscape
> Look for existing solutions in the area.

There are a few approaches to get data for the aggregated metrics:
- Load all collection's documents and provide aggregation using the client.
- Aggregate data in the Firestore Cloud Functions using:
  - `transaction`;
  - `FieldValue.increment`;
  - `distributed counter`.

Let's take a closer look at them.

#### Loading all documents

At this time, for the aggregated metric `builds per week`, we download all the builds of the project for the last 7 days using Firebase advanced query, count the number of builds, and display the information on the `Metrics` dashboard.

Pros:
- Easy to implement.

Cons:
- With an increase in the number of builds, the number of reads from the database grows respectively. It leads to heavy load/price implications.
- Increases the time of calculating the aggregation metric.

#### Aggregating data using the Cloud Functions

With Cloud Functions, we can move our aggregation logic to the cloud and process calculations on the back-end, provided by Firebase.

There are several ways, we can use the aggregation with the Cloud Functions - using the [Firebase transactions](#firebase-transactions), the [FieldValue.increment](#fieldvalueincrement) method or create a [Distributed counter](#distributed-counter).

#### Firebase transactions

The transaction is a set of read and write operations on one or more documents. Transactions are useful when we want to update a field's value based on its current value, or the value of some other field.

Pros:
- Code runs in the cloud, so the client is less loaded.
- In the case of a concurrent edit, the entire transaction runs again.

Cons:
- There is a maximum count of transaction reruns, that's why some transactions may fail.
- An extra read a field's value before updating.
- Has a maximum writes and time [limits](https://firebase.google.com/docs/firestore/quotas#writes_and_transactions).
- Requires a lot of code to implement a simple logic (e.g., counters).

#### FieldValue.increment

The [FieldValue.increment](https://firebase.google.com/docs/reference/js/firebase.firestore.FieldValue#static-increment) method gives the ability to increment (or decrement) numeric values directly in the database.

Keep in mind, that documents are still limited to a [sustained write limit](https://firebase.google.com/docs/firestore/quotas#soft_limits). Although it has limits for document writes to 1 per second as a default soft limit, we can increase this number to 500 by creating the [indexed field](https://firebase.google.com/docs/firestore/query-data/indexing).

Pros:
- Easy to implement.
- Requires less code to implement compared to transactions.
- Provide a solution to prevent concurrent edit problem.

Cons:
- Limited by the document's write limit.

#### Distributed counter

As we've described above, the [FieldValue.increment](#fieldvalueincrement) method has a limitation to one write per second per document. If we have a more frequent counter updates, we should create a distributed counter.

It is a document with a subcollection of "shards", and the value of the counter is the sum of the value of the shards. 

To increment the counter, choose a random "shard" and increment the count. To get the total count, query for all "shards" and sum their count fields.

With that, we can increase our write document limit to the count of "shards" (e.g., if we have 50 shards, that means 50x more writes compare with the simple increment method).

There are certain disadvantages of this approach. With too few shards, some transactions may have to retry before succeeding, which will slow writes. With too many shards, reads become slower and more expensive. Also, as we have a subcollection of "shards" that we must load, so the cost of reading a counter value increases.

Pros:
- Provides an ability to increase the document write limit.

Cons:
- The number of shards controls the performance of the distributed counter.
- The cost of reading a counter value increases linearly with the number of shards.
- Requires a lot of code to implement.

#### Decision

Using the "transaction approach", reads are required - thus producing more load/billing than [FieldValue.increment](#fieldvalueincrement). 

The [Distributed counter](#distributed-counter) is designed for the heavier load than we currently estimate and could be a good scaling approach if something changes.

Considering all pros and cons [FieldValue.increment](#fieldvalueincrement) seems to be a great approach to start with aggregations due to the absence of reads for increments and providing sufficient limits for writes.

# Design
> Explain and diagram the technical design.

The Firestore builds aggregation implementation requires changes in the Firestore Database and Firestore Cloud Functions. The design describes new collections we should create and a list of security rules we should apply. There is also information about Firestore Cloud Function triggers.

### Database
> How relevant data will be persisted.

The section contains information about the main purposes of new collections, their document structures with field descriptions, and a set of security rules.

#### `build_days`
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

#### `tasks`
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

### Program
> Detailed solution description to class/method level.

When we've created collections and applied rules for them, we should create the Firestore Cloud Functions. See [Cloud Functions using Dart](https://github.com/Flank/flank-dashboard/blob/concatenate_document_sections/metrics/firebase/docs/features/dart_cloud_functions/01_using_dart_in_the_firebase_cloud_functions.md) for more info on how to create Cloud Functions using the Dart programming language.

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

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/firebase/docs/features/builds_aggregation/diagrams/firestore_create_builds_aggregation_sequence_diagram.puml)

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

![Sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/firebase/docs/features/builds_aggregation/diagrams/firestore_update_builds_aggregation_sequence_diagram.puml)

#### Testing
> How will the functions be tested?

The described above functions we will test using the [test](https://pub.dev/packages/test) package, and perform unit-testing the functions' event handlers.

The `onCreate` handler takes two arguments - `DocumentSnapshot` and `EventContext`. As we don't want to reference the real instance of Firestore, we need to mock the `DocumentSnapshot` using the [mockito](https://pub.dev/packages/mockito) package. This gives us a possibility to emulate a Firestore and return specific results depending on the test. Also, we should mock the `EventContext` and pass that instance as the second parameter to the handler.

The `onUpdate` event handler, has a similar second argument, but the first one is a `Change`. As it has two states: after the update event and prior to the event, we should create an instance of `Change` class using the mocked `DocumentSnapshot`s and pass it as the first argument to the handler.

As our functions process some actions (creating documents or updating existing ones) using the Firestore instance from the `DocumentSnapshot` through `documentSnapshot.firestore`, we can use our mocked instance to override this call and replace it with our created mock. This gives us the ability to verify that the functions actually write or updates documents.
