// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// Enum that represents the Jenkins build result.
enum JenkinsBuildResult {
  /// Indicates that the build was manually aborted.
  aborted,

  /// Indicates that the module was not built.
  ///
  /// This status is used in a multi-stage build (like maven2)
  /// where a problem in an earlier stage prevented later stages from building.
  notBuild,

  /// Indicates that the build had a fatal error.
  failure,

  /// Indicates that the build had some errors but they were not fatal.
  unstable,

  /// Indicates that the build had no errors.
  success,
}
