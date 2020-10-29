import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:metrics_core/metrics_core.dart';

class GithubActionsTestDataGenerator {
  final String workflowIdentifier;
  final String jobName;
  final String coverageArtifactName;
  final Percent coverage;
  final String url;
  final DateTime startDateTime;
  final DateTime completeDateTime;
  final Duration duration;

  GithubActionsTestDataGenerator({
    this.workflowIdentifier,
    this.jobName,
    this.coverageArtifactName,
    this.coverage,
    this.url,
    this.startDateTime,
    this.completeDateTime,
    this.duration,
  });

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

  List<WorkflowRun> generateWorkflowRunsByNumbers({
    List<int> runNumbers = const [],
  }) {
    return runNumbers.map((runNumber) {
      return generateWorkflowRun(runNumber: runNumber);
    }).toList();
  }

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

  List<WorkflowRunJob> generateWorkflowRunJobsList(int length) {
    return List.generate(length, (_) => generateWorkflowRunJob());
  }

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

  List<BuildData> generateBuildsByNumbers({
    List<int> buildNumbers = const [],
  }) {
    return buildNumbers.map((number) {
      return generateBuildData(buildNumber: number);
    }).toList();
  }

  List<BuildData> generateBuildsByStatuses({
    List<BuildStatus> statuses = const [],
  }) {
    return statuses.map((status) {
      return generateBuildData(buildStatus: status);
    }).toList();
  }
}
