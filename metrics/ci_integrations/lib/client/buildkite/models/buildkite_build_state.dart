// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// Represents a state for a Buildkite build.
enum BuildkiteBuildState {
  /// Represents a state for a build that is in progress.
  running,

  /// Represents a state for a scheduled build.
  scheduled,

  /// Represents a state for a successfully passed build.
  passed,

  /// Represents a state for a failed build.
  failed,

  /// A shortcut state uses to automatically search for builds which are blocked
  /// by a pipeline step.
  blocked,

  /// Represents a state for a canceled build.
  canceled,

  /// Represents a state for a build that is being canceled.
  canceling,

  /// Represents a state for a skipped build.
  skipped,

  /// Represents a state for a build that has never run.
  notRun,

  /// A shortcut state uses to automatically search for builds with passed,
  /// failed, blocked, canceled states.
  finished
}
