// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/sentry/model/sentry_project.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SentryProject", () {
    const orgSlug = 'testOrgSlug';
    const projectSlug = 'testProjectSlug';
    test(
      "throws an ArgumentError if the given organization slug is null",
      () {
        expect(
          () => SentryProject(organizationSlug: null, projectSlug: projectSlug),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given project slug is null",
      () {
        expect(
          () => SentryProject(organizationSlug: orgSlug, projectSlug: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final project = SentryProject(
          organizationSlug: orgSlug,
          projectSlug: projectSlug,
        );

        expect(project.organizationSlug, equals(orgSlug));
        expect(project.projectSlug, equals(projectSlug));
      },
    );

    test(
      "equals to another SentryProject with the same parameters",
      () {
        final expected = SentryProject(
          organizationSlug: orgSlug,
          projectSlug: projectSlug,
        );
        final sentryProject = SentryProject(
          organizationSlug: orgSlug,
          projectSlug: projectSlug,
        );

        expect(sentryProject, equals(expected));
      },
    );
  });
}
