// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/sentry/cli/sentry_cli.dart';
import 'package:cli/services/sentry/model/sentry_project.dart';
import 'package:cli/services/sentry/model/sentry_release.dart';
import 'package:cli/services/sentry/model/source_map.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SentryCli", () {
    const path = 'path';
    const extensions = ['js'];
    const name = 'name';
    const organizationSlug = 'organizationSlug';
    const projectSlug = 'projectSlug';

    final sentryCli = SentryCli();
    final sourceMap = SourceMap(path: path, extensions: extensions);
    final sentryProject = SentryProject(
      organizationSlug: organizationSlug,
      projectSlug: projectSlug,
    );
    final sentryRelease = SentryRelease(name: name, project: sentryProject);

    test(
      ".createRelease() throws an ArgumentError if the given release is null",
      () {
        expect(
          () => sentryCli.createRelease(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".uploadSourceMaps() throws an ArgumentError if the given release is null",
      () {
        expect(
          () => sentryCli.uploadSourceMaps(null, sourceMap),
          throwsArgumentError,
        );
      },
    );

    test(
      ".uploadSourceMaps() throws an ArgumentError if the given source map is null",
      () {
        expect(
          () => sentryCli.uploadSourceMaps(sentryRelease, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".finalizeRelease() throws an ArgumentError if the given release is null",
      () {
        expect(
          () => sentryCli.finalizeRelease(null),
          throwsArgumentError,
        );
      },
    );
  });
}
