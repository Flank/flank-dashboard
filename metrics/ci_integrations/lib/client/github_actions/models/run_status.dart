/// Represents the status of a [WorkflowRun].
enum RunStatus {
  /// A status for a queued workflow run.
  queued,

  /// A status for a workflow run that is in progress.
  inProgress,

  /// A status for a completed workflow run.
  completed,
}
