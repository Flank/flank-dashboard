import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping statuses of Github Actions
/// [WorkflowRun]s.
class RunStatusMapper implements Mapper<String, GithubActionStatus> {
  /// A status for a queued workflow run.
  static const String queued = 'queued';

  /// A status for a workflow run that is in progress.
  static const String inProgress = 'in_progress';

  /// A status for a completed workflow run.
  static const String completed = 'completed';

  /// Creates a new instance of the [RunStatusMapper].
  const RunStatusMapper();

  @override
  GithubActionStatus map(String status) {
    switch (status) {
      case queued:
        return GithubActionStatus.queued;
      case inProgress:
        return GithubActionStatus.inProgress;
      case completed:
        return GithubActionStatus.completed;
      default:
        return null;
    }
  }

  @override
  String unmap(GithubActionStatus status) {
    switch (status) {
      case GithubActionStatus.queued:
        return queued;
      case GithubActionStatus.inProgress:
        return inProgress;
      case GithubActionStatus.completed:
        return completed;
      default:
        return null;
    }
  }
}
