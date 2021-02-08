// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Github Actions conclusions.
class GithubActionConclusionMapper
    implements Mapper<String, GithubActionConclusion> {
  /// A Github Actions successful conclusion.
  static const String success = 'success';

  /// A Github Actions failed conclusion.
  static const String failure = 'failure';

  /// A Github Actions neutral conclusion.
  static const String neutral = 'neutral';

  /// A Github Actions cancelled conclusion.
  static const String cancelled = 'cancelled';

  /// A Github Actions skipped conclusion.
  static const String skipped = 'skipped';

  /// A Github Actions timed out conclusion.
  static const String timedOut = 'timed_out';

  /// A Github Actions action required conclusion.
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
