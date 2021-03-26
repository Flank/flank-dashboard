# Feature design

> Feature description / User story.

At the moment, integration tests run inside the production environment (e.g. using production Firestore). This approach carries the risk of accidental data loss or alteration. Therefore, we should use the test environment to run the tests.

# Analysis

> Describe general analysis approach.

To implement this feature, we've investigated the possibility of using the [Firebase Local Emulator](https://firebase.google.com/docs/emulator-suite).

The Firebase Local Emulator consists of individual service emulators built to accurately mimic the behavior of Firebase services. This means we can connect our app directly to these emulators to perform integration testing without touching production data.

One of the services of the emulator is a Firestore that allows to safely read and write documents during testing.

### Feasibility study

> A preliminary study of the feasibility of implementing this feature.

The ability to use the emulator on the web for the Firestore is described in the [Firebase documentation](https://firebase.google.com/docs/emulator-suite/connect_firestore).

The implementation of this feature for Flutter is the use of the `Firebase.instance.settings()` method, provided by the [cloud_firestore](https://pub.dev/packages/cloud_firestore) package.

### Requirements

> Define requirements and make sure that they are complete.

1. [Firebase CLI](https://firebase.google.com/docs/cli) that allows us to use Firebase commands to run and configure the emulator.
2. [cloud_firestore](https://pub.dev/packages/cloud_firestore) package.

### Prototyping

> Create a simple prototype to confirm that implementing this feature is possible.

The described feature consists of two pieces:

 1. The Firestore emulator running.
 2. Web app connected to the emulator when running integration tests.

Before we run the emulator, we need to check the configurations in the `firebase.json` file.

The emulator will take Security Rules configuration from the `firestore` configuration key, 
so make sure it links to the right file location.

```json
    "firestore": {
        "rules": "firestore/rules/firestore.rules",
        ...
    }
```

The default emulator's port is 8080. 
To customize that you can specify an additional key in the `firebase.json` file.

```json
    "emulators": {
        "firestore": {
            "port": "8080"
        },
        ...
    }
```
The emulator erases the data inside the Firestore each time it starts. 
So we need to import test data into the emulator when we start it by adding the following flag `--import=import_directory`.

So with that in place, we can run the emulator by using the following command:

```bash
    firebase emulators:start --only firestore --import=import_directory
```

Now the emulator is running and it is time to use it in the app's integration tests.

In the `setUpAll` method of the tests we need to configure the Firestore instance to use the emulator:

```dart
setupAll(() {
    Firestore.instance.settings(
        host: 'localhost:8080', 
        sslEnabled: false, 
        persistenceEnabled: false,
    );
});
```

The specified port in the `host` argument must be equal to the emulator's port.
