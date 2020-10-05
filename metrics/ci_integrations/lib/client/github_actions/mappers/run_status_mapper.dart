import 'package:ci_integration/client/github_actions/models/run_status.dart';

/// A class that provides methods for mapping Github Actions workflow run status.
class RunStatusMapper {
  /// A constant for the `queued` status of a Github Actions workflow run.
  static const String queued = 'queued';

  /// A constant for the `in_progress` status of a Github Actions workflow run.
  static const String inProgress = 'in_progress';

  /// A constant for the `completed` status of a Github Actions workflow run.
  static const String completed = 'completed';

  /// Creates a new instance of the [RunStatusMapper].
  const RunStatusMapper();

  /// Maps the [runStatus] of a Github Actions workflow run to the [RunStatus].
  RunStatus map(String runStatus) {
    switch (runStatus) {
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

  /// Maps the [runStatus] of Github Actions Workflow run to the form of
  /// Github Actions API.
  String unmap(RunStatus runStatus) {
    switch (runStatus) {
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
