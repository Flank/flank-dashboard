# Sync Performance Investigation

The CI Integrations tool stands for builds synchronization for the specified projects. The tool consumes and parses a configuration file, initializes the required source and destination integrations, and orchestrates them to synchronize builds. To know more about the CI Integrations tool and how it works, consider the tool's [documentation](https://github.com/platform-platform/monorepo/tree/master/metrics/ci_integrations/docs).

## Problem Statement

As the CI Integrations tool makes the synchronized builds available on the Metrics Web Application, one may want to monitor builds and the related project's metrics as soon as possible. To make it possible, the tool synchronizes in-progress builds as well as the finished ones. Thus, one can automate builds synchronization by triggering it when a build is started. However, it appears that a pipeline for build synchronization may take too long to finish. Sometimes even longer than the whole build. In this document, we'll try to discover reasons for such behavior and possible solutions to reduce sync time.

The following timing diagram demonstrates the desired behavior for a build syncing:

![Ideal timing diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/sync_perf_investigate/metrics/ci_integrations/docs/diagrams/sync_ideal_timing_diagram.puml)

But the actual behavior differs from the expected as the build sync can take too long and may cause the problems demonstrated in the diagrams below. The first case demonstrates the long-running sync when a build is started causing the finishing sync to appear far after the build is finished. The second example demonstrates the long-running sync as well but in this case, we have two runners for builds syncing. In the second diagram, the starting sync takes too long and finishes at the same time as the finishing build causing. The UI doesn't display this build as running, or display for a few seconds, though the build may take longer.

![problematic queue timing diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/sync_perf_investigate/metrics/ci_integrations/docs/diagrams/sync_problematic_queue_timing_diagram.puml)

![problematic timing diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/sync_perf_investigate/metrics/ci_integrations/docs/diagrams/sync_problematic_timing_diagram.puml)

## Sync Command Performance

First, let's measure the performance of the builds synchronization itself. As the problem is generally related to synchronizing one build, we focus on the sync time for one build. Also, the below investigation assumes that the following holds:

- the target CI pipeline has builds (i.e. runs);
- the target destination project has no builds (initial sync is performed);
- the CI integration tool is pre-installed and needs no time to start (starts performing immediately).

To test one build synchronization, we use the following command:

```bash
ci_integrations sync --config-file=config.yaml --initial-sync-limit=1 --no-coverage
```

The idea is to test the syncing of build data itself without fetching any coverage data to simulate in-progress build syncing. The `config.yaml` file contains configurations for either Buildkite or GitHub Actions as a `source`. Also, the configuration file is ready to use meaning that we shouldn't evaluate it with environment variables.

The below subsections contain investigation results for different sources. Let's take a look at what the different timing sections mean:

- **Starting** represents the duration of the tool's starting time that includes parsing a configuration file, creating appropriate clients, etc., and before the sync is started.
- **Fetching** represents the duration of fetching builds from the source that are to be synced.
- **Adding** represents the duration of adding builds to the destination.
- **Efficient** represents the duration of tasks performed by the tool that satisfies our purpose (the sum of **Starting**, **Fetching**, and **Adding** durations).
- **Full** represents the execution duration of the tool from start to exit.

### GitHub Actions

To test the GitHub Actions integration performance we use the configuration file `config.yaml` that contains the source configurations for GitHub Actions API. After each trial, the destination database is cleared up from builds just like the trial is never happened.

