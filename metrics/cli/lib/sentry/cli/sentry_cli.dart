// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';
import 'package:cli/sentry/model/sentry_project.dart';

/// A class that represents the Sentry [Cli].
class SentryCli extends Cli {
  @override
  final String executable = 'sentry-cli';

  /// Logins into the Sentry CLI.
  Future<void> login() {
    return run(['login']);
  }

  /// Creates a Sentry release with the given [releaseName]
  /// within the given [project].
  Future<void> createRelease(String releaseName, SentryProject project) {
    return run([
      'releases',
      '--org=${project.organizationSlug}',
      '--project=${project.projectSlug}',
      'new',
      releaseName,
    ]);
  }

  /// Uploads files with the given [extensions] located in the [sourcePath]
  /// to the release with the given [releaseName] within the given [project].
  ///
  /// If the [extensions] is not specified, all files are uploaded.
  Future<void> uploadSourceMaps(
    String sourcePath,
    List<String> extensions,
    SentryProject project,
    String releaseName,
  ) {
    final extensionList = <String>[];
    if (extensions != null) {
      for (final extension in extensions) {
        extensionList..add('--ext')..add(extension);
      }
    }

    return run([
      'releases',
      '--org=${project.organizationSlug}',
      '--project=${project.projectSlug}',
      'files',
      releaseName,
      'upload-sourcemaps',
      sourcePath,
      ...extensionList,
      '--rewrite',
    ]);
  }

  /// Finalizes the release with the given [releaseName]
  /// within the given [project].
  Future<void> finalizeRelease(String releaseName, SentryProject project) {
    return run([
      'releases',
      '--org=${project.organizationSlug}',
      '--project=${project.projectSlug}',
      'finalize',
      releaseName,
    ]);
  }

  @override
  Future<void> version() {
    return run(['--version']);
  }
}
