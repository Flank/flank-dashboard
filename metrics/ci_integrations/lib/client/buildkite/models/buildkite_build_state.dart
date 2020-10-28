/// Represents a Buildkite status.
enum BuildkiteBuildState {
  /// Represents a status for a build that is in progress.
  running,

  /// Represents a status for a scheduled build.
  scheduled,

  /// Represents a status for a successful finished build.
  passed,

  /// Represents a status for a failed build.
  failed,

  /// Represents a status for a build that has blocked by another one.
  blocked,

  /// Represents a status for a canceled build.
  canceled,

  /// Represents a status for a canceling build.
  canceling,

  /// Represents a status for a skipped build.
  skipped,

  /// Represents a status for a build that has never run.
  notRun,

  /// Represents a status for a finished build.
  finished
}
