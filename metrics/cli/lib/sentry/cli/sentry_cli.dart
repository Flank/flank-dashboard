// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';
import 'package:cli/sentry/model/sentry_release.dart';
import 'package:cli/sentry/model/source_map.dart';

/// A class that represents the Sentry [Cli].
class SentryCli extends Cli {
  @override
  final String executable = 'sentry-cli';

  /// Logs in to the Sentry CLI.
  Future<void> login() {
    return run(['login']);
  }

  /// Creates a Sentry release with the given [releaseName]
  /// within the given [project].
  Future<void> createRelease(SentryRelease release) {
    final project = release.project;

    return run([
      'releases',
      '--org=${project.organizationSlug}',
      '--project=${project.projectSlug}',
      'new',
      release.name,
    ]);
  }

  /// Uploads source maps of the files with the given [extensions] located
  /// in the [sourcePath] to the release with the given [releaseName] within
  /// the given [project].
  ///
  /// If the [extensions] are not specified, source maps of all files
  /// are uploaded.
  Future<void> uploadSourceMaps(
    SentryRelease release,
    SourceMap sourceMap,
  ) {
    final project = release.project;
    final extensions = sourceMap.extensions;
    final parameters = [
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

  /// Finalizes the release with the given [releaseName]
  /// within the given [project].
  Future<void> finalizeRelease(SentryRelease release) {
    final project = release.project;

    return run([
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
