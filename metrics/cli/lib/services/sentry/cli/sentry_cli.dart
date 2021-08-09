// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/cli/auth_cli.dart';
import 'package:cli/services/common/cli/cli.dart';
import 'package:cli/services/sentry/model/sentry_release.dart';
import 'package:cli/services/sentry/model/source_map.dart';

/// A class that represents the Sentry [Cli].
class SentryCli extends AuthCli {
  @override
  final String executable = 'sentry-cli';

  @override
  String get authArgumentName => 'auth-token';

  @override
  bool get isAuthLeading => true;

  /// Logs in to the Sentry CLI.
  Future<void> login() {
    return run(['login']);
  }

  /// Creates a Sentry release using the given [release].
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  Future<void> createRelease(SentryRelease release) {
    ArgumentError.checkNotNull(release);

    final project = release.project;

    return runWithAuth(
      [
        'releases',
        '--org=${project.organizationSlug}',
        '--project=${project.projectSlug}',
        'new',
        release.name,
      ],
    );
  }

  /// Uploads source maps of the files located in the [SourceMap.path] with
  /// the specified [SourceMap.extensions] to the given Sentry [release].
  /// If the [SourceMap.extensions] are not specified, source maps of all files
  /// are uploaded.
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  /// Throws an [ArgumentError] if the given [sourceMap] is `null`.
  Future<void> uploadSourceMaps(
    SentryRelease release,
    SourceMap sourceMap,
  ) {
    ArgumentError.checkNotNull(release);
    ArgumentError.checkNotNull(sourceMap);

    final project = release.project;
    final extensions = sourceMap.extensions;
    final arguments = [
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
        arguments.add('--ext=$extension');
      }
    }

    return runWithAuth(arguments);
  }

  /// Finalizes the given [release].
  ///
  /// Throws an [ArgumentError] if the given [release] is `null`.
  Future<void> finalizeRelease(SentryRelease release) {
    ArgumentError.checkNotNull(release);

    final project = release.project;

    return runWithAuth(
      [
        'releases',
        '--org=${project.organizationSlug}',
        '--project=${project.projectSlug}',
        'finalize',
        release.name,
      ],
    );
  }

  @override
  Future<ProcessResult> version() {
    return run(['--version'], attachOutput: false);
  }
}
