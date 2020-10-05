/// Represents the conclusion of a [WorkflowRun].
enum RunConclusion {
  /// Represents the conclusion of a successful workflow run.
  success,

  /// Represents the conclusion of a failed workflow run.
  failure,

  /// A neutral conclusion for a workflow run.
  neutral,

  /// A conclusion for a cancelled workflow run.
  cancelled,

  /// A conclusion for a skipped workflow run.
  skipped,

  /// A conclusion for a timed out workflow run.
  timedOut,

  /// A conclusion for a workflow run that requires an action.
  actionRequired,
}
