// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/cli/cli.dart';
import 'package:cli/services/sentry/model/sentry_release.dart';
import 'package:cli/services/sentry/model/source_map.dart';

/// A class that represents the Sentry [Cli].
class SentryCli extends Cli {
  @override
  final String executable = 'sentry-cli';

  /// Logs in to the Sentry CLI.
  Future<void> login() {
    return run(['login']);
  }

  /// Creates a Sentry release using the given [release].
  ///
  /// The [authToken] is an optional parameter for direct Sentry authentication.
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  Future<void> createRelease(SentryRelease release, [String authToken]) {
    ArgumentError.checkNotNull(release);

    final project = release.project;

    return run([
      if (authToken != null) '--auth-token=$authToken',
      'releases',
      '--org=${project.organizationSlug}',
      '--project=${project.projectSlug}',
      'new',
      release.name,
    ]);
  }

  /// Uploads source maps of the files located in the [SourceMap.path] with
  /// the specified [SourceMap.extensions] to the given Sentry [release].
  /// If the [SourceMap.extensions] are not specified, source maps of all files
  /// are uploaded.
  ///
  /// The [authToken] is an optional parameter for direct Sentry authentication.
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  /// Throws an [ArgumentError] if the given [sourceMap] is `null`.
  Future<void> uploadSourceMaps(
    SentryRelease release,
    SourceMap sourceMap, [
    String authToken,
  ]) {
    ArgumentError.checkNotNull(release);
    ArgumentError.checkNotNull(sourceMap);

    final project = release.project;
    final extensions = sourceMap.extensions;
    final parameters = [
      if (authToken != null) '--auth-token=$authToken',
      'releases',
      '--org=${project.organizationSlug}',
      '--project=${project.projectSlug}',
      'files',
      release.name,
      'upload-sourcemaps',
      sourceMap.path,
      '--rewrite',
    ];

    if (extensions != null) {
      for (final extension in extensions) {
        parameters.add('--ext=$extension');
      }
    }

    return run(parameters);
  }

  /// Finalizes the given [release].
  ///
  /// The [authToken] is an optional parameter for direct Sentry authentication.
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  Future<void> finalizeRelease(SentryRelease release, [String authToken]) {
    ArgumentError.checkNotNull(release);

    final project = release.project;

    return run([
      if (authToken != null) '--auth-token=$authToken',
      'releases',
      '--org=${project.organizationSlug}',
      '--project=${project.projectSlug}',
      'finalize',
      release.name,
    ]);
  }

  @override
  Future<void> version() {
    return run(['--version']);
  }
}
