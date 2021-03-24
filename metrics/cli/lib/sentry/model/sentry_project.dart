/// A class that represents slugs for the Sentry project.
class SentryProject {
  /// The identifier of the Sentry organization.
  final String organizationSlug;

  /// The identifier of the Sentry project.
  final String projectSlug;

  /// Creates a new instance of the [SentryProject]
  /// with the given [organizationSlug] and [projectSlug].
  SentryProject(this.organizationSlug, this.projectSlug);
}
