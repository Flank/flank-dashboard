# Builds Synchronization

## Introduction

The CI Integration tool synchronizes builds to make them available for the Metrics Web Application. The algorithm of synchronization fetches builds from the `source` and stores them to the `destination`. This document examines this algorithm to make it more clear and clarify the details of builds synchronization.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [CI Integrations module architecture](01_ci_integration_module_architecture.md)
- [CI Integrations user guide](02_ci_integration_user_guide.md)

## Goals
> Identify success metrics and measurable goals.

- Describe the synchronization algorithm.
- Describe In-Progress builds re-syncing.
- Describe how the sync algorithm uses `source` and `destination` integrations.

## Non-Goals
> Identify what's not in scope.

The following points are out of the scope for this document:
- The way the Metrics Web Application displays synced builds and project metrics.
- The implementation of concrete `source` and `destination` integrations.


## Design
> Explain and diagram the technical design.

The following sections cover the synchronization algorithm of the CI Integration tool and its different concepts. To get more familiar with the CI Integration tool, its usage, and architecture consider the [CI Integration Module Architecture](01_ci_integration_module_architecture.md) and [CI Integration User Guide](02_ci_integration_user_guide.md) documents.

### Synchronization Algorithm

The synchronization is performed by the `CiIntegration.sync` method. This method uses the specified synchronization stages which are implementation of the `SyncStage`. The `SyncStage` represents a big complete step of the sync algorithm independent from others steps - this means that the order of stages doesn't matter. Implementers of the `SyncStage` orchestrates the specified `source` and `destination` clients. To describe an algorithm, let's first define its input and output as in the following table:

||Description|
|--|--|
|**Input**|An instance of `SyncConfig` with project identifiers for both `source` and `destination`, and _sync parameters_|
|**Output**|An instance of `InteractionResult` with a message about the synchronization result|

The above table is not complete meaning that the sync algorithm can throw an error at some point if something went wrong. These errors are strongly related to concrete implementations of `source` and `destination` integrations and thus are not examined.

The following activity diagram demonstrates main stages of the algorithm:

![Sync activity diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/sync_algorithm_activity_diagram.puml)

