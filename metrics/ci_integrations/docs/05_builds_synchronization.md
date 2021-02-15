# Builds Synchronization

## Introduction

The CI Integration tool synchronizes builds to make them available for the Metrics Web Application. The algorithm of synchronization fetches builds from the `source` and stores them to the `destination`. This document examines this algorithm to make it more clear and clarify the details of builds synchronization.

## References
> Link to supporting documentation, GitHub tickets, etc.

Links on other documents for CI Integrations tool, project Metrics available, etc.

## Goals
> Identify success metrics and measurable goals.

- Describe the synchronization algorithm.
- Describe In-Progress builds re-syncing.
- Describe how the sync algorithm uses `Source` and `Destination` integrations.

## Non-Goals
> Identify what's not in scope.

The following points are out of the scope for this document:
- The way the Metrics Web Application display synced builds and project metrics.
- The implementation for concrete `Source` and `Destination` integrations.


## Design
> Explain and diagram the technical design.

The following sections cover the synchronization algorithm of the CI Integration tool and its different concepts. To get more familiar with CI Integration tool, its usage and architecture consider the [CI Integration Module Architecture](01_ci_integration_module_architecture.md) and [CI Integration User Guide](02_ci_integration_user_guide.md) documents.

### Synchronization Algorithm

The synchronization is performed by the `CiIntegration.sync` method that orchestrates the specified `source` and `destination` clients. To describe an algorithm, let's first define its input and output as in the following table:

||Description|
|--|--|
|**Input**|An instance of `SyncConfig` with project identifiers for both `source` and `destination`, and _sync parameters_|
|**Output**|An instance of `InteractionResult` with a message about the synchronization result|

The above table is not complete meaning that the sync algorithm can throw an error at some point if something went wrong. These errors are strongly related to concrete implementations of `source` and `destination` integrations and thus are not examined.

The following activity diagram demonstrates steps the algorithm performs:

![Sync activity diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/ci_integrations_sync_doc/metrics/ci_integrations/docs/diagrams/sync_algorithm_activity_diagram.puml)

The below sections discovers two main parts of the sync process ([Re-Sync In-Progress Builds](#re-sync-in-progress-builds) and [Sync Builds](#sync-builds)) but first, let's take a closer look at controlling parameters.

#### Control Synchronization

The CI Integrations tool provides several parameters to control the parts of sync process such as fetching coverage and in-progress builds timeout. The following table lists these parameters with their default values and descriptions.

|Name|Allowed values|Default value|Description|
|---|---|---|---|
|`--(no-)coverage`|<nobr>`true` (`--coverage`)</nobr> <br> <nobr>`false` (`--no-coverage`)</nobr>|`true`|Defines whether the CI Integrations tool should fetch coverage data for builds during the sync process. Consider the [Controlling Builds Coverage Synchronization](02_ci_integration_user_guide.md#controlling-builds-coverage-synchronization) section of the User Guide document for more information.|
|`--initial-sync-limit`|Positive integer|`28`|Defines a number of builds to sync during the very first synchronization of the specified projects. Consider the [Initial Sync Limit](02_ci_integration_user_guide.md#initial-sync-limit) section of the User Guide document for more information.|
|`--in-progress-timeout`|Positive integer|`120`|Defines a timeout for In-Progress builds. Consider the [Timeout In-Progress Builds](#timeout-in-progress-builds) section for more information.|

### Re-Sync In-Progress Builds

The first stage of the synchronization algorithm is to re-sync the store In-Progress builds. These builds have the`BuildStatus.inProgress` status, and the purpose of the re-syncing is to change this status to another one, specific for finished builds, that corresponds to status of the same build from the `source`. The algorithm performs the following steps:

1. Query builds having In-Progress status from the `destination`.
2. Re-sync each build from the list of in-progress:
    1. Fetch the corresponding build from the `source`.
    2. Change the status of the build to the new from the `source` or force timeout if the build exceeds the `--in-progress-timeout`.
    3. Fetch the build's coverage data if necessary.
3. Update the in-progress builds in the `destination` with new data.

You may find the second sub-step a bit tricky, and it is. The reason is that there are some edge cases for in-progress builds. Consider the following possibilities: 

- There are no corresponding build in the `source`. In this case, the algorithm skips checking a new status or timeout duration - the build is considered as finished with unknown status.
- The corresponding build in the `source` is still running. In this case, the algorithm checks whether the build exceeds the specified `--in-progress-timeout`. If yes, the build is considered as finished with unknown status. Otherwise, the build stays unchanged.

The following activity diagram describes the re-sync in-progress builds stage:

ci_integrations_sync_doc
![Re-sync stage activity diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/ci_integrations_sync_doc/metrics/ci_integrations/docs/diagrams/resync_stage_activity_diagram.puml)

Points to cover here: 
- How does the In-Progress build look like?
- What data is always missing for running build?
- What changes to Firestore Security rules should be performed?
- Note that the problem with in-progress builds is that they should be re-synced - smoothly introduce the next section with sync algorithm updates.

#### Timeout In-Progress Builds

Points to cover here: 
- How to force In-Progress build to finish if it cannot be re-synced?
- What the status of `force timed out builds`?
- How to fill missing data for such builds? 
- Finalize activity diagram here.

### Sync Builds


### Making Things Work

Points to cover here: 
- How all the components work together? 
- Sequence diagram to clarify steps in activity one and make them more clear.

## Results
> What was the outcome of the project?

The design describing the synchronization algorithms in details.
