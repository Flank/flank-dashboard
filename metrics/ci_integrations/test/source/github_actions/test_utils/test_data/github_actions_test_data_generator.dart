// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that contains methods for generating Github Actions test data
/// to use in tests.
/// 
/// The generator uses the values it is initialized with as the default values 
/// to the data being generated.
class GithubActionsTestDataGenerator {
  /// A workflow identifier to use in this test data generator.
  final String workflowIdentifier;

  /// A job name to use in this test data generator.
  final String jobName;

  /// A coverage artifact name to use in this test data generator.
  final String coverageArtifactName;

  /// A [Percent] coverage to use in this test data generator.
  final Percent coverage;

  /// A url to use in this test data generator.
  final String url;

  /// A start [DateTime] to use in this test data generator.
  final DateTime startDateTime;

  /// A completion [DateTime] to use in this test data generator.
  final DateTime completeDateTime;

  /// A [Duration] to use in this test data generator.
  final Duration duration;
  
  /// Creates a new instance of the [GithubActionsTestDataGenerator].
  const GithubActionsTestDataGenerator({
    this.workflowIdentifier,
    this.jobName,
    this.coverageArtifactName,
    this.coverage,
    this.url,
    this.startDateTime,
    this.completeDateTime,
    this.duration,
  });
  
  /// Generates a [WorkflowRun] instance using the given parameters 
  /// and default values.
  /// 
  /// The [id] defaults to `1`.
  /// The [runNumber] defaults to `1`.
  /// The [status] defaults to [GithubActionStatus.completed].
  WorkflowRun generateWorkflowRun({
    int id = 1,
    int runNumber = 1,
    GithubActionStatus status = GithubActionStatus.completed,
  }) {
    return WorkflowRun(
      id: id,
      number: runNumber,
      url: url,
      status: GithubActionStatus.completed,
      createdAt: startDateTime,
    );
  }

  /// Generates a list of [WorkflowRun]s using the given [runNumbers].
  /// 
  /// The [runNumbers] defaults to an empty list.
  List<WorkflowRun> generateWorkflowRunsByNumbers({
    List<int> runNumbers = const [],
  }) {
    return runNumbers.map((runNumber) {
      return generateWorkflowRun(id: runNumber, runNumber: runNumber);
    }).toList();
  }
  
  /// Generates a [WorkflowRunJob] instance using the given parameters 
  /// and default values.
  /// 
  /// The [id] defaults to `1`.
  /// The [runId] defaults to `1`.
  /// The [status] defaults to [GithubActionStatus.completed].
  /// The [conclusion] defaults to [GithubActionConclusion.success].
  WorkflowRunJob generateWorkflowRunJob({
    int id = 1,
    int runId = 1,
    GithubActionStatus status = GithubActionStatus.completed,
    GithubActionConclusion conclusion = GithubActionConclusion.success,
  }) {
    return WorkflowRunJob(
      id: id,
      runId: runId,
      name: jobName,
      url: url,
      status: status,
      conclusion: conclusion,
      startedAt: startDateTime,
      completedAt: completeDateTime,
    );
  }

  /// Generates a list of [WorkflowRunJob]s using the given [conclusions].
  /// 
  /// The [conclusions] defaults to an empty list.
  List<WorkflowRunJob> generateWorkflowRunJobsByConclusions({
    List<GithubActionConclusion> conclusions = const [],
  }) {
    return conclusions
        .map((conclusion) => generateWorkflowRunJob(conclusion: conclusion))
        .toList();
  }
  
  /// Generates a list of [WorkflowRunJob]s with the given [length].
  List<WorkflowRunJob> generateWorkflowRunJobsList(int length) {
    return List.generate(length, (_) => generateWorkflowRunJob());
  }

  /// Generates a [BuildData] instance using the given parameters 
  /// and default values.
  /// 
  /// The [buildStatus] defaults to the [BuildStatus.successful].
  BuildData generateBuildData({
    int buildNumber,
    BuildStatus buildStatus = BuildStatus.successful,
  }) {
    return BuildData(
      buildNumber: buildNumber,
      startedAt: startDateTime,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: jobName,
      url: url,
      coverage: coverage,
    );
  }

  /// Generates a list of [BuildData] using the given [buildNumbers].
  /// 
  /// The [buildNumbers] defaults to an empty list.
  List<BuildData> generateBuildDataByNumbers({
    List<int> buildNumbers = const [],
  }) {
    return buildNumbers.map((number) {
      return generateBuildData(buildNumber: number);
    }).toList();
  }

  /// Generates a list of [BuildData] using the given [statuses].
  /// 
  /// The [statuses] defaults to an empty list.
  List<BuildData> generateBuildDataByStatuses({
    List<BuildStatus> statuses = const [],
  }) {
    final result = <BuildData>[];

    for (int i = 0; i < statuses.length; ++i) {
      result.add(
        generateBuildData(buildNumber: i + 1, buildStatus: statuses[i]),
      );
    }

    return result;
  }
}
