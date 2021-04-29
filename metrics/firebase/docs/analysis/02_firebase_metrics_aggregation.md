# Firebase Metrics Aggregation

## Introduction

Data aggregation is the process of gathering data and presenting it in a summarized format. The data may be gathered from multiple data sources with the intent of combining these data sources into a summary for public reporting or statistical analysis. For example, raw data can be aggregated over a given period to provide statistics such as average, minimum, maximum, sum, and count. 

By aggregating data, it is easier to identify patterns and trends that would not be immediately visible. Quick access to information helps make better decisions and improve product services and communications.

As for the `Metrics` application - [builds per week](https://github.com/platform-platform/monorepo/blob/master/docs/05_project_metrics.md#builds-metric) - is one of the examples of aggregated data. This metric illustrated a total count of performed builds by the last 7 days.

The same aggregation definition we can apply to Firebase aggregations.

### Aggregating data in Firestore

If we want to quickly find documents in large collections, we should use Firebase advanced queries. Advanced queries in Cloud Firestore allow quickly find documents in large collections. If we want to gain insight into the properties of the collection as a whole (e.g.g. builds per week), we need an aggregation over a collection. Unfortunately, Cloud Firestore does not support native aggregation queries. So, we should implement this calculation somehow, because of the Firestore limitations.

## Objectives of the analysis

> This section serves as a summary of the proposed analysis.

As Cloud Firestore does not support the aggregation queries we need to analyze existing approaches to provide metrics calculations. Each solution, must be described with theirs pros and cons.

The last section, [Decision](#decision), holds a summary of the analysis and the approach we've chosen.

## Landscape

> Look for existing solutions in the area.

There are a few approaches to get data for the aggregated metrics:
- Load all collection's documents and provide aggregation using the client.
- Aggregate data in the Firestore Cloud Functions using:
  - `transaction`;
  - `FieldValue.increment`;
  - `distributed counter`.

Let's take a closer look at them.

### Loading all documents

At this time, for the aggregated metric `builds per week`, we download all the builds of the project for the last 7 days using Firebase advanced query, count the number of builds, and display the information on the `Metrics` dashboard.

Pros:
- Easy to implement.

Cons:
- With an increase in the number of builds, the number of reads from the database grows respectively. It leads to heavy load/price implications.
- Increases the time of calculating the aggregation metric.

### Aggregating data using the Cloud Functions

With Cloud Functions, we can move our aggregation logic to the cloud and process calculations on the back-end, provided by Firebase.

There are several ways, we can use the aggregation with the Cloud Functions - using the [Firebase transactions](#firebase-transactions), the [FieldValue.increment](#fieldValue.increment) method or create a [Distributed counter](#distributed-counter).

#### Firebase transactions

The transaction is a set of read and write operations on one or more documents. Transactions are useful when we want to update a field's value based on its current value, or the value of some other field.

Pros:
- Code runs in the cloud, so the client is less loaded.
- In the case of a concurrent edit, the entire transaction runs again.

Cons:
- There is a maximum count of transaction reruns, that's why some transactions may fail.
- An extra read a field's value before updating.
- Has a maximum writes and time [limits](https://firebase.google.com/docs/firestore/quotas#writes_and_transactions).
- Requires a lot of code to implement a simple logic(e.g.g. counters).

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

As we've described above, the [FieldValue.increment](#FieldValue.increment) method has a limitation to one write per second per document. If we have a more frequent counter updates, we should create a distributed counter.

It is a document with a subcollection of "shards", and the value of the counter is the sum of the value of the shards. 

To increment the counter, choose a random "shard" and increment the count. To get the total count, query for all "shards" and sum their count fields.

With that, we can increase our write document limit to the count of "shards"(e.g.g if we have 50 shards, that means 50x more writes compare with the simple increment method).

There are certain disadvantages of this approach. With too few shards, some transactions may have to retry before succeeding, which will slow writes. With too many shards, reads become slower and more expensive. Also, as we have a subcollection of "shards" that we must load, so the cost of reading a counter value increases.

Pros:
- Provides an ability to increase the document write limit.

Cons:
- The number of shards controls the performance of the distributed counter.
- The cost of reading a counter value increases linearly with the number of shards.
- Requires a lot of code to implement.

## Decision

Using the "transaction approach", reads are required - thus producing more load/billing than [FieldValue.increment](#FieldValue.increment). 

The [Distributed counter](#distributed-counter) is designed for the heavier load than we currently estimate and could be a good scaling approach if something changes.

Considering all pros and cons [FieldValue.increment](#FieldValue.increment) seems to be a great approach to start with aggregations due to the absence of reads for increments and providing sufficient limits for writes.
