import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping statuses of Github Actions
/// [WorkflowRun]s.
class RunStatusMapper implements Mapper<String, RunStatus> {
  /// A status for a queued workflow run.
  static const String queued = 'queued';

  /// A status for a workflow run that is in progress.
  static const String inProgress = 'in_progress';

  /// A status for a completed workflow run.
  static const String completed = 'completed';

  /// Creates a new instance of the [RunStatusMapper].
  const RunStatusMapper();

  @override
  RunStatus map(String status) {
    switch (status) {
      case queued:
        return RunStatus.queued;
      case inProgress:
        return RunStatus.inProgress;
      case completed:
        return RunStatus.completed;
      default:
        return null;
    }
  }

  @override
  String unmap(RunStatus status) {
    switch (status) {
      case RunStatus.queued:
        return queued;
      case RunStatus.inProgress:
        return inProgress;
      case RunStatus.completed:
        return completed;
      default:
        return null;
    }
  }
}
