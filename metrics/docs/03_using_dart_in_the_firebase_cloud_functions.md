# Using Dart in the Firebase Cloud Functions 

> Feature description / User story.

As we want to reduce usage/document reads we should explore possibilities to add more server-side processing for metrics calculations and use Dart language for it.

# Analysis

> Describe general analysis approach.

To implement this feature, we've investigated the possibility of using the [Cloud Functions for Firebase](https://firebase.google.com/docs/functions). The special type of Cloud Functions is [Cloud Firestore Function triggers](https://firebase.google.com/docs/functions/firestore-events#function_triggers) that allow creating handlers tied to specific Cloud Firestore events.

For this purposes, we have explored the following packages:
 - [firebase-functions-interop](https://pub.dev/packages/firebase_functions_interop)
 - [functions_framework](https://pub.dev/packages/functions_framework)

### Feasibility study

> A preliminary study of the feasibility of implementing this feature.

Using Firebase Cloud Functions for metrics calculations opens the possibility to reduce usage and document reads.

Also, it allows us to write Cloud Functions using Dart programming language.

### Landscape

> Look for existing solutions in the area.

#### The `firebase-functions-interop` package

The first solution is to use the [firebase-functions-interop](https://pub.dev/packages/firebase_functions_interop) package. It is a Firebase Cloud Functions SDK for Dart, written as a JS interop wrapper for official Node.js SDK.

Pros:
 - Implemented wrappers for a major part of Firebase features, such as `functions.firestore`, `functions.auth`, etc.
 - Has good documentation for getting started.

Cons:
 - Not an official Firebase package.
 - Rare package updates.
 - No functionality for the Firebase Remote Config and Analytics.

#### The `functions_framework` package

An open source FaaS (Function as a Service) framework for writing portable Dart functions.

Pros:
 - Active evolve with frequent updates.

Cons:
 - Not an official Firebase package.
 - Undocumented way of interaction with the Cloud Firestore functions.

#### Decision

We've considered and analyzed the described above packages and chose the `firebase-functions-interop`, as it satisfies our [goals](#feasibility-study). 

### Prototyping

> Create a simple prototype to confirm that implementing this feature is possible.

To test that the package is working we've registered a Firestore trigger using the `onCreate` method provided by the `firebase-functions-interop` package that fires every time new data is created in the Cloud Firestore specified collection.

```dart
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
    
functions['ourCloudFunctionName'] = functions.firestore.document('/collection/{documentId}').onCreate(onCreateEventHandler);
```

As the `onCreate` handler, we've registered a `onCreateEventHandler` function, that increments a counter value in the different Firestore collection of the created documents, using the Firestore transaction.

```dart
function onCreateEventHandler(DocumentSnapshot snapshot, _) {
    final ref = await snapshot.firestore.collection('collection').document('documentId');

  return snapshot.firestore.runTransaction((transaction) async {
    return transaction.get(ref).then((doc) {
      
      ... // get and increment counter

      transaction.update(ref, updatedCounter);
    });
  });
}
```

Using the `cloud_firestore` package we've started creating test documents in parallel using multiple clients.

As a result, our event handler is fired each time, when a new Firestore document is created and we have a counter value with the number of the documents. 

