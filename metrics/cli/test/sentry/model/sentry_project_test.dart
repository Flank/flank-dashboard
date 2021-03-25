// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/sentry/model/sentry_project.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group('SentryProject', () {
    const slug = 'testSlug';

    test(
      "throws an ArgumentError if the given organization slug is null",
      () {
        expect(
          () => SentryProject(organizationSlug: null, projectSlug: slug),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given project slug is null",
      () {
        expect(
          () => SentryProject(organizationSlug: slug, projectSlug: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "successfully creates with the given required parameters",
      () {
        expect(
          () => SentryProject(organizationSlug: slug, projectSlug: slug),
          returnsNormally,
        );
      },
    );
  });
}
