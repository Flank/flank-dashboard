/// Represents the conclusion of a [WorkflowRun].
enum RunConclusion {
  success,
  failure,
  neutral,
  cancelled,
  skipped,
  timedOut,
  actionRequired,
}