The below sections discover two main stages of the sync process ([Re-Sync In-Progress Builds](#re-sync-in-progress-builds) and [Sync Builds](#sync-builds)) but first, let's take a closer look at the controlling parameters.

#### Control Synchronization

The CI Integrations tool provides several parameters to control the parts of the sync process such as fetching coverage and in-progress builds timeout. The following table lists these parameters with their default values and descriptions.

|Name|Allowed values|Default value|Description|
|---|---|---|---|
|`--(no-)coverage`|<nobr>`true` (`--coverage`)</nobr> <br> <nobr>`false` (`--no-coverage`)</nobr>|`true`|Defines whether the CI Integrations tool should fetch coverage data for builds during the sync process. Consider the [Controlling Builds Coverage Synchronization](02_ci_integration_user_guide.md#controlling-builds-coverage-synchronization) section of the User Guide document for more information.|
|`--initial-sync-limit`|Positive integer|`28`|Defines the number of builds to sync during the very first synchronization of the specified projects. Consider the [Initial Sync Limit](02_ci_integration_user_guide.md#initial-sync-limit) section of the User Guide document for more information.|
|`--in-progress-timeout`|Positive integer|`120`|Defines a timeout duration in minutes for In-Progress builds. Consider the [Timeout In-Progress Builds](#timeout-in-progress-builds) section for more information.|

### Re-Sync In-Progress Builds

The re-sync in-progress builds stage is represented by the `InProgressBuildsSyncStage` class that implements its algorithm. This stage is to re-sync the stored In-Progress builds. These builds have the `BuildStatus.inProgress` status, and the purpose of the re-syncing is to change this status to another one, specific for finished builds, that corresponds to the status of the same build from the `source`. The algorithm performs the following steps:

1. Query builds having In-Progress status from the `destination`.
2. Re-sync each build from the list of in-progress builds:
    1. Fetch the corresponding build from the `source`.
    2. If the `source` failed to load the corresponding build:
        1. If the build exceeds the `--in-progress-timeout`, time-out the build.
        2. Otherwise, keep the in-progress build unchanged.
    3. If the corresponding build is still running:
        1. If the build exceeds the `--in-progress-timeout`, time-out the build.
        2. Otherwise, keep the in-progress build unchanged.
    4. If the corresponding build is finished:
        1. Change the status of the in-progress build to the new one.
3. Fetch the coverage data for re-synced builds if necessary.
4. Update the in-progress builds in the `destination` with new data.

The following activity diagram details the second step for a single in-progress build:

![Re-sync single build activity diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/resync_single_build_activity_diagram.puml)

More precisely, the code snippet below demonstrates the meaning of the **should force timeout** statement from the diagram. In this snippet, the `config` object is an instance of the `SyncConfig` class containing the general configurations for the current synchronization process. These configurations contains the `inProgressTimeout` value parsed from the corresponding `--in-progress-timeout` CLI option as a `Duration`.

```dart
    final now = DateTime.now();
    final duration = now.difference(build.startedAt);
    final shouldTimeout = duration >= config.inProgressTimeout;
```

Finally, the following activity diagram describes the re-sync in-progress builds stage:

![Re-sync builds stage activity diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/resync_builds_stage_activity_diagram.puml)

#### Timeout In-Progress Builds

Sometimes, the sync algorithm cannot re-sync in-progress build (for example, there is no corresponding build in the `source` anymore). In this case, this build may stay in-progress forever, and even worse, there can be many such builds so with each sync amount of builds to re-sync will grow potentially extending API load/costs dramatically.

To prevent storing a great number of in-progress builds that likely may never be re-synced, the CI Integrations tool provides an ability to force-timeout such builds. The `--in-progress-timeout` option stands for the duration in minutes. If an in-progress build exceeds this duration, it should be considered as timed out (meaning finished with the `unknown` status).

Let's consider an example to make the described process clearer.

> A user wants to sync builds from Jenkins (as a `source`) with the Firestore database (as a `destination`). There is one in-progress build in the database:
> ```json
> {
>   "buildNumber": 3,
>   "status": "BuildStatus.inProgress",
>   "duration": null
> }
> ```
> 
> However, the user has cleared Jenkins builds recently, and there no corresponding build in Jenkins anymore. In other words, the user deleted the third build in Jenkins, and the sync algorithm cannot resync this build.
>
> In this case, the following happens:
> 1. The user starts the sync process with `--in-progress-timeout=60`.
> 2. The sync algorithm queries in-progress builds from the Firestore and tries to re-sync the build with `buildNumber` equal to `3`.
> 3. The `source` fails to find the corresponding build in Jenkins.
> 4. The sync algorithm checks the current duration of the build to re-sync (the difference of `build.startedAt` and `DateTime.now()`) and compares it to the `--in-progress-timeout` value. The current duration appears to be greater than 60 minutes (let's assume `61 minutes`).
> 5. The sync algorithm updates the build object in Firestore with `BuildStatus.unknown` and the duration equal to the `build.startedAt + 60 minutes`.
> 
> So the result of re-syncing in-progress builds in the user's case is the following:
> ```json
> {
>   "buildNumber": 3,
>   "status": "BuildStatus.unknown",
>   "duration": 3660000
> }
> ```

_**Note**: If the `source` loads the corresponding build successfully but this build is still running and exceeds the specified timeout duration, the algorithm forces the in-progress build to timeout as well._

#### Timeout Edge Case

The timeout logic is supposed to use the current date and time to define whether the build should be timed out. The [`DateTime.now()`](https://api.dart.dev/stable/2.10.5/dart-core/DateTime/DateTime.now.html) constructor creates a `DateTime` instance with the current date and time using the corresponding values from the environment (i.e. a machine the code is running on). If there is a bug in the environment related to date and time or these values are forced to be incorrect, the timeout logic is likely to perform wrong.

The following cases are possible:
- The environment date and time are in the _future_. In this case, the in-progress builds will be timed out faster than expected. That may significantly affect the project metrics on the Metrics Web Application providing unreliable information about project performance and results of builds.
- The environment date and time are in the _past_. In this case, the in-progress builds will never be timed out. That may significantly increase the number of in-progress builds in the `destination`, which are likely never finish re-syncing unless the date and time are updated.

The described issues with date and time are strongly related to the environment the CI Integration tool is running on. Also, these issues are hard to detect programmatically, and attempts to solve them lead to boilerplate code. However, the mentioned problems are very unlikely and tend to be noticed very soon as they appear.

According to the noticed points, the CI Integration tool considers that the environment's date and time are correct. This means that the tool doesn't attempt to solve the possible problems related to incorrect environment's date and time. Please consider this while configuring builds syncing, or automating this process!

### Sync Builds

The second stage of the synchronization algorithm is represented by the `NewBuildsSyncStage` class that implements its algorithm. This stage is to sync new builds from the `source` to the `destination`. The purpose of this stage is to populate the `destination` database with new builds and make them available in the Metrics Web Application. The algorithm performs the following steps:

1. Fetch the last build from the `destination`.
2. If the last build is `null`:
    1. Fetch the `--initial-sync-limit` number of builds from the `source`.
3. If the last build is not `null`:
    1. Fetch builds from the `source` that were performed after the last synced build.
4. Fetch coverage data for builds if necessary.
5. Add new builds to the `destination`.

Each new build can have one of the following possible statuses:

- `inProgress` - means that the build is running.
- `successful` - means that the build has finished successfully.
- `failed` - means that the build has finished with an error.
- `unknown` - means that the build has finished with an unknown status.

_**Note**: The `unknown` status doesn't always mean that the `source` doesn't know the build's status as well. In most cases, this means that the Metrics project doesn't support the build's status and maps it to the `unknown` one._

The following activity diagram describes the sync builds stage:

![Sync builds stage activity diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/sync_builds_stage_activity_diagram.puml)

### Making Things Work

The above sections describe the sync algorithm and diagram the behavior of its parts. However, you may be wondering how these parts behave more detailed and how the sync algorithm uses integrations while running.

Let's consider the following class diagram that contains the main classes and interfaces that participate in the sync process:

![Sync algorithm class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/sync_algorithm_class_diagram.puml)

When a user starts the synchronization process, the tool creates the `CiIntegration` instance with the proper list of `SyncStage`s (`InProgressBuildsSyncStage` and `NewBuildsSyncStage` - order matters). The tool then invokes the `CiIntegration.sync` method on the created instance. This method performs sync algorithm calling the given stages in the given order.

First, the `CiIntegration.sync` calls the `InProgressBuildsSyncStage.call` method on the given stage instance. This call re-syncs in-progress builds. The sequence diagram below details the method's algorithm:

![Re-sync builds stage sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/resync_builds_stage_sequence_diagram.puml)

In the above diagram, the method `_syncInProgressBuild` re-syncs a single in-progress build returning either a new build data to store or `null` (meaning the build has no updates). The following sequence diagram explains the activity diagram for a single build from the [Re-Sync In-Progress Builds](#re-sync-in-progress-builds) section:

![Re-sync single build sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/resync_single_build_sequence_diagram.puml)

After the re-syncing process completes, the sync algorithm proceeds to the sync builds stage and calls the `NewBuildsSyncStage.call` method on the given stage instance. The sequence diagram below details the method's algorithm:

![Sync builds stage sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/sync_builds_stage_sequence_diagram.puml)

Both of the above stages uses the `BuildsSyncStage.addCoverageData` method to fetch coverage for builds if the appropriate configuration is enabled. The diagram below examines the coverage fetching for the given list of builds:

![Add coverage data sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/ci_integrations/docs/diagrams/add_coverage_data_sequence_diagram.puml)

## Results
> What was the outcome of the project?

The design describing the synchronization algorithm in detail.