The following table contains the average duration in milliseconds for different sections. The experiment consists of ten different trials resulting in a sample. The _Average_ row contains the [arithmetic mean](https://en.wikipedia.org/wiki/Arithmetic_mean) of durations for each timing section.

||Starting|Fetching|Adding|Efficient|Full|
|---|---|---|---|---|----|
|_Average_|420,9 ms|1077,8 ms|339,5 ms|1838,2 ms|2366,4 ms|

### Buildkite

To test the Buildkite integration performance we use the configuration file `config.yaml` that contains the source configurations for Buildkite API. After each trial, the destination database is cleared up from builds just like the trial is never happened.

The following table contains the average duration in milliseconds for different sections. The experiment consists of ten different trials resulting in a sample. The _Average_ row contains the [arithmetic mean](https://en.wikipedia.org/wiki/Arithmetic_mean) of durations for each timing section.

||Starting|Fetching|Adding|Efficient|Full|
|---|---|---|---|---|----|
|_Average_|404,2 ms|1504,8 ms|244,1 ms|2153,1 ms|2646,8 ms|

### Analysis

The execution duration changes depending on the real distance between the CI Integrations tool runner and the CI's API server (request-response time). Running the CI Integration tool on a local machine in East Europe leads to the above results. Also, the network connection quality affects the request-response time and may cause the tool execution to take too long.

Analyzing the real cases for one-build synchronization demonstrates the following result for **GitHub Actions** (similar to the above experiments, we average ten different trials but for different builds and with enabled coverage fetching):

||Full|
|---|---|
|_Average_|3000 ms|

Although the above results are consistent, the algorithm itself may require improvements. Let's take a look at the average results for five synchronization trials of 100 builds.

||Starting|Fetching|Adding|Efficient|Full|
|---|---|---|---|---|----|
|_GitHub Actions_|420,6 ms|31902,2 ms|12733 ms|45055,8 ms|45608,2 ms|
|_Buildkite_|557,2 ms|4347,2 ms|11339 ms|16243,4 ms|16674,2 ms|

As we can see, the GitHub Actions integration demonstrates significantly greater execution time than the Buildkite one. This may be related to the GitHub Actions API limitations and structure.

So, we admit that the one-build synchronization executes in a reasonable time. However, the algorithm requires review for different integrations on syncing a big number of builds.

## Sync Command Performance in CI

The above section examines the sync execution time for one-build synchronization and admits this time as reasonable. However, the performed experiments demonstrate results for running the CI Integration tool on a local machine. In reality, if we want to [automate builds synching](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/02_ci_integration_user_guide.md#automating-ci-integrations), we face the sync-time problem. In the below subsections, we discover the problem for each CI integration and try to figure out what causes the problem.

### GitHub Actions

The GitHub Actions job that synchronizes builds performs the following steps:

1. Set up job.
2. Checkout the repository.
3. Download the CI Integration tool.
4. Wait for the build to finish.
5. Apply environment variables to the configuration file.
6. Synchronize builds data.
7. Post Checkout clean up.
8. Complete job.

The initial step and the two last are performed automatically - the job specification lists only steps from 2 to 6. Also, we should note that the 4th step is performed only if the sync workflow should sync the finished build. Otherwise, the 3rd step is skipped. More precisely, this means that if the workflow is dispatched with the `build_started` event, the job shouldn't wait for a build to finish as the sync is performed for the running build. On the other hand, if the workflow is dispatched with the `build_finished` event, the job should wait for the build to finish before performing sync.

Although the job performs two additional steps after the sync is finished, they don't matter as the build is already synced. The steps that precede the synchronization influence the time spent for a new build to be available in the destination database and appear on the Metrics Web Application. Therefore, we focus on steps from the initial to the sync step itself (1-6).

The following table contains the information about the execution time of each step of the sync job. The original sample contains eleven objects representing a single job run each. Please note that the value `0 s` (zero seconds) means `close to 0s` - the reason is that GitHub Actions API and web UI don't provide the precise value in milliseconds.

||Setup|Checkout|Download|Wait|Configure|Sync|
|---|---|---|---|---|---|---|
|_Average_|7,18 s|12,91 s|1,91 s|1,27 s|0,18 s|3,27 s|
|_Trimmed mean_|5,44 s|9,11 s|1,89 s|0,44 s|0,11 s|3,33 s|
|_Max_|28 s|58 s|4 s|10 s|1 s|4 s|
|_Min_|2 s|2 s|0 s|0 s|0 s|2 s|
|_Median_|3 s|3 s|2 s|0 s|0 s|3 s|
|_Mode_|3 s|3 s|1 s|0 s|0 s|4 s|

In the table above we must use the trimmed mean (more precisely, [interquartile mean](https://en.wikipedia.org/wiki/Interquartile_mean) in this case) to demonstrate that the sample contains some extreme values. These extreme values mostly occur as a setup, checkout, or wait steps execution time. Consider the _max_, _min_, [_median_](https://en.wikipedia.org/wiki/Median), and [_mode_](https://en.wikipedia.org/wiki/Mode_(statistics)) rows to know more about values' distribution.

Generally speaking, if _risky steps_ (setup, checkout, and wait) demonstrate good performance (as for _mode_ value), the sync job executes in around `15 seconds`.

### Buildkite

The Buildkite pipeline that synchronizes builds performs the following steps:

1. Upload sync pipeline (checkout, define steps).
2. Logs the synced project.
3. Synchronize builds data.
    1. Installs the `curl` tool.
    2. Download the CI Integration tool.
    3. Apply environment variables to the configuration file.
    4. Run synchronization.

Unlike GitHub Actions, the Buildkite sync pipeline is configured with as few steps as possible. The reason is that each step runs on its working directory and the agent (i.e. pipeline runner) spends some time preparing this directory for the step. Thus, the list above should be considered as the list of steps each beginning with the working directory preparation. And the nested list in the third step is the list of commands performed as a part of this step.

The following table contains the information about the execution time of each step of the sync pipeline. The original sample consists of ten objects representing a single pipeline run each.

||Upload|Log|Sync|
|---|---|---|---|
|_Average_|3,36 s|2,36 s|25,82 s|
|_Trimmed mean_|3,22 s|2,22 s|25,44 s|
|_Max_|5 s|4 s|31 s|
|_Min_|3 s|2 s|24 s|
|_Median_|3 s|2 s|26 s|
|_Mode_|3 s|2 s|26 s|

As we can see from the table above, the synchronization pipeline is pretty stable. The execution time values for different sync runs are distributed around the average value with a small variance. On average, the sync pipeline executes in around `32 seconds`.

### Analysis

As we can see from the sections above, the synchronization time strongly depends on the pipeline structure and a CI tool. A Buildkite pipeline is more stable than a GitHub Actions job but takes longer. The GitHub Actions job performs faster but some steps have unexpected behavior and may cause a significant delay.

Both integrations could be optimized to run the sync faster. However, the appropriate GitHub Actions job requires changing a pipeline in a way to prevent checking out a repository. This will remove a risky step from the job and therefore speed it up on average.

For the Buildkite CI, the pipeline should be updated to avoid unnecessary steps as logging. Also, it is possible to optimize the pipeline by pre-installing `curl` and CI Integrations tool by creating an appropriate Docker image.

## Conclusions

Taking into account the results of the investigation, we can state the following:

1. The synchronization algorithm takes a reasonable time for one-build syncing but should be reviewed for different integrations for many-builds syncing.
2. The synchronization time strongly depends on the pipeline structure and a CI tool.
3. The synchronization pipelines and jobs can be optimized by removing unnecessary steps and reducing the required ones.
