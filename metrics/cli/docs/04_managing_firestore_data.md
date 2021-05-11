# Managing Firestore data

## Motivation
> What problem is this project solving?

Since the Metrics App stores [allowed domains](https://github.com/platform-platform/monorepo/blob/master/docs/18_security_audit_document.md#the-allowed_email_domains-collection) and [feature config](https://github.com/platform-platform/monorepo/blob/master/docs/19_security_audit_document.md#the-feature_config-collection) collections in Cloud Firestore and these collections are protected by the Firebase rules from the writing, we should find an approach of managing Firestore data using [Admin SDK](https://developers.google.com/admin-sdk).

Therefore, the document's goal is to investigate all approaches of managing Cloud Firestore data using [Admin SDK](https://developers.google.com/admin-sdk) to make the Metrics CLI the most usable.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
- [Admin SDK](https://developers.google.com/admin-sdk)
- [dartbase_admin package](https://pub.dev/packages/dartbase_admin)

## Analysis

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
  final serviceAccount = await ServiceAccount.fromFile('key.json');
  final firebase = await Firebase.initialize('projectId', serviceAccount);

  Firestore.initialize(firebase: firebase);

  const data = {
    name: 'name',
    state: 'state',
    country: 'country'
  };

  await Firestore.instance.collection('collection').document('doc_id').set(data);
```

Let's review the pros and cons of this approach.

Pros:

- does not require user interaction;

- easy to maintain since we're using the Dart package.

Cons:

- increases the number of dependencies.

#### Using Cloud Functions for Firebase

The second approach is to use the [Cloud Functions](https://firebase.google.com/docs/functions), which will manage the Firestore data using the [JavaScript Admin SDK](https://firebase.google.com/docs/admin/setup) and the Metrics CLI will call it using the HTTP requests.

The following steps describe the flow of this approach:

1. create an [HTTP Cloud function](https://cloud.google.com/functions/docs/writing/http), which should initialize required collections using `Admin SDK`;

2. enable at least a Blaze billing plan since the deployment of the functions [requires it](https://firebase.google.com/support/faq#expandable-9);

3. deploy the created Cloud function using `firebase deploy --only functions` command;

4. trigger the deployed Cloud function via an HTTP(s) request.

Example of the Cloud function, which creates the document:

```js
const data = {
  name: 'name',
  state: 'state',
  country: 'country'
};

exports.seedData = functions.https.onRequest(async (req, res) => {
  await admin.firestore().collection('collection').document('doc_id').set(data);
 
  res.status(200).send('The document successfully created');
});
```

Let's review the pros and cons of this approach.

Pros:

- encapsulates the Cloud Firestore data management logic in the Cloud function.

Cons:

- requires Firebase billing plan;

- requires steps from the user side (configure billing plan).

### Decision

As we've analyzed above, the [Cloud Functions](#using-cloud-functions-for-firebase) does not allow us to automate the Cloud Firestore data managing, so we should choose the [Dart Package](#using-dart-package) since it provides a more clean and fully automated way of managing Cloud Firestore data.
