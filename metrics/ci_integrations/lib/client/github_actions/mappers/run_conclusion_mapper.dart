import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';

/// A class that provides methods for mapping Github Actions workflow run
/// conclusion.
class RunConclusionMapper {
  /// A constant for the `success` conclusion of a Github Actions workflow run.
  static const String success = 'success';

  /// A constant for the `failure` conclusion of a Github Actions workflow run.
  static const String failure = 'failure';

  /// A constant for the `neutral` conclusion of a Github Actions workflow run.
  static const String neutral = 'neutral';

  /// A constant for the `cancelled` conclusion of a Github Actions workflow run.
  static const String cancelled = 'cancelled';

  /// A constant for the `skipped` conclusion of a Github Actions workflow run.
  static const String skipped = 'skipped';

  /// A constant for the `timed_out` conclusion of a Github Actions workflow run.
  static const String timedOut = 'timed_out';

  /// A constant for the `action_required` conclusion of a Github Actions
  /// workflow run.
  static const String actionRequired = 'action_required';

  /// Creates a new instance of the [RunConclusionMapper].
  const RunConclusionMapper();

  /// Maps the [runConclusion] of a Github Actions workflow run to the
  /// [RunConclusion].
  RunConclusion map(String runConclusion) {
    switch (runConclusion) {
      case success:
        return RunConclusion.success;
      case failure:
        return RunConclusion.failure;
      case neutral:
        return RunConclusion.neutral;
      case cancelled:
        return RunConclusion.cancelled;
      case skipped:
        return RunConclusion.skipped;
      case timedOut:
        return RunConclusion.timedOut;
      case actionRequired:
        return RunConclusion.actionRequired;
      default:
        return null;
    }
  }

  /// Maps the [runConclusion] of Github Actions Workflow run to the form of
  /// Github Actions API.
  String unmap(RunConclusion runConclusion) {
    switch (runConclusion) {
      case RunConclusion.success:
        return success;
      case RunConclusion.failure:
        return failure;
      case RunConclusion.neutral:
        return neutral;
      case RunConclusion.cancelled:
        return cancelled;
      case RunConclusion.skipped:
        return skipped;
      case RunConclusion.timedOut:
        return timedOut;
      case RunConclusion.actionRequired:
        return actionRequired;
      default:
        return null;
    }
  }
}
