// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/sentry/model/sentry_project.dart';
import 'package:cli/services/sentry/model/sentry_release.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SentryRelease", () {
    const name = 'name';
    const orgSlug = 'testOrgSlug';
    const projectSlug = 'testProjectSlug';

    final project = SentryProject(
      organizationSlug: orgSlug,
      projectSlug: projectSlug,
    );

    test(
      "throws an ArgumentError if the given name is null",
      () {
        expect(
          () => SentryRelease(name: null, project: project),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given project is null",
      () {
        expect(
          () => SentryRelease(name: name, project: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final release = SentryRelease(name: name, project: project);

        expect(release.name, equals(name));
        expect(release.project, equals(project));
      },
    );

    test(
      "equals to another SentryRelease with the same parameters",
      () {
        final expected = SentryRelease(name: name, project: project);
        final sentryRelease = SentryRelease(name: name, project: project);

        expect(sentryRelease, equals(expected));
      },
    );
  });
}
