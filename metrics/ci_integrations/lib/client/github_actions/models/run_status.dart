/// Represents a status of a [WorkflowRun].
enum RunStatus {
  /// Represents a status for a queued workflow run.
  queued,

  /// Represents a status for a workflow run that is in progress.
  inProgress,

  /// Represents a status for a completed workflow run.
  completed,
}
