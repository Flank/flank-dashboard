# Supported Storage Version
> Feature description / User story.

Improve Metrics Web application deployment process to include the supported storage version passing and storage version saving. 

## Contents

In this section, provide the contents for the document including all custom subsections created.

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
    - [Prototyping](#prototyping)
        - [Metrics Web Supported Storage Version](#metrics-web-supported-storage-version)
        - [Firestore Storage Version](#firestore-storage-version)
    - [System modeling](#system-modeling)

# Analysis
> Describe general analysis approach.

During the analysis section, we are going to define the requirements of this feature and choose whether to use the existing approach or develop a custom one to implement this feature.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the `Metrics Web` application would receive updates after the initial release, we should have a convenient way of updating the `Metrics Web` application even if the database has any significant changes. To be able to update the application safely, we are going to introduce a storage version and a supported storage version for all `Metrics` applications. It will allow us to block the application from interaction with the persistent storage in case the application does not support the current storage version or the storage is currently updating. To simplify the `Metrics Web` application deployment process, we should update the `Metrics CLI` to make it set the supported storage version to the `Metrics Web` application and the storage version (storage metadata) to the Firestore database during the deployment process.

### Requirements
> Define requirements and make sure that they are complete.

The Metrics CLI supported storage version has the following requirements: 

- The Metrics Web application supported storage version should be set during building the application.
- The Firebase database storage version should be saved to the Firestore database during the deployment process. 

### Landscape
> Look for existing solutions in the area.

According to the [Supported Storage Version](https://github.com/Flank/flank-dashboard/blob/master/metrics/docs/01_storing_storage_metadata.md#supported-storage-version) section of the `Storing Storage Metadata` document, we are storing the storage version in the `STORAGE_VERSION` file under the `metrics` package. Also, on the stage of the application deployment, the storage version and the supported storage version are the same. More precisely, the `STORAGE_VERSION` holds the current storage version that is compatible with all applications in the `metrics` folder at the current point of the repository history.

Once we've figured out the place the storage version is stored, let's take a look at how to pass this version to the `Metrics Web` application. As the [Storing Storage Metadata](https://github.com/Flank/flank-dashboard/blob/master/metrics/docs/01_storing_storage_metadata.md#supported-storage-version) section states, the `Metrics Web` application holds its supported storage version as an environment variable, so we should pass it to the `Metrics Web` application during the building process using the `dart-define` flag.

After that, we should save the storage version to the `Firestore` database. The [Storage Metadata](https://github.com/Flank/flank-dashboard/blob/master/metrics/docs/01_storing_storage_metadata.md#storage-metadata) section explains that the `Firestore` database contains the `metadata` document inside the `metadata` collection that holds the current storage version, so we should create this document during the `Firestore` database initialization. 

Since the storing of the storage and supported storage versions aree pretty custom, we are going to use the custom solution for setting this version in the `Metrics CLI`. 

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

Let's consider the code snippets confirming the availability setting the `Metrics Web` supported storage version environment variable and `Firestore` storage version using the `Metrics CLI`. 

#### Metrics Web Supported Storage Version

So, to provide a supported storage version to the `Metrics Web` application during the deployment process, we should follow the steps below: 

1. Fetch the storage version from the `STORAGE_VERSION` file under the `metrics` package. 
2. Pass the fetched storage version to the `Metrics Web` application environment as a `supported storage version` during the application building process.

Let's consider the code snippets proving that this feature is possible to implement: 

To read the data from the file, we are going to use the [File](https://api.dart.dev/stable/2.13.1/dart-io/File-class.html) class that provides the ability to get the file contents.

Once we can get the storage version from the file, let's consider the process of setting the environment variable to the Flutter Web applications during the building process: 

```bash
flutter build web --release --dart-define=SUPPORTED_STORAGE_VERSION=$SUPPORTED_VERSION
```

As we can see, the `--dart-define` adds an environment variable to the application environment. To get this value in the application, we can use the following code: 

```dart
const supportedStorageVersion = String.fromEnvironment('SUPPORTED_STORAGE_VERSION');
```

See [Storing Storage Metadata](https://github.com/Flank/flank-dashboard/blob/master/metrics/docs/01_storing_storage_metadata.md#supported-storage-version) document to get more details about storing the application supported storage versions. 

#### Firestore Storage Version

Since the storage version is stored in the `metadata` collection, which cannot be modified due to security rules, we should use the `Firebase Admin SDK` during the deployment process to initialize the `Firestore` database. 

Let's consider a code snippet showing a `metadata` document creation process: 

```dart
final storageMetadata = StorageMetadata(
    storageVersion: '1.0.0',
    isUpdating: false,
);


await firestore.document('metadata/metadata').add(storageMetadata.toJson());
```

So, since passing the supported storage version and saving the storage metadata is possible, we can conclude that the feature implementation is possible. 

### System modeling
> Create an abstract model of the system/feature.

Since we already have an application deployment feature working, including the process of building the application, we are going to embed the supported storage version setting into this process.

Consider the following diagram explaining this process in a bit more details: 

![Supported Storage Version Components Diagram]()
