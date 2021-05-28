# In-Progress Builds Introduction

## Introduction
> Describe the main purpose of the document.

The CI Integrations Tool synchronizes builds for a specified project. The synchronization is divided into two main parts - re-syncing in-progress builds and syncing new builds. This document describes the design of the required changes to introduce in-progress builds.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations module architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md)
- [Builds Synchronization](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md)

## Design
> Explain and diagram the technical design.

From the tool's point of view, the in-progress builds introduction requires changes to the following Metrics project's components:

- `core`;
- `ci_integrations`;
- `firebase`.

The below subsections cover the required changes and implementations to be performed for each component in the above. 

### Core

The `core` component contains definitions (i.e. implementations) related to builds and project metrics builds. Therefore, the definition for in-progress builds is also represented within the `core` component. More precisely, the in-progress build means that the build has the `status` field equal to the `BuildStatus.inProgress`.

The following class diagram demonstrates the core structure of classes related to builds. Note that the class structure doesn't change but the `BuildStatus` enum contains a new `inProgress` value.

![Build Core Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/in_progress_builds/diagrams/build_core_class_diagram.puml)

### CI Integrations Tool

The CI Integrations Tool is implemented within the `ci_integrations` component. The CLI provides several integrations for different `source` clients - i.e., CI tools (as Jenkins, Buildkite, GitHub Actions) - and `destination` client - Firestore database. These integrations are used by the `SyncStage`s that perform the stages of the synchronization algorithm, controlled by the `CiIntegration` class. And finally, the `SyncCommand` class represents the tool's `sync` command and starts the synchronization providing [Controlling Parameters](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md#control-synchronization) and synchronization algorithm `SyncStage`s with appropriate `source` and `destination` integrations.

All the components listed above are participants of the synchronization process. As the in-progress builds introduction affects the synchronization process, the participants of that process should be changed to meet the latest requirements. The `SyncStage` and concrete stage implementations should be added and integrated to the `CiIntegration` class. The synchronization process in details is described in the [Builds Synchronization](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md) document.

The following subsections describe changes in the described parts of the tool. To know more about the CI Integration tool, its usage, and architecture consider the [CI Integration Module Architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md) and [CI Integration User Guide](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/02_ci_integration_user_guide.md) documents.

#### Sync Command

