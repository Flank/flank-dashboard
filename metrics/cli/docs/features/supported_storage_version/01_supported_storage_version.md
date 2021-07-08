# Supported Storage Version
> Feature description / User story.

Improve Metrics Web application deployment process to include the supported storage version passing and storage version saving. 

## Contents
> In this section, provide the contents for the document, including all custom subsections created.

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
    - [Prototyping](#prototyping)
    - [System modeling](#system-modeling)

# Analysis
> Describe general analysis approach.

During the analysis section, we are going to define the requirements for this feature and choose whether to use the existing approach or develop a custom one to implement this feature.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the `Metrics Web` application would receive updates after the initial release, we should have a convenient way of updating the `Metrics Web` application even if the database has any significant changes. To be able to update the application safely, we are going to introduce a storage version and a supported storage version for all `Metrics` applications. It will allow us to block the application from interaction with the persistent storage in case the application does not support the current storage version or the storage is currently updating. To simplify the `Metrics Web` application deployment process, we should update the `Metrics CLI` to make it set the supported storage version to the `Metrics Web` application.

### Requirements
> Define requirements and make sure that they are complete.

The Metrics CLI supported storage version feature has the following requirements:

- The Metrics CLI should pass the supported storage version to the `Metrics Web` application during the building process.
- The Metrics CLI should set the supported storage version of the `Metrics Web` application into the application's environment variable named `SUPPORTED_STORAGE_VERSION`.
- The Metrics CLI has to get the supported storage version from the `STORAGE_VERSION` file under the `metrics` project folder.

### Landscape
> Look for existing solutions in the area.

According to the [Supported Storage Version](https://github.com/Flank/flank-dashboard/blob/master/metrics/docs/01_storing_storage_metadata.md#supported-storage-version) section of the `Storing Storage Metadata` document, we are storing the storage version in the `STORAGE_VERSION` file under the `metrics` package. Also, on the stage of the application deployment, the storage version and the supported storage version are the same. More precisely, the `STORAGE_VERSION` holds the current storage version that is compatible with all applications in the `metrics` folder at the current point of the repository history.

Once we've figured out the place of storing the storage version, let's take a look at how to pass this version to the `Metrics Web` application. As the [Storing Storage Metadata](https://github.com/Flank/flank-dashboard/blob/master/metrics/docs/01_storing_storage_metadata.md#supported-storage-version) section states, the `Metrics Web` application holds its supported storage version as an environment variable, so we should pass it to the `Metrics Web` application during the building process using the `dart-define` flag.

Since the storing of the supported storage versions is pretty custom, we are going to use the custom solution for setting this version in the `Metrics CLI`. 

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

So, to provide a supported storage version to the `Metrics Web` application during the deployment process, we should follow the next steps:

1. Fetch the storage version from the `STORAGE_VERSION` file under the `metrics` package.
2. Pass the fetched storage version to the `Metrics Web` application environment as a `supported storage version` during the application building process.

Let's consider the code snippets proving that this feature is possible to implement:

To read the data from the file, we are going to use the [File](https://api.dart.dev/stable/2.13.1/dart-io/File-class.html) class, providing an ability to get the file content using the following code:

```dart
final supportedStorageVersion = File('metrics/STORAGE_VERSION').readAsStringSync();
```

Once we are able to get the storage version from the file, let's confirm that we can set this version to the `Metrics Web` application environment. Consider the following command that explains the way of adding any environment variables to the `Flutter` application environment during the building process:

```bash
flutter build web --release --dart-define=SUPPORTED_STORAGE_VERSION=$SUPPORTED_VERSION
```

As we can see, the `--dart-define` adds the given key-value pair to the application environment. To get this value in the application, we can use the following code:

```dart
const supportedStorageVersion = String.fromEnvironment('SUPPORTED_STORAGE_VERSION');
```

So, since we can get the `storage version` from the `STORAGE_VERSION` file, pass this value to the `Metrics Web` application environment, and get it later in the `Metrics Web` application, we can state that the implementation of this feature is possible.

### System modeling
> Create an abstract model of the system/feature.

Since we already have an application deployment feature working, including the process of building the application, we are going to embed the supported storage version setting into this process.

Consider the following diagram explaining this process in a bit more detail: 

![Supported Storage Version Components Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/cli_versioning_analysis/metrics/cli/docs/features/supported_storage_version/diagrams/storage_version_components_diagram.puml)
