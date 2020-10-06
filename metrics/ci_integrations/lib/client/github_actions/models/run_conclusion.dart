/// Represents a conclusion of a [WorkflowRun].
enum RunConclusion {
  /// Represents a conclusion of a successful workflow run.
  success,

  /// Represents a conclusion of a failed workflow run.
  failure,

  /// Represents a neutral conclusion for a workflow run.
  neutral,

  /// Represents a conclusion for a cancelled workflow run.
  cancelled,

  /// Represents a conclusion for a skipped workflow run.
  skipped,

  /// Represents a conclusion for a timed out workflow run.
  timedOut,

  /// Represents a conclusion for a workflow run that requires an action.
  actionRequired,
}
