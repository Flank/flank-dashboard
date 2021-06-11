# Using Dart in the Firebase Cloud Functions 
> Feature description / User story.

As we want to add more server-side processing to the Cloud Firestore, we should explore the possibility of writing the Cloud Functions using the Dart language.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
      - [The firebase-functions-interop package](#the-firebase-functions-interop-package)
      - [The functions_framework package](#the-functions_framework-package)
      - [Decision](#decision)
    - [Prototyping](#prototyping)
      - [Cloud Function creation](#cloud-function-creation)
      - [Cloud Function deployment](#cloud-function-deployment)

# Analysis
> Describe general analysis approach.

During the analysis stage, we are going to investigate the packages providing an ability to write Cloud Functions using the Dart programming language and chose the most suitable one for us. Also, we'll provide a simple example explaining the way of creating a Cloud Function using the Dart lang and deploying it to the Firebase. 

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the `Dart` code could be compiled to the `JavaScript` code, we are able to write a Cloud Functions using `Dart`. Another problem we are facing is the Dart package providing an API for writing the Cloud Functions. There are few packages providing this functionality: 

 - [firebase-functions-interop](https://pub.dev/packages/firebase_functions_interop)
 - [functions_framework](https://pub.dev/packages/functions_framework)

### Requirements
> Define requirements and make sure that they are complete.

The chosen approach must satisfy the following requirements:

1. Possibility to create Cloud Functions for Firebase.
2. Allows using the Admin SDK to manipulate the Firestore data.
3. Provides an ability to write Cloud Functions using Dart.

### Landscape
> Look for existing solutions in the area.

At this time, there are only a few packages, that allow writing Cloud Functions using the Dart language. All of them are in the early development stage, which means not all features are ready to use or provided.

The packages, presented below are a limited set, that meets our requirements.  

#### The `firebase-functions-interop` package

The first approach is to use the [firebase-functions-interop](https://pub.dev/packages/firebase_functions_interop) package. It is a Firebase Cloud Functions SDK for Dart, written as a JS interop wrapper for official Node.js SDK.

As a dependency, it uses the [firebase-admin-interop](https://github.com/pulyaevskiy/firebase-admin-interop), which provides a set of methods to interact with the Firestore. 

Pros:
 - Implemented wrappers for a major part of Firebase features, such as `functions.firestore`, `functions.auth`, etc.
 - Has [good documentation](https://pub.dev/documentation/firebase_functions_interop/latest) for getting started.

Cons:
 - Not an official Firebase package.
 - Rare package updates.
 - Does not support the Firebase Remote Config and Analytics.

#### The `functions_framework` package

An open-source FaaS (Function as a Service) framework for writing portable Dart functions.

Pros:
 - Actively evolves with frequent updates.

Cons:
 - Not an official Firebase package.
 - Does not have a documented way of creating Cloud Firestore functions using this framework.

#### Decision

We've considered and analyzed the described above packages and chose the `firebase-functions-interop`, as it satisfies our [requirements](#requirements).

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

There are two steps that need to be done to implement the feature - [create](#cloud-function-creation) and [deploy](#cloud-function-deployment) the Cloud Function.

#### Cloud Function creation

Let's consider an example of registering a new Cloud Firestore `onCreate` trigger using the `firebase-functions-interop` package: 

```dart
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
    
functions['incrementCounter'] = functions.firestore.document('/documents/{documentId}').onCreate(onCreateEventHandler);
```

Once we've registered a new `onCreate` trigger, let's review the trigger function itself. The following function increments the counter in the `aggregation/documents` document once the new document created in the `documents` collection:

```dart
function onCreateEventHandler(DocumentSnapshot snapshot, _) {
  final ref = await snapshot.firestore.collection('aggregation').document('documents');

  return snapshot.firestore.runTransaction((transaction) async {

    return transaction.get(ref).then((doc) {      
      final incrementedCounter = countDoc.data.getInt('count') + 1;
      final updatedData = UpdateData();
      updatedData.setInt('count', incrementedCounter);

      transaction.update(ref, updatedData);
    });
  });
}
```

#### Cloud Function deployment
 
After we've created the `onCreate` trigger with the `onCreateEventHandler`, we should compile the code into JavaScript, using the [build_runner](https://pub.dev/packages/build_runner) and [build_node_compilers](https://pub.dev/packages/build_node_compilers) packages.

To do so, we should create a `build.yaml` configuration file defining the sources to build and the compiler used to compile `Dart` code to `JavaScript`. The following code snippet provides a sample configuration file:

```yaml
targets:
  $default:
    sources:
    # main.dart file location directory
      - lib/**
    builders:
      build_node_compilers|entrypoint:
        options:
          compiler: dart2js
```

With this, we can use the following command to compile our `main.dart`:

```bash
pub run build_runner build --output=build
```

With that in place, we can [deploy](https://firebase.google.com/docs/functions/get-started#deploy-functions-to-a-production-environment) the compiled function to the Firebase.

Modify the `main` key in the `package.json` to point the compiled js file, in the `build` folder:

```json
{
  ...
  "main": "build/.../index.dart.js"
  ...
}
```

The deploy command example:

```bash
firebase deploy --only functions
```

Using the `cloud_firestore` package we've started creating test documents in parallel using multiple clients.

As a result, our event handler is fired each time, when a new Firestore document is created and we have a counter value with the number of the documents. 
