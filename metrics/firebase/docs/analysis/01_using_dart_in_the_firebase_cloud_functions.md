# Using Dart in the Firebase Cloud Functions 

> Feature description / User story.

As we want to add more server-side processing to the Cloud Firestore, we should explore the possibility of writing the Cloud Functions using the Dart language.

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

The first approach is to use the [firebase-functions-interop](https://pub.dev/packages/firebase_functions_interop) package. It is a Firebase Cloud Functions SDK for Dart, written as a JS interop wrapper for official Node.js SDK.

Pros:
 - Implemented wrappers for a major part of Firebase features, such as `functions.firestore`, `functions.auth`, etc.
 - Provides interop for the `firebase.admin` package.
 - Has [good documentation](https://pub.dev/documentation/firebase_functions_interop/latest) for getting started.

Cons:
 - Not an official Firebase package.
 - Rare package updates.
 - Does not support the Firebase Remote Config and Analytics.

#### The `functions_framework` package

An open source FaaS (Function as a Service) framework for writing portable Dart functions.

Pros:
 - Actively evolves with frequent updates.

Cons:
 - Not an official Firebase package.
 - Does not have a documented way of creating Cloud Firestore functions using this framework.

#### Decision

We've considered and analyzed the described above packages and chose the `firebase-functions-interop`, as it satisfies our [goals](#feasibility-study). 

### Prototyping

> Create a simple prototype to confirm that implementing this feature is possible.

Let's consider an example of registering a new Cloud Firestore `onCreate` trigger using the `firebase-functions-interop` package: 

```dart
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
    
functions['incrementCounter'] = functions.firestore.document('/documents/{documentId}').onCreate(onCreateEventHandler);
```

Once we've registered a new `onCreate` trigger, let's review the trigger function itself. The following function increments the counter in the `aggregation/documents` document once the new document created in the `documents` collection:

```dart
function onCreateEventHandler(DocumentSnapshot snapshot, _) {
    final ref = await snapshot.firestore.collection('documents').document('documentId');
    return snapshot.firestore.runTransaction((transaction) async {
    final ref = 'aggregation/documents';
    return transaction.get(ref).then((doc) {      
      final incrementedCounter = countDoc.data.getInt('count') + 1;
      final updatedCounter = UpdateData();
      updatedCounter.setInt('count', incrementedCounter);

      transaction.update(ref, updatedCounter);
    });
  });
}
```

Using the `cloud_firestore` package we've started creating test documents in parallel using multiple clients.

As a result, our event handler is fired each time, when a new Firestore document is created and we have a counter value with the number of the documents. 
