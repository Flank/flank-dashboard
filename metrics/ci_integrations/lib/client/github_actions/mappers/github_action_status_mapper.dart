// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Github Actions statuses.
class GithubActionStatusMapper implements Mapper<String, GithubActionStatus> {
  /// A queued Github Actions status.
  static const String queued = 'queued';

  /// A Github Action status that indicates the in-progress state.
  static const String inProgress = 'in_progress';

  /// A completed Github Actions status.
  static const String completed = 'completed';

  /// Creates a new instance of the [GithubActionStatusMapper].
  const GithubActionStatusMapper();

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
