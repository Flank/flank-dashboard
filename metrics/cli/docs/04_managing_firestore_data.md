# Managing Firestore data

## Motivation
> What problem is this project solving?

Since, the Metrics App stores [allowed domains](https://github.com/platform-platform/monorepo/blob/master/docs/19_security_audit_document.md#the-allowed_email_domains-collection) and [feature config](https://github.com/platform-platform/monorepo/blob/master/docs/19_security_audit_document.md#the-feature_config-collection) collections in Cloud Firestore and these collections are protected by the Firebase rules from the reading and writing, so we should find an approach of managing Firestore data using [Admin SDK](https://developers.google.com/admin-sdk).

Therefore, the document's goal is to investigate all approaches of managing Cloud Firestore data using [Admin SDK](https://developers.google.com/admin-sdk) to make the Metrics CLI the most usable.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
- [Admin SDK](https://developers.google.com/admin-sdk)
- [dartbase_admin package](https://pub.dev/packages/dartbase_admin)

## Analyze

### Process

The analysis begins with an overview of managing Cloud Firestore data using `Admin SDK` approaches during Metrics Web application deployment.
It provides the main pros and cons and a short description of each approach we've investigated.

This research should conclude with a chosen approach and a short explanation of why did we choose such an approach.

#### Using Dart package

The first approach is to use a [dartbase_admin](https://pub.dev/packages/dartbase_admin) package as a dart-native implementation of the Firebase Admin SDK, which allows us to manage Cloud Firestore data despite Firebase rules.

The `dartbase_admin` package requires the following parameters:

1. The Firebase project id, which the Metrics CLI tool generates during the deploy command proccess.

2. The JSON of the service account's key, which can be downloaded using the following command:

```bash
gcloud iam service-accounts keys create key.json --iam-account project_id@appspot.gserviceaccount.com
```

Example of creating document using dart package:

```dart
  final keyJson = await ServiceAccount.fromFile('key.json');
  final firebase = await Firebase.initialize('projectId', keyJson);

  Firestore.initialize(firebase: firebase);
  await Firestore.instance.collection('collection').document('doc_id').create({});
```

Let's review the pros and cons of this approach.

Pros:

- fully automated.

Cons:

- increases the number of dependencies.

#### Using Cloud Functions for Firebase

The second approach is to use the [Cloud Functions](https://firebase.google.com/docs/functions), which can work with `Admin SDK` using Node modules `require` statements.

Example of enabling `Admin SDK` in Cloud function:

```js
// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
```

The following steps describe the flow of this approach:

1. create an [HTTP Cloud function](https://cloud.google.com/functions/docs/writing/http), which should initialize required collections using `Admin SDK`;

2. deploy the created Cloud function using `firebase deploy --only functions` command;

3. trigger the deployed Cloud function via an HTTP(s) request.

Let's review the pros and cons of this approach.

Pros:

- encapsulates the Cloud Firestore data management logic in the Cloud function; 

Cons:

- requires steps from the user side (configure billing account);

### Decision

As we've analyzed above, the [Cloud Functions](#using-cloud-functions-for-firebase) does not allow us to automate the Cloud Firestore data managing, so we should choose the [Dart Package](#using-dart-package) since it provides a more clean and fully automated way of managing Cloud Firestore data.
