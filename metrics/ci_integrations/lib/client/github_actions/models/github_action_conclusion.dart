/// Represents a Github Actions conclusion.
enum GithubActionConclusion {
  /// Represents a conclusion of a successful workflow run job.
  success,

  /// Represents a conclusion of a failed workflow run job.
  failure,

  /// Represents a neutral conclusion for a workflow run job.
  neutral,

  /// Represents a conclusion for a cancelled workflow run job.
  cancelled,

  /// Represents a conclusion for a skipped workflow run job.
  skipped,

  /// Represents a conclusion for a timed out workflow run job.
  timedOut,

  /// Represents a conclusion for a workflow run job that requires an action.
  actionRequired,
}
