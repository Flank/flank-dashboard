# Firebase Metrics Aggregation

## Introduction

Data aggregation is the process of gathering data and presenting it in a summarized format. The data may be gathered from multiple data sources with the intent of combining these data sources into a summary for public reporting or statistical analysis. For example, raw data can be aggregated over a given time period to provide statistics such as average, minimum, maximum, sum, and count. 

By aggregating data, it is easier to identify patterns and trends that would not be immediately visible. Quick access to information helps make better decisions and improve product services and communications.

As for the `Metrics` application - `builds per week` - is one of the examples of aggregated data. This metric illustrated a total count of performed builds by the last 7 days.

### [Aggregating data in Firestore](https://firebase.google.com/docs/firestore/solutions/aggregation)

If we want to quickly find documents in large collections, we should use Firebase advanced queries. 

Advanced queries in Cloud Firestore allow quickly find documents in large collections. If we want to gain insight into the properties of the collection as a whole (get `builds per week`, `performance`), we need an aggregation over a collection.

Cloud Firestore does not support native aggregation queries. However, we can use [Cloud Functions to easily maintain aggregate information](#aggregating-data-using-the-cloud-functions).


## Objectives of the analysis

> This section serves as a summary of the proposed analysis.

## Landscape

> Look for existing solutions in the area.

There are a few approaches to get data for the aggregated metrics:
- load all collection's documents;
- aggregate data in the Firestore Cloud Functions using transaction;
- aggregate data in the Firestore Cloud Functions using `FieldValue.increment`;

Let's take a closer look at them.

### Loading all documents

At this time, for the aggregated metric `builds per week`, we download all the builds of the project for the last 7 days using Firebase advanced query, count the number of builds, and display the information on the `Metrics` dashboard. 

Pros:
- Easy to implement.

Cons:
- With an increase in the number of builds, the number of writes/reads to/from the database grows that triggers heavy load/price implications.
- Increase time for calculating the aggregation metric.

### Aggregating data using the Cloud Functions

#### Using transactions

The transaction is a set of read and write operations on one or more documents. Transactions are useful when we want to update a field's value based on its current value, or the value of some other field.

Pros:
- In the case of a concurrent edit, the entire transaction runs again.

Cons:
- Reads a field's value before updating - it's an extra read.
- Has a maximum writes and time limits.

#### Using `FieldValue.increment` method