The `SyncCommand` class represents an implementation of the `ci_integration sync` command. The main purpose of this class is to start the synchronization process with the configured `source` and `destination` clients and controlling parameters. The in-progress builds introduction requires a new controlling parameter to be passed to the sync algorithm - `SyncConfig.inProgressTimeout`. This parameter defines a timeout duration for in-progress builds and is represented by the `--in-progress-timeout` option of the `sync` command. The [Timeout In-Progress Builds](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md#timeout-in-progress-builds) section of the [Builds Synchronization](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md) document describes and examples how this parameter is used.

The `SyncCommand` should add the `--in-progress-timeout` option using the [`ArgParser.addOption`](https://pub.dev/documentation/args/latest/args/ArgParser/addOption.html) method as follows:

```dart
    argParser.addOption(
      _inProgressTimeoutOptionName,
      help: 'A timeout duration in minutes for in-progress builds.',
      valueHelp: defaultInProgressTimeout.inMinutes,
      defaultsTo: defaultInProgressTimeout.inMinutes,
    );
```

Where the `_inProgressTimeoutOptionName` and `defaultInProgressTimeout` are constants that stores the option name and its default value respectively.

Also, the `SyncCommand` should be able to parse the given `--in-progress-timeout` option value to pass it then to the `SyncConfig`. The `SyncConfig` class, in its turn, should be updated with the `inProgressTimeout` field. Consider the [Sync Algorithm](#sync-algorithm) section to know more about changes related to the `SyncConfig` class.

The following class diagram demonstrates the described changes:

![Sync command class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/features/in_progress_builds/diagrams/sync_command_class_diagram.puml)

#### Sync Algorithm

The algorithm synchronizes builds for the specified `source` and `destination` integrations. The in-progress builds introduction requires this algorithm to be divided into two main parts: re-sync in-progress builds and sync new builds. The second part is how the synchronization algorithm is implemented now. So the purpose of the algorithm changes is to implement the re-syncing in-progress builds. 

Moreover, the synchronization algorithm is now divided into stages that are represented by `SyncStage`s implementers. Thus, the existing sync algorithm should now be interpreted as one of the `SyncStage` implementations. Consider the [Sync Algorithm Stages](#sync-algorithm-stages) to know the details about `SyncStage`s.

_**Note**: The algorithm parts shouldn't be performed in parallel. The first stage is to re-sync in-progress builds. If and only if the first stage finishes successfully, the second stage with syncing new builds is started. To follow this requirement, the `SyncStage.sync` method finishes with `InteractionResult` instance._

The in-progress builds introduction adds a new controlling parameter for the sync algorithm. This parameter controls the timeout duration for in-progress builds. According to the definition, if the in-progress build duration is greater than the configured timeout duration, this build is considered as finished with an unknown status (i.e., `BuildStatus.unknown`). The described parameter is called **in-progress timeout**. The `SyncConfig` provides controlling parameters and other configurations to the sync algorithm. Thus, the **in-progress timeout** should be a part of the `SyncConfig` class. Therefore, `SyncConfig` class updates include adding the `inProgressTimeout` field having the `Duration` type.

##### Sync Algorithm Stages

As the `CiIntegration` class is used to perform the synchronization algorithm, it should be updated to call the given stages. The list of stages should be integrated to the `CiIntegration` instance in the `SyncCommand` class. The proper list of stages is created by the `SyncStagesFactory`. And the algorithm parts are now placed within different classes `InProgressBuildsSyncStage` and `NewBuildsSyncStage` for re-sync in-progress builds and sync new builds respectively. Thus, the `CiIntegration.sync` method should be updated to call the different parts of an algorithm delegating their execution to the appropriate stage classes.

The following table contains classes to implement with a short description:

|Class|Description|
|---|---|
|`SyncStage`|An interface representing a stage of the synchronization algorithm.|
|`BuildsSyncStage`|An abstract class that implements the `SyncStage` interface and provides the common methods for the stages that synchronizes builds.|
|`InProgressBuildsSyncStage`|An implementation of the `BuildsSyncStage` that represents a stage for re-syncing in-progress builds.|
|`NewBuildsSyncStage`|An implementation of the `BuildsSyncStage` that represents a stage for syncing new builds.|
|`SyncStagesFactory`|A factory class that creates a list of stages for the synchronization algorithm in the proper order.|

The re-syncing in-progress builds stage is described within the [Re-Sync In-Progress Builds](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md#re-sync-in-progress-builds) and [Making Things Work](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md#making-things-work) sections of the [Builds Synchronization](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md) document. This section also covers how steps of the re-sync part should work. Thus, to implement the desired part of the sync algorithm, it is strongly recommended to follow the definitions and tips listed in the mentioned document.

As in the [Builds Synchronization](https://github.com/Flank/flank-dashboard/blob/master/metrics/ci_integrations/docs/06_builds_synchronization.md) document, the following class diagram contains the main classes and interfaces that participate in the sync algorithm:

![Sync algorithm class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/sync_algorithm_class_diagram.puml)

#### Source Client

The `SourceClient` is an interface for `source` clients that provide abilities to fetch builds for synchronization. As mentioned in the [Sync Algorithm](#sync-algorithm) section, the in-progress builds introduction requires adding the re-syncing in-progress builds stage into the sync algorithm. For this stage, `source` clients should be able to fetch a build by the specified build number. Thus, the `SourceClient` should be updated with the appropriate method for the concrete build fetching. The required method is the `SourceClient.fetchOneBuild` method.

The following class diagram demonstrates the structure of `source` clients:

![Source clients class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/features/in_progress_builds/diagrams/source_clients_class_diagram.puml)

Also, the `source` clients should now return in-progress builds. The following subsections cover the details of changes to concrete clients implemented within the CI Integrations tool.

##### Jenkins Integration

The Jenkins source integration allows fetching builds data from the Jenkins CI. This integration should be updated to return running builds as well as finished ones. Currently, the `JenkinsSourceClientAdapter` filters out running builds using their `JenkinsBuild.building` flag.

Once builds are fetched, the adapter filters these builds using the `_checkBuildFinishedAndInRange` method. This method checks the given build to be finished and its number to be greater than the given minimal build number. More precisely, the concrete `jenkinsBuild` satisfies the `_checkBuildFinishedAndInRange` method if the following holds:

- `jenkinsBuild.building` is `false`;
- `jenkinsBuild.number` is greater than `minBuildNumber`, where `minBuildNumber` is the given parameter.

To allow fetching running builds, the method described above is to be updated by removing the first condition that checks the `building` flag to be `false`. Thus, the method should check only the build number and becomes the `_checkBuildInRange` method. 

_**Note**: Generally speaking, this method can be inlined as it is used only in one place. However, keeping this logic separately is better according to the SOLID principles. Thus, the method that maps a list of builds doesn't know conditions to filter these builds and calls the responsible method._

Also, the `JenkinsSourceClientAdapter` should now implement the new `fetchOneBuild` method to match the `SourceClient` interface. The adapter should use the specified `JenkinsClient` instance to fetch the build with the given number.

##### Buildkite Integration

The Buildkite source integration allows fetching builds data from the Buildkite CI. This integration should be updated to return running builds as well as finished ones. Currently, the `BuildkiteSourceClientAdapter` fetches all builds having the `BuildkiteBuildState.finished` state. The `finished` state is a shortcut for the set of `passed`, `failed`, `blocked`, `canceled` states, and is used for API requests to filter builds.

According to the above, the `BuildkiteSourceClientAdapter` doesn't filter builds by status - it requests builds by status. To include in-progress builds, the adapter is to request builds with statuses indicating progress. The Buildkite build can be one of the following states: `running`, `scheduled`, `passed`, `failed`, `blocked`, `canceled`, `canceling`, `skipped`, `not_run` (`finished` state is a shortcut for API requests). For the Buildkite integration, we assume that the build is in progress if this build has a state `running` or `canceling`. So the integration should be updated to fetch such builds as well.

Consider the following mapping of Buildkite state to Metrics `BuildStatus`:

- `running` -> `BuildStatus.inProgress`;
- `canceling` -> `BuildStatus.inProgress`;
- `passed` -> `BuildStatus.successful`;
- `failed` -> `BuildStatus.failed`;
- `blocked` -> `BuildStatus.unknown`;
- `canceled` -> `BuildStatus.unknown`.

So, in-progress builds introduction requires the `BuildkiteSourceClientAdapter` to fetch builds having the state `finished`, `running`, and `canceling`. To make this possible, the `BuildkiteClient.fetchBuilds` method should be updated to accept the list of states for builds to fetch and pass it to the API call as described in the [List builds for a pipeline](https://buildkite.com/docs/apis/rest-api/builds#list-builds-for-a-pipeline) section of Buildkite [Builds API](https://buildkite.com/docs/apis/rest-api/builds) documentation. The adapter then fetches builds as follows:

```dart
  Future<BuildkiteBuildsPage> _fetchBuildsPage(
    String pipelineSlug, {
    int page,
    int perPage,
  }) async {
    final interaction = await buildkiteClient.fetchBuilds(
      pipelineSlug,
      state: [
        BuildkiteBuildState.finished, 
        BuildkiteBuildState.running, 
        BuildkiteBuildState.canceling,
      ],
      page: page,
      perPage: perPage,
    );

    return _processInteraction(interaction);
  }
```

Also, the `BuildkiteSourceClientAdapter` should now implement the new `fetchOneBuild` method to match the `SourceClient` interface. The adapter should use the specified `BuildkiteClient` instance to fetch the build with the given number.

##### GitHub Actions Integration

The GitHub Actions source integration allows fetching builds data from the GitHub Actions CI. This integration should be updated to return running builds as well as finished ones. The build is considered as a job execution within a single workflow run. Thus, the workflow run number is considered as the build number and the job status/conclusion as the build status. Currently, the `GithubActionsSourceClientAdapter` fetches workflow runs having the `GithubActionStatus.completed` status. Let's take a closer look at GitHub statuses and conclusions for runs and jobs.

In the context of GitHub, the `status` means the execution status of an entity meaning and answers the question _"What is going on with the process?"_ The `conclusion` is the result of the process that answers the question _"What was the outcome of the process?"_ So the following statements hold:

- the `status` depends on the progress of the process - **what is happening now**;
- the `conclusion` describes the result of the process - **what happened**.

While the process is running, the `conclusion` is always `null`. On the other hand, if the `conclusion` is not `null`, the `state` is always `completed`. Thus, the current GitHub Actions integration queries workflow runs that have only `completed` status to ensure that all jobs within that run are finished and provide their results. However, the in-progress builds introduction requires querying running jobs (and therefore runs) as well. The following table describes possible statuses and conclusions for jobs and how are they mapped to the Metrics `BuildStatus` (note that the `queued` status or `skipped` conclusion are ignored):

|Status|Conclusion|BuildStatus|
|---|---|---|
|`queued`|`null`|**ignored**|
|`in_progress`|`null`|`inProgress`|
|`completed`|`success`|`successful`|
|`completed`|`failure`|`failed`|
|`completed`|`timed_out`|`failed`|
|`completed`|`action_required`|`unknown`|
|`completed`|`cancelled`|`unknown`|
|`completed`|`neutral`|`unknown`|
|`completed`|`skipped`|**ignored**|
|`completed`|`stale`|`unknown`|

According to the table above, the `GithubActionsSourceClientAdapter` should fetch running builds as well as finished ones. To archive that, the `_fetchRunsPage` should be modified to not request only `completed` runs as follows: 

```dart
  Future<WorkflowRunsPage> _fetchRunsPage({
    int page,
    int perPage,
  }) async {
    final interaction = await githubActionsClient.fetchWorkflowRuns(
      workflowIdentifier,
      status: GithubActionStatus.completed, // remove this line
      page: page,
      perPage: perPage,
    );

    return _processInteraction(interaction);
  }
```

Then, runs and jobs having the status `queued` or conclusion `skipped` should be filtered out manually. Consider [List workflow runs for a repository](https://docs.github.com/en/rest/reference/actions#list-workflow-runs-for-a-repository) and [List jobs for a workflow run](https://docs.github.com/en/rest/reference/actions#list-jobs-for-a-workflow-run) sections of the [GitHub Actions API](https://docs.github.com/en/rest/reference/actions) documentation for more information.

Also, the `GithubActionsSourceClientAdapter` should now implement the new `fetchOneBuild` method to match the `SourceClient` interface. The adapter should use the specified `GithubActionsClient` instance to fetch the build with the given number.

#### Destination Client

The `DestinationClient` is an interface for `destination` clients that provide abilities to store synchronized builds and interact with the database. As mentioned in the [Sync Algorithm](#sync-algorithm) section, the in-progress builds introduction requires adding the re-syncing in-progress builds stage into the sync algorithm. This stage queries in-progress builds from the database and then updates them after re-syncing. Thus, the `DestinationClient` should be updated with appropriate methods to perform the required functionality.

The following methods are to be added to the `DestinationClient` interface:

- `fetchBuildsWithStatus` - fetches all builds having the given status for the given project.
- `updateBuilds` - updates all the given builds with new values for the given project.

The following class diagram demonstrates the structure of `destination` clients:

![Destination clients class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/features/in_progress_builds/diagrams/destination_clients_class_diagram.puml)

The following subsection covers the details of changes to the Firestore integration.

##### Firestore Integration

The Firestore destination integration allows interacting with the Firestore database to manipulate synchronized builds data. The in-progress builds introduction requires the Firestore integration to be able to fetch in-progress builds for re-syncing and updating these builds after the re-syncing completes. The `DestinationClient` interface contains new methods required for the sync algorithm.

The following methods are to be implemented for the `FirestoreDestinationClientAdapter` to match the `DestinationClient` interface:

- `fetchBuildsWithStatus`
- `updateBuilds`

The `fetchBuildsWithStatus` is used by the sync algorithm to fetch in-progress builds stored in the database. This method should throw if the project with the given identifier does not exist. If the project exists but doesn't have builds with the given status, the method should return an empty list.

The `updateBuilds` method is used to update in-progress builds with new data and status. This method should throw if the project with the given identifier does not exist. If updating one of the builds fails, the method should continue updating other builds, as the failed build can be re-synced later, during the next synchronization. Generally speaking, the implementation should be flexible, providing an ability to switch between the following options:

- a build updating is mandatory - if an update throws, the method throws as well;
- a build updating is not mandatory - if an update throws, the method should continue updating other builds.

Thus, using the `Future.wait` method is recommended as allows controlling the described behavior. Also, if it is possible, using [batched writes](https://firebase.google.com/docs/firestore/manage-data/transactions#batched-writes) would be a plus as performs a set of write operations atomically.

### Firebase

The `firebase` component contains the implementations related to Firebase such as Cloud Functions, Firestore Security Rules, Firestore Indexes definition, and the set of tests for interactions with the Cloud Firestore database. As in-progress builds lack some data during the synchronization, the Firestore Security Rules require changes to allow writing in-progress builds. The following subsection examines the updates for Security Rules.

#### Firestore Security Rules

Firestore Security Rules provide access control and data validation. The rules specification for the Metrics project is listed within the `firestore.rules` file under the `firebase/firestore/rules/` directory. The `firestore.rules`, in its turn, contains several sections with rules for each collection within the Cloud Firestore database. The in-progress builds introduction requires changes to the rules for the `build` collection that stores documents with builds data.

Rules for the `build` collection are placed within the `match /build/{buildId}` block. Let's look at the statements of the `build`'s collection rules: 

1. Only authorized users can **read** builds.
2. Only authorized users can **create** and/or **update** builds.
3. Only valid build data can be used to **create** and/or **update** builds.
4. Nobody can **delete** builds.

According to the third statement, the build's data of **create** and **update** requests are validated to contain the proper data. The following table describes fields validation and the required changes according to the structure of the in-progress build:

|Field|Required|Type|Validation|Changes|
|---|---|---|---|---|
|`projectId`|**Yes**|`string`|The project must exist|None.|
|`buildNumber`|**Yes**|`integer`|None.|None.|
|`startedAt`|**Yes**|`timestamp`|Must represent time in the past.|None.|
|`buildStatus`|**No**|`string`|Must be one of the `BuildStatus` values.|Should handle a new `BuildStatus.inProgress` value.|
|`duration`|**Yes**|`integer`|None.|Must be null for an in-progress build.|
|`workflowName`|**No**|`string`|None.|None.|
|`url`|**Yes**|`string`|None.|None.|
|`apiUrl`|**No**|`string`|None.|None.|
|`coverage`|**No**|`float`|Must be in range `[0.0; 1.0]`.|None.|

So the required changes are related to the `duration` and `buildStatus` fields validation. The former one must not be required for in-progress builds (more precisely, it __must be null__), and the latter field now has a new valid value - `BuildStatus.inProgress`.

The appropriate tests for rules should be updated as well to match the new build data validation. These tests are located under the `test/firestore/rules/` directory within the `firebase` component.

## Results
> What was the outcome of the project?

The design of the in-progress builds introduction into the CI Integrations Tool.
