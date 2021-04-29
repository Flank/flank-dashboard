// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/sentry/model/sentry_config.dart';
import 'package:test/test.dart';

void main() {
  group("SentryConfig", () {
    const dsn = 'sentryDsn';
    const environment = 'sentryEnvironment';
    const release = 'sentryRelease';

    test(
      "creates an instance with the given values",
      () {
        const config = SentryConfig(
          dsn: dsn,
          environment: environment,
          release: release,
        );

        expect(config.dsn, equals(dsn));
        expect(config.environment, equals(environment));
        expect(config.release, equals(release));
      },
    );

    test(
      "equals to another SentryConfig with the same parameters",
      () {
        const expected = SentryConfig(
          dsn: dsn,
          environment: environment,
          release: release,
        );
        const sentryConfig = SentryConfig(
          dsn: dsn,
          environment: environment,
          release: release,
        );

        expect(sentryConfig, equals(expected));
      },
    );
  });
}
