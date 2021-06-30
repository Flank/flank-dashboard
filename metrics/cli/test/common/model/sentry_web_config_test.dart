// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/sentry_web_config.dart';
import 'package:test/test.dart';

void main() {
  group("SentryWebConfig", () {
    const dsn = 'sentryDsn';
    const environment = 'sentryEnvironment';
    const release = 'sentryRelease';

    test(
      "creates an instance with the given values",
      () {
        const config = SentryWebConfig(
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
      "equals to another SentryWebConfig with the same parameters",
      () {
        const expected = SentryWebConfig(
          dsn: dsn,
          environment: environment,
          release: release,
        );
        const sentryWebConfig = SentryWebConfig(
          dsn: dsn,
          environment: environment,
          release: release,
        );

        expect(sentryWebConfig, equals(expected));
      },
    );
  });
}
