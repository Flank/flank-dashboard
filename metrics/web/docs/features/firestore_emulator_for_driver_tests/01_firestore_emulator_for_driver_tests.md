# Firestore emulator for driver tests

> Feature description / User story.

At the moment, integration tests run inside the production environment (e.g. using production Firestore). This approach carries the risk of accidental data loss or alteration. Therefore, we should use the test environment to run the tests.

# Analysis

> Describe general analysis approach.

To implement this feature, we've investigated the possibility of using the [Firebase Local Emulator](https://firebase.google.com/docs/emulator-suite).

The Firebase Local Emulator consists of individual service emulators built to accurately mimic the behavior of Firebase services. This means we can connect our app directly to these emulators to perform integration testing without touching production data.

One of the services of the emulator is a Firestore that allows creating a local instance of the Firestore and use it during testing.

### Feasibility study

> A preliminary study of the feasibility of implementing this feature.

The Firestore emulator allows us to run integration tests using the test environment, so that can ensure that the tests do not affect the production data.

With that, we may not care about creating a large number of entities, deleting them, or changing them through tests.

_**Note:**
We are not configuring the [Firebase Auth emulator](https://firebase.google.com/docs/emulator-suite/connect_auth) because it is not available in the version of the [firebase_auth](https://pub.dev/packages/firebase_auth) package we are using. So, during tests, we authenticate via the production Firebase Auth service._

### Requirements

> Define requirements and make sure that they are complete.

1. A Firestore emulator, run using the imported test data.
2. The web application uses the Firestore instance configured to use the emulator while running integration tests.
### Prototyping

> Create a simple prototype to confirm that implementing this feature is possible.

To run the driver tests under the Firebase emulator we should follow the next steps:

1.  Run the Firebase emulator before running the app under tests.
2.  Configure the application under tests to use the Firebase emulator instance before running tests.
3.  Run the driver tests as usual.

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

To prepare the test data, we can manually create necessary collections and documents through the emulator's UI and save it using the following command:

```bash
firebase emulators:export export_directory
```

The specified `export_directory` will be created if it does not already exist. If the specified directory exists, you will be prompted to confirm that the previous export data should be overwritten. For more information on using the command consider [the following link](https://firebase.google.com/docs/emulator-suite/install_and_configure#export_and_import_emulator_data).

Now we can run the emulator with the initial data by adding the following flag `--import=import_directory`, where the `import_directory` is the directory that holds the exported data.

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

# Design

### User Interface

> How users will interact with the feature (API, CLI, Graphical interface, etc.).

The feature is introduced by adding additional parameters to the integration tests running command.

The next table contains the definitions of the parameters with their default values.

| Parameter         | Default | Description                                                           |
| ----------------- | -------- | --------------------------------------------------------------------- |
| **use-emulator**  | true     | Determines if the integration tests are using the `Firebase Emulator`. |
| **emulator-port** | 8080     | Specifies the emulator's running port.                                  |

The following code snippet shows an example of using the new parameters:

```bash
dart test_driver/main.dart --use-emulator=true --port=8081
```

Or, if you accept the defaults, you can omit them.

As described in the [Prototyping](#prototyping) section, we should run integration tests once the `Firebase Emulator` started.

### Database

> How relevant data will be persisted.

Integration tests interacts with the application that uses data from the database. 

As we don't want to use the production environment, we should use the `Firebase local emulator`.

The emulator has no data as a default, so we need to create necessary collections.

It is not convenient to create it every time the emulator starts. So, for this purposes, we need to create all collection once and export it using the following command:

```bash
firebase emulators:export export_directory
```

_**Note:** You can place just `.` instead of the `export_directory` name and the firebase creates the directory, named `firestore_export` as a default._

From now, we can run emulator with the exported data using the following command:

```bash
firebase emulators:start --import=export_directory
```

### Program

> Detailed solution description to class/method level.

The `ArgParser` needs to accept the described above parameters:

```dart
_parser.addFlag(_useEmulator, defaultsTo: true);

_parser.addOption(_emulatorPort, defaultsTo: '8080');
```

We should create the `FirebaseEmulator` class, that group together these parameters and pass it to the `DriverTestArguments`.

As we want to access values of the parameters in the integration tests, we need to pass the created `FirebaseEmulator` to the process environment of the `flutter drive` command.

Consider the following example:

```dart
FlutterDriveProcessRunner(
    browserName: _args.browserName,
    verbose: verbose,
    environment: FlutterDriveEnvironment(
        userCredentials: _args.credentials,
        emulator: _args.emulator,
    ),
    useSkia: useSkia,
);
```

As you can see, the `FlutterDriveEnvironment` now accepts one more argument - the `emulator`.

So now, in the process of constructing the `FlutterDriveProcessRunner` we can pass the parameters to the environment via the `dartDefine` method:

```dart
    _driveCommand
      ...
      ..dartDefine(
        key: FirebaseEmulator.emulatorEnvVariableName,
        value: environment.emulator.useEmulator,
      )
      ..dartDefine(
        key: FirebaseEmulator.portEnvVariableName,
        value: environment.emulator.port,
      );
```

With this, we can use the `FirebaseEmulator.fromEnvironment()` method to retrieve the instance with the passed parameters and use them in the integration tests.

Example:

```dart
// app_test.dart

final emulator = FirebaseEmulator.fromEnvironment();

if (emulator.useEmulator) {
    final host = 'localhost:${emulator.port}';

    Firestore.instance.settings(host: host, sslEnabled: false, persistenceEnabled: false);
}
```
