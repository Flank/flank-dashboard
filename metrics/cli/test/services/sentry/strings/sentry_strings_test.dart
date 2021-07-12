// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/sentry/strings/sentry_strings.dart';
import 'package:test/test.dart';

void main() {
  group("SentryStrings", () {
    const organizationSlug = 'organizationSlug';
    const projectSlug = 'projectSlug';

    test(
      ".enterProjectSlug() returns a message that contains the given organization slug",
      () {
        expect(
          SentryStrings.enterProjectSlug(organizationSlug),
          contains(organizationSlug),
        );
      },
    );

    test(
      ".enterDsn() returns a message that contains the given organization slug",
      () {
        expect(
          SentryStrings.enterDsn(organizationSlug, projectSlug),
          contains(organizationSlug),
        );
      },
    );

    test(
      ".enterDsn() returns a message that contains the given project slug",
      () {
        expect(
          SentryStrings.enterDsn(organizationSlug, projectSlug),
          contains(projectSlug),
        );
      },
    );
  });
}
