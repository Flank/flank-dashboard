// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that represents a Sentry project.
class SentryProject {
  /// An identifier of the Sentry organization this project belongs to.
  final String organizationSlug;

  /// An identifier of this Sentry project.
  final String projectSlug;

  /// Creates a new instance of the [SentryProject]
  /// with the given [organizationSlug] and [projectSlug].
  ///
  /// Throws an [ArgumentError] if the given [organizationSlug] is `null`.
  /// Throws an [ArgumentError] if the given [projectSlug] is `null`.
  SentryProject({
    this.organizationSlug,
    this.projectSlug,
  }) {
    ArgumentError.checkNotNull(organizationSlug, 'organizationSlug');
    ArgumentError.checkNotNull(projectSlug, 'projectSlug');
  }
}
