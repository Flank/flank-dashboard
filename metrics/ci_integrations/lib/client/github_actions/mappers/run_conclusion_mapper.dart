import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping conclusions of
/// Github Actions [WorkflowRunJob]s.
class GithubActionConclusionMapper
    implements Mapper<String, GithubActionConclusion> {
  /// A conclusion for a successful workflow run job.
  static const String success = 'success';

  /// A conclusion for a failed workflow run job.
  static const String failure = 'failure';

  /// A neutral conclusion for a workflow run job.
  static const String neutral = 'neutral';

  /// A conclusion for a cancelled workflow run job.
  static const String cancelled = 'cancelled';

  /// A conclusion for a skipped workflow run job.
  static const String skipped = 'skipped';

  /// A conclusion for a timed out workflow run job.
  static const String timedOut = 'timed_out';

  /// A conclusion for a workflow run job that requires an action.
  static const String actionRequired = 'action_required';

  /// Creates a new instance of the [GithubActionConclusionMapper].
  const GithubActionConclusionMapper();

  @override
  GithubActionConclusion map(String conclusion) {
    switch (conclusion) {
      case success:
        return GithubActionConclusion.success;
      case failure:
        return GithubActionConclusion.failure;
      case neutral:
        return GithubActionConclusion.neutral;
      case cancelled:
        return GithubActionConclusion.cancelled;
      case skipped:
        return GithubActionConclusion.skipped;
      case timedOut:
        return GithubActionConclusion.timedOut;
      case actionRequired:
        return GithubActionConclusion.actionRequired;
      default:
        return null;
    }
  }

  @override
  String unmap(GithubActionConclusion conclusion) {
    switch (conclusion) {
      case GithubActionConclusion.success:
        return success;
      case GithubActionConclusion.failure:
        return failure;
      case GithubActionConclusion.neutral:
        return neutral;
      case GithubActionConclusion.cancelled:
        return cancelled;
      case GithubActionConclusion.skipped:
        return skipped;
      case GithubActionConclusion.timedOut:
        return timedOut;
      case GithubActionConclusion.actionRequired:
        return actionRequired;
      default:
        return null;
    }
  }
}
