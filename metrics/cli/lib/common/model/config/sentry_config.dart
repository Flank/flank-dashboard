// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a Sentry configuration.
class SentryConfig extends Equatable {
  /// A Sentry access token that is used to authenticate CLI requests.
  final String authToken;

  /// A unique identifier of the Sentry organization.
  final String organizationSlug;

  /// A unique identifier of the Sentry project.
  final String projectSlug;

  /// A Sentry project DSN.
  final String projectDsn;

  /// A name of the Sentry release.
  final String releaseName;

  @override
  List<Object> get props => [
        authToken,
        organizationSlug,
        projectSlug,
        projectDsn,
        releaseName,
      ];

  /// Creates a new instance of the [SentryConfig] with the given parameters.
  ///
  /// Throws an [ArgumentError] if the given [authToken] is `null`.
  /// Throws an [ArgumentError] if the given [organizationSlug] is `null`.
  /// Throws an [ArgumentError] if the given [projectSlug] is `null`.
  /// Throws an [ArgumentError] if the given [projectDsn] is `null`.
  /// Throws an [ArgumentError] if the given [releaseName] is `null`.
  SentryConfig({
    @required this.authToken,
    @required this.organizationSlug,
    @required this.projectSlug,
    @required this.projectDsn,
    @required this.releaseName,
  }) {
    ArgumentError.checkNotNull(authToken, 'authToken');
    ArgumentError.checkNotNull(organizationSlug, 'organizationSlug');
    ArgumentError.checkNotNull(projectSlug, 'projectSlug');
    ArgumentError.checkNotNull(projectDsn, 'projectDsn');
    ArgumentError.checkNotNull(releaseName, 'releaseName');
  }

  /// Creates a new instance of the [SentryConfig] from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory SentryConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SentryConfig(
      authToken: json['auth_token'] as String,
      organizationSlug: json['organization_slug'] as String,
      projectSlug: json['project_slug'] as String,
      projectDsn: json['project_dsn'] as String,
      releaseName: json['release_name'] as String,
    );
  }
}
