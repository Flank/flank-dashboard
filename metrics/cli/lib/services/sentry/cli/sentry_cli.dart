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
  /// Authenticates the release creation process using the given
  /// [authToken] if it is not `null`. Otherwise, authenticates using
  /// the global Sentry token.
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  Future<void> createRelease(SentryRelease release, [String authToken]) {
    ArgumentError.checkNotNull(release);

    final project = release.project;
    final arguments = _createArguments(
      authToken,
      [
        'releases',
        '--org=${project.organizationSlug}',
        '--project=${project.projectSlug}',
        'new',
        release.name,
      ],
    );

    return run(arguments);
  }

  /// Uploads source maps of the files located in the [SourceMap.path] with
  /// the specified [SourceMap.extensions] to the given Sentry [release].
  /// If the [SourceMap.extensions] are not specified, source maps of all files
  /// are uploaded.
  ///
  /// Authenticates the source maps uploading process using the given
  /// [authToken] if it is not `null`. Otherwise, authenticates using
  /// the global Sentry token.
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
    final arguments = _createArguments(
      authToken,
      [
        'releases',
        '--org=${project.organizationSlug}',
        '--project=${project.projectSlug}',
        'files',
        release.name,
        'upload-sourcemaps',
        sourceMap.path,
        '--rewrite',
      ],
    );

    if (extensions != null) {
      for (final extension in extensions) {
        arguments.add('--ext=$extension');
      }
    }

    return run(arguments);
  }

  /// Finalizes the given [release].
  ///
  /// Authenticates the release finalizing process using the given
  /// [authToken] if it is not `null`. Otherwise, authenticates using
  /// the global Sentry token.
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  Future<void> finalizeRelease(SentryRelease release, [String authToken]) {
    ArgumentError.checkNotNull(release);

    final project = release.project;
    final arguments = _createArguments(
      authToken,
      [
        'releases',
        '--org=${project.organizationSlug}',
        '--project=${project.projectSlug}',
        'finalize',
        release.name,
      ],
    );

    return run(arguments);
  }

  @override
  Future<void> version() {
    return run(['--version']);
  }

  /// Creates a list of arguments from the given [arguments] with an auth token
  /// argument if the given [authToken] is not `null`.
  List<String> _createArguments(String authToken, List<String> arguments) {
    if (authToken != null) {
      final tokenArgumentList = ['--auth-token=$authToken'];

      return tokenArgumentList..addAll(arguments);
    }

    return arguments;
  }
}
