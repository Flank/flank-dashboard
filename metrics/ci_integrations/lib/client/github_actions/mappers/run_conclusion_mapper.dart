import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping conclusions of
/// Github Actions [WorkflowRun]s.
class RunConclusionMapper implements Mapper<String, RunConclusion> {
  /// A conclusion for a successful workflow run.
  static const String success = 'success';

  /// A conclusion for a failed workflow run.
  static const String failure = 'failure';

  /// A neutral conclusion for a workflow run.
  static const String neutral = 'neutral';

  /// A conclusion for a cancelled workflow run.
  static const String cancelled = 'cancelled';

  /// A conclusion for a skipped workflow run.
  static const String skipped = 'skipped';

  /// A conclusion for a timed out workflow run.
  static const String timedOut = 'timed_out';

  /// A conclusion for a workflow run that requires an action.
  static const String actionRequired = 'action_required';

  /// Creates a new instance of the [RunConclusionMapper].
  const RunConclusionMapper();

  @override
  RunConclusion map(String conclusion) {
    switch (conclusion) {
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

  @override
  String unmap(RunConclusion conclusion) {
    switch (conclusion) {
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
